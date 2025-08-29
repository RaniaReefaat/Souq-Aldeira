//
//  StoreOrderDetailsViewModel.swift
//  Najat
//
//  Created by rania refaat on 04/09/2024.
//

import Combine
import Foundation

class StoreOrderDetailsViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var orderData: OrderDetailsModelData?
    @Published var reloadData = false
    @Published var acceptOrderMessage : String?

    private let coordinator: CoordinatorProtocol
    private var generalUseCase: GeneralUseCaseProtocol
    private var profileUseCase: StoreProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase(),
        profileUseCase: StoreProfileUseCaseProtocol = StoreProfileUseCase()
    ) {
        self.coordinator = coordinator
        self.generalUseCase = generalUseCase
        self.profileUseCase = profileUseCase
    }
}

extension StoreOrderDetailsViewModel {
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
    func acceptOrder(id: Int) async {
        loadingIndicator = .loading
        let order = await profileUseCase.acceptOrder(orderID: id)
        
        switch order {
        case .success(let order):
            loadingIndicator = .success(())
            reloadData = true
            acceptOrderMessage = order.message ?? ""
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
