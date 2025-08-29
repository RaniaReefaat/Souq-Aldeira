//
//  GeneralRepoImplementation.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation
import Combine

struct GeneralRepoImplementation: GeneralRequestRepoProtocol {

    let network = GeneralDataSource()
    
    func getCategory() async -> RequestPublisher<[Category]> {
        return network.categoryAPI.makeRequest()

    }
    
    func getBanner() async -> RequestPublisher<[Banners]> {
        return network.bannersAPI.makeRequest()

    }

    func getProducts(page: Int, subcategoryID: Int?) async -> RequestPublisher<ProductsModelData> {
        var model: [String: Any] = ["page": page]
        if subcategoryID != nil {
            model["subcategory_id"] = subcategoryID!
        }
        return network.productsAPI.makeRequest(with: model)
    }
    func getProductsByCategory(page: Int, categoryID: Int?) async -> RequestPublisher<ProductsModelData> {
        var model: [String: Any] = ["page": page]
        if categoryID != nil {
            model["category_id"] = categoryID!
        }
        return network.productsAPI.makeRequest(with: model)
    }

    
    func getArea() async -> RequestPublisher<[AreaEntity]> {
        return network.areasAPI
            .makeRequest()
    }
    

    func getSubcategory(_ categoryID: Int) async -> RequestPublisher<[Category]> {
        return network.subCategoryAPI.addPathVariables(path: "/\(categoryID)").makeRequest()
    }
    func getProductDetails(_ productID: Int) async -> RequestPublisher<Products> {
        return network.productDetailsAPI.addPathVariables(path: "/\(productID)").makeRequest()

    }
    func addToCart(_ productID: Int) async -> RequestPublisher<AddToCartModel> {
        let model = ["product_id": productID , "qty": 1] as [String : Any]
        return network.addToCartAPI.makeRequest(with: model)

    }
    
    func addToFavorite(_ productID: Int, fileID: Int) async -> RequestPublisher<EmptyData> {
     var model = [String : Any]()
        if fileID == 0 {
            model = ["product_id": productID]
        }else{
            model = ["product_id": productID, "category_id": fileID]
        }
        
        return network.addToFavoriteAPI.makeRequest(with: model)

    }
    func getFavorite(page: Int, fileID: Int) async -> RequestPublisher<ProductsModelData> {
        let model: [String: Any] = ["page": page]
        return network.getFavoriteAPI.addPathVariables(path: "/\(fileID)").makeRequest(with: model)
    }
    func getFavoritesFilesList() async -> RequestPublisher<[FavoriteFilesListModelData]> {
        return network.getFavoritesFilesListAPI.makeRequest()
    }
    func addFavoritesFile(_ name: String) async -> RequestPublisher<EmptyData> {
        let model: [String: Any] = ["name": name]
        return network.addFavoritesFilesAPI.makeRequest(with: model)
    }
    
    
    func getStoreDetails(_ storeID: Int) async -> RequestPublisher<Store> {
        return network.storeDetailsAPI.addPathVariables(path: "/\(storeID)").makeRequest()
    }
    
    func getPayments() async -> RequestPublisher<[PaymentsEntity]> {
        return network.paymentsAPI
            .makeRequest()
    }
    func switchAccount(_ accountID: Int) async -> RequestPublisher<UserDataModel> {
        let model = ["account_id": accountID] as [String : Any]
        return network.switchAccountAPI.makeRequest(with: model)

    }
    
    func getOrders(page: Int) async -> RequestPublisher<OrdersModel> {
        var model: [String: Any] = ["page": page]
        return network.getOrdersAPI.makeRequest(with: model)
    }
    
    func getOrderDetails(_ orderID: Int) async -> RequestPublisher<OrderDetailsModelData> {
        return network.getOrderDetailsAPI.addPathVariables(path: "/\(orderID)").makeRequest()

    }
    
    func getQuestions() async -> RequestPublisher<[QuestionsModelData]> {
        return network.getQuestions.makeRequest()
    }
    
    func getSettings(_ key: String) async -> RequestPublisher<String> {
        return network.getSettings.addPathVariables(path: "/\(key)").makeRequest()
    }
    
    func sendContactUs(_ body: ContactUSBody) async -> RequestPublisher<EmptyData> {
        return network.sendContactUs.makeRequest(with: body)
    }
    

    func getContacts() async -> RequestPublisher<ContactsModel> {
        return network.getContacts.makeRequest()
    }
    
    func sendContactUS(_ body: ContactUSBody) async -> RequestPublisher<EmptyData> {
        return network.sendContactUs.makeRequest(with: body)
    }
    
}
