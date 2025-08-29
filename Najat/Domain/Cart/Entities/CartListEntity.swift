//
//  CartListEntity.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

// MARK: - CartListEntity
struct CartListEntity: Codable {
    var id: Int?
    var store: Store?
    var productsCount: Int?

    enum CodingKeys: String, CodingKey {
        case id, store
        case productsCount = "products_count"
    }
}
// MARK: - CartListEntity
struct CartListEntityModel: Codable {
    let count: Int?
    let carts: [CartListEntity]?
}
