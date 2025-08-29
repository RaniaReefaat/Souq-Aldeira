//
//  CartEntity.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

// MARK: - CartEntity
struct CartEntity: Codable {
    var id: Int?
    var store: Store?
    var items: [ItemEntity]?
    var subtotal, deliveryFee, total: Int?

    enum CodingKeys: String, CodingKey {
        case id, store, items, subtotal
        case deliveryFee = "delivery_fee"
        case total
    }
}

// MARK: - Item
struct ItemEntity: Codable {
    var id: Int?
    var product: ProductEntity?
    var qty: Int?
    var price: String?
    var total: Double?
}

// MARK: - Product
struct ProductEntity: Codable {
    var id: Int?
    var name: String?
    var image: String?
    var availableQty: Int?
    var isFavourite: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case availableQty = "available_qty"
        case isFavourite = "is_favourite"
    }
}
