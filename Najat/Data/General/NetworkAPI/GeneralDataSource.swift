//
//  GeneralDataSource.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

struct GeneralDataSource {
    
    let categoryAPI: any RequestMaker<[Category]> = NetworkWrapper(url: .path("general/categories"), method: .get)
    let bannersAPI: any RequestMaker<[Banners]> = NetworkWrapper(url: .path("general/banners"), method: .get)
    let productsAPI: any RequestMaker<ProductsModelData> = NetworkWrapper(url: .path("products"), method: .get)
    let areasAPI: any RequestMaker<[AreaEntity]> = NetworkWrapper(url: .path("general/areas"), method: .get)
    let subCategoryAPI: any RequestMaker<[Category]> = NetworkWrapper(url: .path("general/subcategories"), method: .get)
    let productDetailsAPI: any RequestMaker<Products> = NetworkWrapper(url: .path("products"), method: .get)
    let addToCartAPI: any RequestMaker<AddToCartModel> = NetworkWrapper(url: .path("cart"), method: .post)
    let addToFavoriteAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/favourite"), method: .post)
    let getFavoriteAPI: any RequestMaker<ProductsModelData> = NetworkWrapper(url: .path("user/favourites"), method: .get)
   
    let getFavoritesFilesListAPI: any RequestMaker<[FavoriteFilesListModelData]> = NetworkWrapper(url: .path("user/favourite-category"), method: .get)
   
    let addFavoritesFilesAPI: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/favourite-category"), method: .post)

    
    
    let storeDetailsAPI: any RequestMaker<Store> = NetworkWrapper(url: .path("show/store"), method: .get)
    let paymentsAPI: any RequestMaker<[PaymentsEntity]> = NetworkWrapper(url: .path("general/payment-methods"), method: .get)
    let switchAccountAPI: any RequestMaker<UserDataModel> = NetworkWrapper(url: .path("auth/switch-account"), method: .post)

    let getOrdersAPI: any RequestMaker<OrdersModel> = NetworkWrapper(url: .path("orders"), method: .get)
    
    let getOrderDetailsAPI: any RequestMaker<OrderDetailsModelData> = NetworkWrapper(url: .path("orders"), method: .get)
    
    
    let getQuestions: any RequestMaker<[QuestionsModelData]> = NetworkWrapper(url: .path("general/faqs"), method: .get)
    let getSettings: any RequestMaker<String> = NetworkWrapper(url: .path("general/setting"), method: .get)

    let sendContactUs: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("general/contact-us"), method: .post)

    let getContacts: any RequestMaker<ContactsModel> = NetworkWrapper(url: .path("general/socials"), method: .get)

    
}
