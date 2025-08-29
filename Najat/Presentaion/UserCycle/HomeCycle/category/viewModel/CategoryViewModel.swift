//
//  CategoryViewModel.swift
//  Najat
//
//  Created by rania refaat on 29/07/2024.
//

import Combine
import Foundation

class CategoryViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var categoryArray: [Category] = []

    @Published var reloadCategory = false
    
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

extension CategoryViewModel {
    
    @MainActor
    func getCategory() async {
        loadingIndicator = .loading
        
        let category = await generalUseCase.getCategory()
        
        switch category {
        case .success(let category):
            loadingIndicator = .success(())
            self.categoryArray = category
            reloadCategory = true
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
extension CategoryViewModel {
    
    var numberOfCategory: Int {
        categoryArray.count
    }
    
    func configCategory(at index: Int) -> Category {
        print(categoryArray)
        return categoryArray[index]
    }
}
