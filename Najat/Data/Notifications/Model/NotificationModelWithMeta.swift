//
//  NotificationModelWithMeta.swift
//  App
//
//  Created by Ahmed Taha on 15/02/2024.
//

import Foundation

struct NotificationModelWithMeta {
    var data: [NotificationItem]
    var paginate: Paginate?
}
struct notificationModel : Codable{
    var items: [NotificationItem]
    var paginate: Paginate?
}
// MARK: - Item
struct NotificationItem: Codable {
    let id: String?
    let data: NotificationItemData?

}
// MARK: - Item
struct NotificationItemData: Codable {
    let body, title: String?
}
