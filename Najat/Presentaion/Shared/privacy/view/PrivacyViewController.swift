//
//  PrivacyViewController.swift
//  Edrak
//
//  Created by rania refaat on 22/08/2023.
//

import UIKit

class PrivacyViewController: BaseController {
    
    @IBOutlet weak var textView: UITextView!
    
    private lazy var viewModel: SettingsViewModel = {
        SettingsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(AppStrings.privacy.message)
        bind()
        let lang = L102Language.getCurrentLanguage()
        if lang == "ar" {
            textView.textAlignment = .right
        }else{
            textView.textAlignment = .left
        }
    }
    
}
// MARK: Binding
extension PrivacyViewController {
    private func bind() {
        bindLoadingIndicator()
        bindReloadData()
        getSettingsData()
    }
    func getSettingsData() {
        Task {
            await viewModel.getSettings(key: "privacy")
        }
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }

    private func bindReloadData() {
        viewModel.$settingsData.sink { [weak self] data in
            guard let self else { return }
            textView.text = data
        }.store(in: &cancellable)
    }
}
