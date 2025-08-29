//
//  NotificationsEntity.swift
//  App
//
//  Created by Ahmed Taha on 15/02/2024.
//

import Foundation

struct NotificationsEntity: Codable {
    let id: String?
    let isReaded: Bool?
    let readAt: String?
    let createdTime, createdAt: String?
    let notifyType: String?
    let notifyID: Int?
    let notifyStatus: String?
    let orderID: Int?
    let orderType: String?
    let title: String?
    let body: String?
    let image: String?
    let senderData: SenderDataEntity?

    enum CodingKeys: String, CodingKey {
        case id
        case isReaded = "is_readed"
        case readAt = "read_at"
        case createdTime = "created_time"
        case createdAt = "created_at"
        case notifyType = "notify_type"
        case notifyID = "notify_id"
        case notifyStatus = "notify_status"
        case orderID = "order_id"
        case orderType = "order_type"
        case title, body
        case senderData = "sender_data"
        case image
    }
}

struct SenderDataEntity: Codable {
    let id: Int?
    let fullName: String?
    let avatar: String?
    let fullname: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case avatar, fullname
    }
}
