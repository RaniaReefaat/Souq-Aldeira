//
//  UserMainProfileViewModel.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Combine
import Foundation

class UserMainProfileViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal

    var setUserDataState: PassthroughSubject<Void, Never> = .init()
    @Published var setUserLogoutDataState = false

    private let coordinator: CoordinatorProtocol
    private var profileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
}

extension UserMainProfileViewModel {
    @MainActor
    func getProfileData() async {
        loadingIndicator = .loading
        
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
        
        let userData = await profileUseCase.logout()
        
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
}
