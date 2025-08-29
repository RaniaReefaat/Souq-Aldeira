//
//  UserModel.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

// MARK: - UserDataModel
struct UserDataModel: Codable {
    let id: Int?
    let name: String?
    var phone: String?
    let role: UserType?
    let image, bio: String?
    let receiveNotifications: Bool?
    let productsCount, followings, likes, followers: Int?
    let stores: [Store]?
    var token: String?
    let user: AnotherUserDataModel?
    let lang: String?
    var products: [StoreProduct]?
    let orders: Int?
    let delivery_fee: String?
    let email: String?
    let shareLink: String?
    let whatsapp: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, phone, role, image, bio, stores, likes, email, whatsapp
        case receiveNotifications = "receive_notifications"
        case productsCount = "products_count"
        case shareLink = "shareLnk"
        case followings, token, user, lang, followers, products, orders, delivery_fee
    }
}
enum UserType: String , Codable {
    case user
    case store
}
// MARK: - UserDataModel
struct AnotherUserDataModel: Codable {
    let id: Int?
    let name: String?
    let phone: String?
    let role: UserType?
    let image, bio: String?
    let receiveNotifications: Bool?
    let productsCount, followings, likes: Int?
    let stores: [Store]?
    var token: String?
    let lang: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, phone, role, image, bio, stores, likes
        case receiveNotifications = "receive_notifications"
        case productsCount = "products_count"
        case followings, token, lang
    }
}
