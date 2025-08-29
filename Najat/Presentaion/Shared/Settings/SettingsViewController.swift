//
//  SettingsViewController.swift
//  Najat
//
//  Created by rania refaat on 24/08/2024.
//

import UIKit

class SettingsViewController: BaseController {
    
    @IBOutlet weak var langButton: AppFontButton!
    @IBOutlet weak var switchButton: UISwitch!
    
    let lang = L102Language.getCurrentLanguage()
    
    private lazy var viewModel: SettingsViewModel = {
        SettingsViewModel(coordinator: coordinator)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle(AppStrings.settings.message)
        setUserData()
        bind()
    }
    @IBAction func languageButtonTapped(_ sender: AppFontButton) {
        changeLanguage()
    }
    @IBAction func switchButtonTapped(_ sender: UISwitch) {
//        switchButton.isOn.toggle()
        print(switchButton.isOn)
        var receive_notifications = Int()
        if switchButton.isOn {
//            switchButton.setOn(false, animated: true)
            receive_notifications = 1
        }else{
//            switchButton.setOn(true, animated: true)
            receive_notifications = 0
        }
        let body = UpdateUserProfileBody(receive_notifications: receive_notifications)
        Task {
            await viewModel.updateUserProfileData(body: body, isSetting: true)
        }
    }
    
}
extension SettingsViewController{
    private func changeLanguage(){
        switch lang {
        case "ar":
            L102Language.setAppleLanguageTo(lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaults.UserSelectLang = lang
        case "en":
            L102Language.setAppleLanguageTo(lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaults.UserSelectLang = lang
        default:
            print("")
        }
        AppDelegate.shared.restartApplication()
        
    }
    private func setUserData(){
        if lang == "ar" {
            langButton.setTitle(AppStrings.english.message, for: .normal)
        }else{
            langButton.setTitle(AppStrings.Arabic.message, for: .normal)
        }
        
        let receiveNotifications = UserDefaults.userData?.receiveNotifications ?? false
        
        if receiveNotifications {
            switchButton.setOn(true, animated: true)

        }else{
            switchButton.setOn(false, animated: true)
        }
    }
}
// MARK: Binding
extension SettingsViewController {
    private func bind() {
        bindLoadingIndicator()
        bindUpdateSuccessfully()
    }
    private func bindLoadingIndicator() {
        viewModel.$loadingIndicator.sink { [weak self] state in
            guard let self else { return }
            handleScreenState(state)
        }.store(in: &cancellable)
    }
    private func bindUpdateSuccessfully() {
        viewModel.$updateProfileStatusMessage.sink { [weak self] message in
            guard let self , (message != nil) else { return }
            self.setUserData()
            showAlert(with: message ?? "", title: .success)
        }.store(in: &cancellable)
    }
}
