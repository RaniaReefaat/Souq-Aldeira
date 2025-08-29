//
//  NotificationsUseCase.swift
//  App
//
//  Created by Ahmed Taha on 15/02/2024.
//

import Foundation

final class NotificationsUseCase: NotificationsUseCaseProtocol {
    
    private var repository: NotificationsRepositoryProtocol
    private var cancellable = AppBag()
    
    init(repository: NotificationsRepositoryProtocol = NotificationsRepository()) {
        self.repository = repository
    }
    
    func fetchNotifications(page: Int) async -> RequestResponse<notificationModel> {
        await repository.fetchNotifications(page: page)
            .singleOutput(with: &cancellable)
            .result()
    }
    
    func clearAllNotifications() async -> RequestResponse<EmptyData> {
        await repository.clearAllNotifications()
            .singleOutput(with: &cancellable)
            .result()
    }
    
    func deleteNotification(with id: String) async -> RequestResponse<EmptyData> {
        await repository.deleteNotification(with: id)
            .singleOutput(with: &cancellable)
            .result()
    }
}
