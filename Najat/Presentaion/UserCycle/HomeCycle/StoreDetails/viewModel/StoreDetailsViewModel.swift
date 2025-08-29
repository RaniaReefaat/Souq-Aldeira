//
//  StoreDetailsViewModel.swift
//  Najat
//
//  Created by rania refaat on 03/08/2024.
//

import Combine
import Foundation

class StoreDetailsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var storeData: Store?
    @Published var reloadStore = false
    
    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol
    private var profileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase(),
        profileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()

    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
        self.profileUseCase = profileUseCase

    }
}

extension StoreDetailsViewModel {
    
    @MainActor
    func getStoreDetails(storeID: Int) async {
        loadingIndicator = .loading
        
        let store = await generalUseCase.getStoreDetails(storeID)
        
        switch store {
        case .success(let data):
            loadingIndicator = .success(())
            storeData = data
            reloadStore = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func addAndRemoveFromFollowing(storeID: Int) async {
        loadingIndicator = .loading
        
        let unFollow = await profileUseCase.followStore(storeID: storeID)
        
        switch unFollow {
        case .success(let data):
            loadingIndicator = .success(())
            storeData?.is_followed.toggle()
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
