////
////  NotificationsProtocol.swift
////  App
////
////  Created by Ahmed Taha on 15/02/2024.
////
//
import Foundation

protocol NotificationsRepositoryProtocol {
    func fetchNotifications(page: Int) -> RequestPublisher<notificationModel>
    func clearAllNotifications() -> RequestPublisher<EmptyData>
    func deleteNotification(with id: String) -> RequestPublisher<EmptyData>
}
