//
//  MyAccountsViewModel.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import Combine
import Foundation

class MyAccountsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    
    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol
    var switchAccountState: PassthroughSubject<Void, Never> = .init()

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
    }
}

extension MyAccountsViewModel {
    
    @MainActor
    func attemptSwitchAccount(accountID: Int) async {
        loadingIndicator = .loading
        
        let account = await generalUseCase.switchAccount(accountID)
        
        switch account {
        case .success(let user):
            loadingIndicator = .success(())
            UserDefaults.userData = user
            switchAccountState.send(())
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
enum CardState {
    case expanded
    case collapsed
}
