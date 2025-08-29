//
//  HomeViewModel.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Combine
import Foundation

class HomeViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var categoryArray: [Category] = []
    @Published var bannerArray: [Banners] = []
    @Published var productsArray: [Products] = []

    @Published var reloadCategory = false
    @Published var reloadBanners = false
    @Published var reloadProducts = false
    @Published var cartCount = 0

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

extension HomeViewModel {
    
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
    func getBanners() async {
//        loadingIndicator = .loading
        
        let banners = await generalUseCase.getBanners()
        
        switch banners {
        case .success(let banners):
//            loadingIndicator = .success(())
            self.bannerArray = banners
            reloadBanners = true
            print(bannerArray)
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
    func getProducts() async {
        guard isLoadData() else {return}
        loadingIndicator = .loading
        
        let products = await generalUseCase.getProducts(page: currentPage, subcategoryID: nil)
        
        switch products {
        case .success(let data):
            loadingIndicator = .success(())
            lastPage = data.paginate?.totalPages ?? 1
            
            currentPage = data.paginate?.currentPage ?? 1
            
            productsArray.append(contentsOf: data.products?.items ?? [])
            cartCount = data.cart_count ?? 0
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
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        default:
            loadingIndicator = .failure(error.error)
        }
    }
    func changeISFavorite(index: Int){
        productsArray[index].isFavourite.toggle()
    }
    func clearProductsData(){
        productsArray = []
    }
    func viewWillAppear(){
        lastPage = 1
        currentPage = 0
        productsArray = []
        reloadProducts = true
    }
}
extension HomeViewModel {
    
    var numberOfCategory: Int {
        categoryArray.count
    }
    
    func configCategory(at index: Int) -> Category {
        print(categoryArray)
        return categoryArray[index - 1]
    }
    var numberOfBanners: Int {
        bannerArray.count
    }
    
    func configBanners(at index: Int) -> Banners {
        bannerArray[index]
    }
    var numberOfProducts: Int {
        productsArray.count
    }
    
    func configProducts(at index: Int) -> Products {
        return productsArray[index]
    }
}
