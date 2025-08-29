//
//  NotificationViewModel.swift
//  Najat
//
//  Created by rania refaat on 26/08/2024.
//

import Foundation

@MainActor
final class NotificationViewModel {

    @Published var isLoading = false
    @Published var reloadViews = false
    @Published var showEmptyState = false

    var lastPage = 1
    private var notifications = [NotificationItem]()
    private var coordinator: CoordinatorProtocol
    private var useCase: NotificationsUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        useCase: NotificationsUseCaseProtocol = NotificationsUseCase()
    ) {
        self.coordinator = coordinator
        self.useCase = useCase
    }
    func fetchNotifications(page: Int) async {
        isLoading = true
        let requestResults = await useCase.fetchNotifications(page: page)
        isLoading = false
        
        switch requestResults {
        case .success(let data):
            lastPage = data.paginate?.totalPages ?? 1
            (page == 1) ? (notifications = data.items) : notifications.append(contentsOf: data.items)
            showEmptyState = notifications.isEmpty
            reloadViews = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
}

extension NotificationViewModel {

    var numberOfNotifications: Int {
        notifications.count
    }

    func cellData(at index: Int) -> NotificationItem {
        notifications[index]
    }
}
