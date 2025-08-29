//
//  UpdateUserProfileViewModel.swift
//  Najat
//
//  Created by rania refaat on 28/08/2024.
//

import Combine
import Foundation

class UpdateUserProfileViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var successMessage = String()

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

extension UpdateUserProfileViewModel {
    
    @MainActor
    func attemptUpdateProfile(body: UpdateUserProfileBody, image: Data) async {
        loadingIndicator = .loading
        let data = getUploadData(image: image)
        let updateProfile = await profileUseCase.updateProfileData(body: body, isSetting: false, data: data)
        switch updateProfile {
        case .success(let data):
            loadingIndicator = .success(())
            successMessage = data.message ?? ""
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
    
    @Sendable
    func getUploadData(image: Data) -> [UploadData] {
        let uploadData: [UploadData] = [
            .init(data: image, name: "image"),
        ]
        return uploadData
    }
}
