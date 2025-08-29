//
//  UpdateProfilePhoneViewModel.swift
//  Najat
//
//  Created by Rania Refat on 29/06/2025.
//

import Combine
import Foundation

class UpdateProfilePhoneViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    
    var successUpdateProfileState: PassthroughSubject<Void, Never> = .init()

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

extension UpdateProfilePhoneViewModel {
    
    @MainActor
    func attemptUpdateProfile(phone: String) async {
        loadingIndicator = .loading
        let updateProfile = await profileUseCase.updateProfilPhone(phone: phone)
        switch updateProfile {
        case .success(let data):
            loadingIndicator = .success(())
            successUpdateProfileState.send(())
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
