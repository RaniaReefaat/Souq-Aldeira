////
////  NotificationsUseCaseProtocol.swift
////  App
////
////  Created by Ahmed Taha on 15/02/2024.
////
//
import Foundation

protocol NotificationsUseCaseProtocol: AnyObject {
    func fetchNotifications(page: Int) async -> RequestResponse<notificationModel>
    func clearAllNotifications() async -> RequestResponse<EmptyData>
    func deleteNotification(with id: String) async -> RequestResponse<EmptyData>
}
