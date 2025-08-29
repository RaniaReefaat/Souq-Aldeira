//
//  ProductsModel.swift
//  Najat
//
//  Created by rania refaat on 28/07/2024.
//

import Foundation

// MARK: - ProductsModel
struct ProductsModel: Codable {
    let status: Bool?
    let message: String?
    let data: ProductsModelData?
}

// MARK: - ProductsModelData
struct ProductsModelData: Codable {
    let products: ProductItemModelData?
    let paginate: Paginate?
    let cart_count: Int?
}
// MARK: - ProductsModelData
struct ProductItemModelData: Codable {
    let items: [Products]?
}
// MARK: - Item
struct Products: Codable {
    let id: Int?
    let name, description, price: String?
    let qty, likes: Int?
    let createdAt: String?
    let media: [Media]?
    let store: Store?
    let category, subcategory: Category?
    let isVisible: Int?
    var isFavourite: Bool?
    let shareLink: String?
    let isBestSeller: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, price, qty, likes
        case createdAt = "created_at"
        case store, category, subcategory
        case isVisible = "is_visible"
        case isFavourite = "is_favourite"
        case media
        case shareLink = "shareLnk"
        case isBestSeller = "is_most_sold"
    }
}
struct Media: Codable {
    let id: Int?
    let file: String?
    let isImage: Bool?

    enum CodingKeys: String, CodingKey {
        case id, file
        case isImage = "is_image"
    }

}
// MARK: - Store
struct Store: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var bio, whatsapp, email, role: String?
    var products: [StoreProduct]?
    var shareLnk: String?
    var is_followed: Bool?
    var receive_notifications: Bool?
    var products_count: Int?
    var followers: Int?
    var followings: Int?
    var delivery_fee: String?
    var license: String?
    var token: String?
    var users: [UserDataModel]?

}

// MARK: - Product
struct StoreProduct: Codable {
    let id: Int?
    let image: String?
}
