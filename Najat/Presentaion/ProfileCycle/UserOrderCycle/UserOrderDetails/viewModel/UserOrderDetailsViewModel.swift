//
//  UserOrderDetailsViewModel.swift
//  Najat
//
//  Created by rania refaat on 21/08/2024.
//

import Combine
import Foundation

class UserOrderDetailsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var orderData: OrderDetailsModelData?
    @Published var reloadData = false

    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
    }
}

extension UserOrderDetailsViewModel {
    @MainActor
    func getOrderDetails(orderID: Int) async {
        loadingIndicator = .loading
        
        let order = await generalUseCase.getOrderDetails(orderID)
        
        switch order {
        case .success(let data):
            loadingIndicator = .success(())
            orderData = data
            reloadData = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        default:
            loadingIndicator = .failure(error.error)
        }
    }
    
}
