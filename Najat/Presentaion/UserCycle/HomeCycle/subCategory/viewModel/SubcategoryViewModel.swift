//
//  SubcategoryViewModel.swift
//  Najat
//
//  Created by rania refaat on 30/07/2024.
//

import Combine
import Foundation

class SubcategoryViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var subCategoryArray: [Category] = []

    @Published var reloadSubCategory = false
    @Published var productsArray: [Products] = []

    @Published var reloadProducts = false
    @Published var cartCount = 0
    @Published var showEmptyView = false

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

extension SubcategoryViewModel {
    
    @MainActor
    func getSubCategory(_ categoryID: Int) async {
        loadingIndicator = .loading
        
        let subCategory = await generalUseCase.getSubCategory(categoryID )
        
        switch subCategory {
        case .success(let category):
            loadingIndicator = .success(())
            self.subCategoryArray = category
            reloadSubCategory = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
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
    @MainActor
    func getProducts(categoryID: Int) async {
        guard isLoadData() else {return}
        loadingIndicator = .loading
        
        let products = await generalUseCase.getProductsByCategory(page: currentPage, categoryID: categoryID)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
            lastPage = data.paginate?.totalPages ?? 1
            currentPage = data.paginate?.currentPage ?? 1
            productsArray.append(contentsOf: data.products?.items ?? [])
            showEmptyView = productsArray.isEmpty
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
            cartCount = data.cart_count ?? 0

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
        productsArray[index].isFavourite.toggle()
    }
}
extension SubcategoryViewModel {
    
    var numberOfProducts: Int {
        productsArray.count
    }
    
    func configProducts(at index: Int) -> Products {
        return productsArray[index]
    }
}

extension SubcategoryViewModel {
    
    var numberOfSubCategory: Int {
        subCategoryArray.count
    }
    
    func configSubCategory(at index: Int) -> Category {
        return subCategoryArray[index]
    }
}
