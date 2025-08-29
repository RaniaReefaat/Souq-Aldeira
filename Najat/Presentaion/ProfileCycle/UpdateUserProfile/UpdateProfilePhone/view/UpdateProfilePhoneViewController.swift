//
//  UpdateProfilePhoneViewController.swift
//  Najat
//
//  Created by Rania Refat on 29/06/2025.
//

import UIKit

class UpdateProfilePhoneViewController: BaseController {
    
    @IBOutlet weak var phoneTF: AppFontTextField!
    private var phone: String

    private lazy var viewModel: UpdateProfilePhoneViewModel = {
        UpdateProfilePhoneViewModel(coordinator: coordinator)
    }()
    
    init(phone: String) {
        self.phone = phone
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(AppStrings.updateProfilePhone.message)
        bind()
        phoneTF.text = phone
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        var phone = phoneTF.text ?? ""
        var newStr = String()
        if phone.starts(with: "965") {
            newStr = String(phone.dropFirst(3))
        }else{
            newStr = phone
        }
        Task {
            await viewModel.attemptUpdateProfile(phone: newStr)
        }
        
    }
}
// MARK: Binding

extension UpdateProfilePhoneViewController {
    private func bind() {
        bindLoadingIndicator()
        bindCreateSuccess()
    }
    
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindCreateSuccess() {
        viewModel.successUpdateProfileState.sink { [weak self] in
            guard let self else { return }
            push(VerifyProfilePhoneViewController(phone: phoneTF.text ?? ""))
        }.store(in: &cancellable)
    }
}
