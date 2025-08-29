//
//  FollowersListViewModel.swift
//  Najat
//
//  Created by rania refaat on 04/09/2024.
//

import Combine
import Foundation

class FollowersListViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var followersArray: [FollowingStoresModel] = []

    @Published var reloadFollowers = false
    
    private let coordinator: CoordinatorProtocol
    private var profileUseCase: StoreProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: StoreProfileUseCaseProtocol = StoreProfileUseCase()
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
}

extension FollowersListViewModel {
    
    @MainActor
    func getFollowers() async {
        loadingIndicator = .loading
        
        let followers = await profileUseCase.getFollowers()
        
        switch followers {
        case .success(let data):
            loadingIndicator = .success(())
            followersArray = data
            reloadFollowers = true
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
    func deleteFollower(index: Int) async {
        let userID = followersArray[index].id ?? 0
        loadingIndicator = .loading
        
        let unFollow = await profileUseCase.removeFollowers(id: userID)
        
        switch unFollow {
        case .success(let data):
            loadingIndicator = .success(())
            followersArray.remove(at: index)
            reloadFollowers = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
}
extension FollowersListViewModel {
    
    var numberOfFollowers: Int {
        followersArray.count
    }
    
    func configFollowers(at index: Int) -> FollowingStoresModel {
        return followersArray[index]
    }
}
