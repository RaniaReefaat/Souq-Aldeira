//
//  FollowedStoresListViewModel.swift
//  Najat
//
//  Created by rania refaat on 02/08/2024.
//

import Combine
import Foundation

class FollowedStoresListViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var storesArray: [FollowingStoresModel] = []

    @Published var reloadStores = false
    
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

extension FollowedStoresListViewModel {
    
    @MainActor
    func getStores() async {
        loadingIndicator = .loading
        
        let stores = await profileUseCase.getFollowings()
        
        switch stores {
        case .success(let data):
            loadingIndicator = .success(())
            storesArray = data
            reloadStores = true
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
    func addToUnFollow(storeID: Int) async {
        loadingIndicator = .loading
        
        let unFollow = await profileUseCase.followStore(storeID: storeID)
        
        switch unFollow {
        case .success(let data):
            loadingIndicator = .success(())
            storesArray.removeAll(where: {$0.id == storeID})
            reloadStores = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
}
extension FollowedStoresListViewModel {
    
    var numberOfStores: Int {
        storesArray.count
    }
    
    func configStores(at index: Int) -> FollowingStoresModel {
        return storesArray[index]
    }
}
