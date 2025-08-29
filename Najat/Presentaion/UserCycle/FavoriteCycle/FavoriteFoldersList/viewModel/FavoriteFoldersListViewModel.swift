//
//  FavoriteFoldersListViewModel.swift
//  Najat
//
//  Created by rania refaat on 14/11/2024.
//

import Combine
import Foundation

class FavoriteFoldersListViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var FavoriteFilesListArray: [FavoriteFilesListModelData] = []

    @Published var reloadList = false
    
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

extension FavoriteFoldersListViewModel {
    
    @MainActor
    func getFavoritesFilesList() async {
        loadingIndicator = .loading
        
        let list = await generalUseCase.getFavoritesFileList()
        
        switch list {
        case .success(let data):
            loadingIndicator = .success(())
            FavoriteFilesListArray = data
            reloadList = true
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
extension FavoriteFoldersListViewModel {
    
    var numberOfFiles: Int {
        FavoriteFilesListArray.count
    }
    
    func configFiles(at index: Int) -> FavoriteFilesListModelData {
        return FavoriteFilesListArray[index]
    }
}

