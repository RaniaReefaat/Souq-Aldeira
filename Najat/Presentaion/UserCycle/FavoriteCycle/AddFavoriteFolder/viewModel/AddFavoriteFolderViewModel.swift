//
//  AddFavoriteFolderViewModel.swift
//  Najat
//
//  Created by rania refaat on 14/11/2024.
//

import Combine
import Foundation

class AddFavoriteFolderViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal

    @Published var addSuccess = false
    
    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
    }
}

extension AddFavoriteFolderViewModel {
    
    @MainActor
    func addFavoriteFile(name: String) async {
        loadingIndicator = .loading
        
        let list = await generalUseCase.addFavoritesFile(name: name )
        
        switch list {
        case .success(let data):
            loadingIndicator = .success(())
            addSuccess = true
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
