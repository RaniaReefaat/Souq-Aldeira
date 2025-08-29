//
//  FavoriteViewModel.swift
//  Najat
//
//  Created by rania refaat on 30/07/2024.
//

import Combine
import Foundation

class FavoriteViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var productsArray: [Products] = []

    @Published var reloadProducts = false
    
    private var lastPage = 1
    private var currentPage = 0
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

extension FavoriteViewModel {
    
    private func isLoadData() -> Bool{
        print(currentPage , "lastPage" , lastPage )
        if currentPage != lastPage {
            currentPage = currentPage + 1
            print(currentPage)
            return true
        }else {
            return false
        }
    }
    func viewWillAppear(){
        lastPage = 1
        currentPage = 0
        productsArray = []
    }
    @MainActor
    func getFavorites(fileID: Int) async {
        guard isLoadData() else {return}
        loadingIndicator = .loading
        
        let products = await generalUseCase.getFavorite(page: currentPage, fileID: fileID)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
            lastPage = data.paginate?.totalPages ?? 1
            currentPage = data.paginate?.currentPage ?? 1
            productsArray.append(contentsOf: data.products?.items ?? [])
            reloadProducts = true
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
    func addToCart(productID: Int) async {
        loadingIndicator = .loading
        
        let products = await generalUseCase.addToCart(productID)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
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
            reloadProducts = true

        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    func changeISFavorite(index: Int){
        productsArray.remove(at: index)
    }
}
extension FavoriteViewModel {
    
    var numberOfProducts: Int {
        productsArray.count
    }
    
    func configProducts(at index: Int) -> Products {
        return productsArray[index]
    }
}
