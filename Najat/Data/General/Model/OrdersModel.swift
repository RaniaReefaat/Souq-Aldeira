//
//  OrdersModel.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import Foundation

// MARK: - DataClass
struct OrdersModel: Codable {
    let items: [OrdersModelData]?
    let paginate: Paginate?
}

// MARK: - Item
struct OrdersModelData: Codable {
    let id: Int?
    let store: Store?
    let productsCount: Int?
    let total, statusTranslated, createdAt: String?
    var status: OrderStatus?
    let user: UserDataModel?
    
    enum CodingKeys: String, CodingKey {
        case id, store
        case productsCount = "products_count"
        case total
        case statusTranslated = "status_translated"
        case status, user
        case createdAt = "created_at"
    }
}
enum OrderStatus: String , Codable {
    case new
    case accepted
    case delivered
}

// MARK: - DataClass
struct OrderDetailsModelData: Codable {
    let id: Int?
    let store: Store?
    let productsCount: Int?
    let total, statusTranslated, createdAt: String?
    let status : OrderStatus?
    let user: UserDataModel?
    let paymentMethod: String?
    let address: Address?
    let items: [ProductItem]?

    enum CodingKeys: String, CodingKey {
        case id, store
        case productsCount = "products_count"
        case total
        case statusTranslated = "status_translated"
        case status
        case createdAt = "created_at"
        case user
        case paymentMethod = "payment_method"
        case address, items
    }
}

// MARK: - Address
struct Address: Codable {
    let id: Int?
    let name, address, lat, lng: String?
    let area: Area?
    let streetNo, homeNo, flatNo: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, lat, lng, area
        case streetNo = "street_no"
        case homeNo = "home_no"
        case flatNo = "flat_no"
    }
}
// MARK: - Item
struct ProductItem: Codable {
    let id: Int?
    let product: Product?
    let qty: Int?
    let price, total: String?
}

// MARK: - Product
struct Product: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let availableQty: Int?
    let isFavourite: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case availableQty = "available_qty"
        case isFavourite = "is_favourite"
    }
}

// MARK: - DataClass
struct AddToCartModel: Codable {
    let cart_count: Int?
}
