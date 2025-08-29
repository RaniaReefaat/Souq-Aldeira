//
//  RegisterViewController.swift
//  Najat
//
//  Created by rania refaat on 09/06/2024.
//

import UIKit

class RegisterViewController: BaseController, UITextFieldDelegate {

    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet private weak var phoneTF: UITextField!
    @IBOutlet private weak var nameTF: UITextField!

    private var acceptTerms: Bool = true

    private lazy var viewModel: RegisterViewModel = {
        RegisterViewModel(coordinator: coordinator)
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneTF.keyboardType = .asciiCapableNumberPad
        bind()
        phoneTF.delegate = self


    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Get the updated text
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        return updatedText.count <= 8
    }
    @IBAction private func didTapTerms(_ sender: Any) {
        push(TermsViewController())
    }
    @IBAction private func didTapLogin(_ sender: Any) {
        popMe()
    }

    @IBAction private func didTapRegister(_ sender: Any) {
        attemptRegister()
    }
    @IBAction func acceptTermsButtonTapped(_ sender: UIButton) {
        setTermsImage()
    }
    private func setTermsImage(){
        acceptTerms.toggle()
        if acceptTerms{
            termsButton.setImage(.check, for: .normal)
        }else{
            termsButton.setImage(.unCheck, for: .normal)
            
        }
    }
}
// MARK: Input

extension RegisterViewController {
    
    private func attemptRegister() {
        var phone = phoneTF.text ?? ""
        var name = nameTF.text ?? ""

        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        print(newStr)
        let body = RegisterBody(
            phone: newStr,
            name: name,
            isSelectTerms: acceptTerms
        )
        
        Task {
            await viewModel.attemptRegister(body: body)
        }
    }
}

// MARK: Binding

extension RegisterViewController {
    private func bind() {
        bindLoadingIndicator()
        bindPhoneValidator()
        bindNameValidator()
        bindTermsValidator()
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
    private func bindNameValidator() {
        viewModel.$showNameValidation.sink { [weak self] error in
            guard let self, !error.isEmpty else { return }
            coordinator.showAlert(message: error , title: .error)
        }.store(in: &cancellable)
    }
    private func bindTermsValidator() {
        viewModel.$showTermsValidation.sink { [weak self] error in
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
