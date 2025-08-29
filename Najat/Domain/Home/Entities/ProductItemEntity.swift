//
//  ProductItemEntity.swift
//  App
//
//  Created by Mohammed Balegh on 27/11/2023.
//

import Foundation

struct ProductItemEntity: Codable {
    var id: Int?
    var image: String?
    var images: [Image]?
    var name, desc: String?
    var isFav: Bool?
    var currency, code: String?
    var isReplace: Bool?
    var replaceTrans: String?
    var points, rateAvg, price: Double?
    var brand: Brand?
    let productIdInCart: Int?
    let inCartCount: Int?
    let inCart: Bool?
    let rating: Double?
    let isExpress: Bool?
    let variantID: Int?
    let title: String?
    let qty: Int?
    var percentage, priceAfter: Double?
    var type: String?
    var typeTrans: String?
    var hasProducts: Bool?
    var availableQuantity: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, image, images, name, desc
        case rateAvg = "rate_avg"
        case price, rating
        case isFav = "is_fav"
        case currency, code
        case isReplace = "is_replace"
        case replaceTrans = "replace_trans"
        case points, brand
        case productIdInCart = "product_id_in_cart"
        case inCartCount = "in_cart_count"
        case inCart = "in_cart"
        case isExpress = "is_express"
        case percentage, type
        case priceAfter = "price_after"
        case typeTrans = "type_trans"
        case hasProducts = "has_products"
        case availableQuantity = "available_quantity"
        case variantID = "variant_id"
        case title, qty
    }
}

struct Image: Codable {
    var id: Int?
    var image: String?
}

struct Brand: Codable {
    var id: Int?
    var title: String?
    var name: String?
    var image: String?
    var isSelected: Bool?
}
