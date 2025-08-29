//
//  ProductDetailsViewModel.swift
//  Najat
//
//  Created by rania refaat on 30/07/2024.
//

import Combine
import Foundation

class ProductDetailsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var productData: Products?
    @Published var reloadProducts = false
    @Published var cartCount: Int?

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

extension ProductDetailsViewModel {
    
    @MainActor
    func getProductDetails(productID: Int) async {
        loadingIndicator = .loading
        
        let products = await generalUseCase.getProductDetails(productID)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
            productData = data
            reloadProducts = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func addToCart(productID: Int) async {
        loadingIndicator = .loading
        
        let products = await generalUseCase.addToCart(productID)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
            cartCount = data.cart_count
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    func addToFavorite(productID: Int, fileID: Int) async {
        loadingIndicator = .loading
        let products = await generalUseCase.addToFavorite(productID, fileID: fileID)

        switch products {
        case .success(let data):
            loadingIndicator = .success(())
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
