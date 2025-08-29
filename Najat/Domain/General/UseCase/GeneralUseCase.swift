//
//  GeneralUseCase.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

protocol GeneralUseCaseProtocol {
    mutating func getCategory() async -> Result<[Category], MyAppError>
    mutating func getBanners() async -> Result<[Banners], MyAppError>
    mutating func getProducts(page: Int, subcategoryID: Int?) async -> Result<ProductsModelData, MyAppError>
    mutating func getProductsByCategory(page: Int, categoryID: Int?) async -> Result<ProductsModelData, MyAppError>

    mutating func getArea() async -> Result<[AreaEntity], MyAppError>
    mutating func getSubCategory(_ categoryID: Int) async -> Result<[Category], MyAppError>
    mutating func getProductDetails(_ productID: Int) async -> Result<Products, MyAppError>
    mutating func addToCart(_ productID: Int) async -> Result<AddToCartModel, MyAppError>
    mutating func addToFavorite(_ productID: Int, fileID: Int) async -> Result<EmptyData, MyAppError>
    mutating func getFavorite(page: Int, fileID: Int) async -> Result<ProductsModelData, MyAppError>
    
    mutating func getFavoritesFileList() async -> Result<[FavoriteFilesListModelData], MyAppError>
    mutating func addFavoritesFile(name: String) async -> Result<EmptyData, MyAppError>

    
    mutating func getStoreDetails(_ storeID: Int) async -> Result<Store, MyAppError>
    mutating func getPayments() async -> Result<[PaymentsEntity], MyAppError>
    mutating func switchAccount(_ accountID: Int) async -> Result<UserDataModel, MyAppError>
    mutating func getOrder(_ page: Int) async -> Result<OrdersModel, MyAppError>
    mutating func getOrderDetails(_ orderID: Int) async -> Result<OrderDetailsModelData, MyAppError>
    
    mutating func getQuestions() async -> Result<[QuestionsModelData], MyAppError>
    mutating func getSettings(_ key: String) async -> Result<String,MyAppError>
    mutating func getContacts() async -> Result<ContactsModel,MyAppError>
    mutating func sendContactUS(_ body: ContactUSBody) async -> Result<BaseResponse<EmptyData>,MyAppError>

}

struct GeneralUseCase: GeneralUseCaseProtocol {


    var generalRepo: GeneralRequestRepoProtocol
    
    private var bag = AppBag()
    
    init(generalRepo: GeneralRequestRepoProtocol = GeneralRepoImplementation()) {
        self.generalRepo = generalRepo
    }
    
    mutating func getCategory() async -> Result<[Category], MyAppError> {
        
        return await generalRepo
            .getCategory()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getBanners() async -> Result<[Banners], MyAppError> {
        
        return await generalRepo
            .getBanner()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func getProducts(page: Int, subcategoryID: Int?) async -> Result<ProductsModelData, MyAppError> {
        
        return await generalRepo
            .getProducts(page: page, subcategoryID: subcategoryID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getProductsByCategory(page: Int, categoryID: Int?) async -> Result<ProductsModelData, MyAppError> {
        return await generalRepo
            .getProductsByCategory(page: page, categoryID: categoryID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func getSubCategory(_ categoryID: Int) async -> Result<[Category], MyAppError> {
        return await generalRepo
            .getSubcategory(categoryID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getProductDetails(_ productID: Int) async -> Result<Products, MyAppError> {
        return await generalRepo
            .getProductDetails(productID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getStoreDetails(_ storeID: Int) async -> Result<Store, MyAppError> {
        return await generalRepo
            .getStoreDetails(storeID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func addToCart(_ productID: Int) async -> Result<AddToCartModel, MyAppError> {
        return await generalRepo
            .addToCart(productID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func addToFavorite(_ productID: Int, fileID: Int) async -> Result<EmptyData, MyAppError> {
        return await generalRepo
            .addToFavorite(productID, fileID: fileID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    mutating func getFavorite(page: Int, fileID: Int) async -> Result<ProductsModelData, MyAppError> {
        return await generalRepo
            .getFavorite(page: page, fileID: fileID)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func getFavoritesFileList() async -> Result<[FavoriteFilesListModelData], MyAppError> {
        return await generalRepo
            .getFavoritesFilesList()
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func addFavoritesFile(name: String) async -> Result<EmptyData, MyAppError> {
        return await generalRepo
            .addFavoritesFile(name)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    
    
    
    mutating func getPayments() async -> Result<[PaymentsEntity], MyAppError> {
        return await generalRepo
            .getPayments()
            .singleOutput(with: &bag)
            .result()
    }
    
    mutating func getArea() async -> Result<[AreaEntity], MyAppError> {
        return await generalRepo
            .getArea()
            .singleOutput(with: &bag)
            .result()
    }
    mutating func switchAccount(_ accountID: Int) async -> Result<UserDataModel, MyAppError> {
        return await generalRepo
        .switchAccount(accountID)
        .singleOutput(with: &bag)
        .result()
    }
    mutating func getOrder(_ page: Int) async -> Result<OrdersModel, MyAppError> {
        return await generalRepo
        .getOrders(page: page)
        .singleOutput(with: &bag)
        .result()
    }
    
    mutating func getOrderDetails(_ orderID: Int) async -> Result<OrderDetailsModelData, MyAppError> {
        return await generalRepo
        .getOrderDetails(orderID)
        .singleOutput(with: &bag)
        .result()
    }
    mutating func getQuestions() async -> Result<[QuestionsModelData], MyAppError> {
        return await generalRepo
        .getQuestions()
        .singleOutput(with: &bag)
        .result()

    }
    
    mutating func getSettings(_ key: String) async ->Result<String, MyAppError> {
        return await generalRepo
        .getSettings(key)
        .singleOutput(with: &bag)
        .result()

    }
    
    mutating func getContacts() async -> Result<ContactsModel, MyAppError> {
        return await generalRepo
        .getContacts()
        .singleOutput(with: &bag)
        .result()
    }
    
    mutating func sendContactUS(_ body: ContactUSBody) async -> Result<BaseResponse<EmptyData>, MyAppError> {
        if case .failure(let error) = body.validateBody {
            return .failure(MyAppError.localValidation(error))
        }
        return await generalRepo
        .sendContactUS(body)
        .singleOutput(with: &bag)
        .resultWithMessage()
    }
    
}
