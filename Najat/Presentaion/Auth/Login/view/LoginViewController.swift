//
//  LoginViewController.swift
//  Najat
//
//  Created by rania refaat on 06/06/2024.
//

import UIKit

class LoginViewController: BaseController {

    @IBOutlet private weak var phoneTF: UITextField!

    private lazy var viewModel: LoginViewModel = {
        LoginViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        hideNavigationBar(status: true)
    }
    
    private func setupViews() {
        setupTextField()
    }
    
    @IBAction private func didTapLogin(_ sender: Any) {
        attemptLogin()
    }

    @IBAction private func didTapRegister(_ sender: Any) {
        push(RegisterViewController())
    }
    @IBAction private func didTapSkip(_ sender: Any) {
        AppWindowManger.openTabBar()
    }
}

// MARK: Input

extension LoginViewController {
    
    private func attemptLogin() {
        var phone = phoneTF.text ?? ""
        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        let body = LoginBody(
            phone: newStr
        )
        
        Task {
            await viewModel.attemptLogin(body: body)
        }
    }
}

// MARK: Binding

extension LoginViewController {
    private func bind() {
        bindLoadingIndicator()
        bindPhoneValidator()
        bindVerification()
    }
    
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    
    private func bindPhoneValidator() {
        viewModel.$showPhoneValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindVerification() {
        viewModel.verificationState.sink { [weak self] in
            guard let self else { return }
            var phone = phoneTF.text ?? ""
            var newStr = String()
            if phone.starts(with: "965") {
                 newStr = String(phone.dropFirst(3))
            }else{
                newStr = phone
            }
            push(VerifyAccountViewController(phone: "\(newStr)"))
        }.store(in: &cancellable)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    private func setupTextField() {
        phoneTF.delegate = self
        phoneTF.keyboardType = .asciiCapableNumberPad

    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
    }
}

//extension LoginViewController: SuccessfulAuthProtocol {
//    func successFinished(with body: LoginBody?) {
//        guard let body else { return }
////        push(VerificationCodeViewController(type: .quickLogin, loginBody: body, verificationType: type))
//    }
//}
