//
//  NotificationsNetwork.swift
//  App
//
//  Created by Ahmed Taha on 15/02/2024.
//

import Foundation

struct NotificationsNetwork {
    let fetchNotification: any RequestMaker<notificationModel> = NetworkWrapper(url: .path("notifications"), method: .get)
    let clearAllNotifications: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("client/delete_all_notifications"), method: .delete)
    let deleteNotification: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("client/notifications"), method: .delete)
}
