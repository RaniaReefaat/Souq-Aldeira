//
//  GeneralRepoInterface.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

protocol GeneralRequestRepoProtocol {
    func getCategory() async -> RequestPublisher<[Category]>
    func getBanner() async -> RequestPublisher<[Banners]>
    func getProducts(page: Int, subcategoryID: Int?) async -> RequestPublisher<ProductsModelData>
    func getProductsByCategory(page: Int, categoryID: Int?) async -> RequestPublisher<ProductsModelData>

    
    func getArea() async -> RequestPublisher<[AreaEntity]>
    func getSubcategory(_ categoryID: Int) async -> RequestPublisher<[Category]>
    func getProductDetails(_ productID: Int) async -> RequestPublisher<Products>
    func addToCart(_ productID: Int) async -> RequestPublisher<AddToCartModel>
    func addToFavorite(_ productID: Int, fileID: Int) async -> RequestPublisher<EmptyData>
    func getFavorite(page: Int, fileID: Int) async -> RequestPublisher<ProductsModelData>
    
    func getFavoritesFilesList() async -> RequestPublisher<[FavoriteFilesListModelData]>
    func addFavoritesFile(_ name: String) async -> RequestPublisher<EmptyData>

    
    func getStoreDetails(_ storeID: Int) async -> RequestPublisher<Store>
    func getPayments() async -> RequestPublisher<[PaymentsEntity]>
    func switchAccount(_ accountID: Int) async -> RequestPublisher<UserDataModel>
    func getOrders(page: Int) async -> RequestPublisher<OrdersModel>
    func getOrderDetails(_ orderID: Int) async -> RequestPublisher<OrderDetailsModelData>

    func getQuestions() async -> RequestPublisher<[QuestionsModelData]>
    func getSettings(_ key: String) async -> RequestPublisher<String>

    func getContacts() async -> RequestPublisher<ContactsModel>
    func sendContactUS(_ body: ContactUSBody) async -> RequestPublisher<EmptyData>

}
