//
//  SettingsViewModel.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import Combine
import Foundation

class SettingsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var settingsData = String()
    @Published var contactsData: ContactsModel = .init(phone: nil, twitter: nil, instagram: nil, snapchat: nil, tiktok: nil)

    @Published var sendContacts: String?
    @Published var getContacts = false

    @Published var updateProfileStatusMessage: String?

    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol
    private var userProfileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase(),
        userProfileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()

    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
        self.userProfileUseCase = userProfileUseCase
    }
}

extension SettingsViewModel {
    @MainActor
    func getSettings(key: String) async {
        loadingIndicator = .loading
        
        let settings = await generalUseCase.getSettings(key)
        
        switch settings {
        case .success(let data):
            loadingIndicator = .success(())
            settingsData = data
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        default:
            loadingIndicator = .failure(error.error)
        }
    }
    @MainActor
    func getContacts() async {
        loadingIndicator = .loading
        
        let contacts = await generalUseCase.getContacts()
        
        switch contacts {
        case .success(let data):
            loadingIndicator = .success(())
            contactsData = data
            getContacts = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func sendContactUS(body: ContactUSBody) async {
        loadingIndicator = .loading
        
        let contacts = await generalUseCase.sendContactUS(body)
        
        switch contacts {
        case .success(let data):
            loadingIndicator = .success(())
            print(data.message)
            
            sendContacts = data.message ?? ""
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func updateUserProfileData(body: UpdateUserProfileBody, isSetting: Bool) async {
        loadingIndicator = .loading
        
        let contacts = await userProfileUseCase.updateProfileData(body: body, isSetting: isSetting, data: [])
        
        switch contacts {
        case .success(let data):
            loadingIndicator = .success(())
            let token = UserDefaults.userData?.token ?? ""
            var userData = data.data
            userData?.token = token
            UserDefaults.userData = userData
            updateProfileStatusMessage = data.message ?? ""
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
}
