//
//  UpdateStoreProfileViewModel.swift
//  Najat
//
//  Created by rania refaat on 18/09/2024.
//

import Combine
import Foundation

class UpdateStoreProfileViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal

    var setUserDataState: PassthroughSubject<Void, Never> = .init()
    @Published var setUserLogoutDataState = false
    @Published var pricesArray: [String] = []
    @Published var reloadPrices = false
    @Published var successMessage = String()

    var successUpdateProfileState: PassthroughSubject<Void, Never> = .init()

    private let coordinator: CoordinatorProtocol
    private var profileUseCase: StoreProfileUseCaseProtocol
    private var userProfileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: StoreProfileUseCaseProtocol = StoreProfileUseCase(),
        userProfileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()

    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
        self.userProfileUseCase = userProfileUseCase

    }
}

extension UpdateStoreProfileViewModel {
    @MainActor
    func getProfileData() async {
//        loadingIndicator = .loading
        
        let userData = await profileUseCase.getProfileData()
        
        switch userData {
        case .success(let user):
            loadingIndicator = .success(())
            let token = UserDefaults.userData?.token ?? ""
            var userData = user
            userData.token = token
            UserDefaults.userData = userData
            setUserDataState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    
    @MainActor
    func logout() async {
        loadingIndicator = .loading
        
        let userData = await userProfileUseCase.logout()
        
        switch userData {
        case .success(let user):
            loadingIndicator = .success(())
            UserDefaults.userData = nil
            setUserLogoutDataState = true
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
    func getDeliveryPrice() async {
        loadingIndicator = .loading
        
        let deliveryPrice = await userProfileUseCase.getDeliveryPrice()
        
        switch deliveryPrice {
        case .success(let deliveryPrice):
            loadingIndicator = .success(())
            pricesArray = deliveryPrice
            reloadPrices = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func attemptUpdateProfile(body: UpdateUserProfileBody, image: Data?) async {
        loadingIndicator = .loading
        if image != nil {
            let data = getUploadData(image: image!)
            let updateProfile = await profileUseCase.updateProfileData(body: body, isSetting: false, data: data)
            switch updateProfile {
            case .success(let data):
                loadingIndicator = .success(())
                successMessage = data.message ?? ""
                successUpdateProfileState.send(())
            case .failure(let error):
                showError(with: error.errorHandler)
            }
        }else{
            let updateProfile = await profileUseCase.updateProfileData(body: body, isSetting: false, data: [])
            switch updateProfile {
            case .success(let data):
                loadingIndicator = .success(())
                successMessage = data.message ?? ""
                successUpdateProfileState.send(())
            case .failure(let error):
                showError(with: error.errorHandler)
            }

        }

    }
    @Sendable
    func getUploadData(image: Data) -> [UploadData] {
        let uploadData: [UploadData] = [
            .init(data: image, name: "image"),
        ]
        return uploadData
    }
}
