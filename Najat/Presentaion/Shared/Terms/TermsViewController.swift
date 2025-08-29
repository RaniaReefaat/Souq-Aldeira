//
//  TermsViewController.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import UIKit

class TermsViewController: BaseController {

    @IBOutlet weak var textView: UITextView!
    
    private lazy var viewModel: SettingsViewModel = {
        SettingsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTitle(AppStrings.terms.message)
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
extension TermsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindReloadData()
        getSettingsData()
    }
    func getSettingsData() {
        Task {
            await viewModel.getSettings(key: "terms")
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
