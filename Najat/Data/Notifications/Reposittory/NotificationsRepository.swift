//
//  NotificationsRepository.swift
//  App
//
//  Created by Ahmed Taha on 15/02/2024.
//

import Foundation

struct NotificationsRepository: NotificationsRepositoryProtocol {
    
    private let network = NotificationsNetwork()
    
    func fetchNotifications(page: Int) -> RequestPublisher<notificationModel> {
        let model: [String: Any] = ["page": page]
        return network.fetchNotification
            .makeRequest(with: model)
    }
    
    func clearAllNotifications() -> RequestPublisher<EmptyData> {
        network.clearAllNotifications
            .makeRequest()
    }
    
    func deleteNotification(with id: String) -> RequestPublisher<EmptyData> {
        network.deleteNotification
            .addPathVariables(path: "/\(id)")
            .makeRequest()
    }
}
