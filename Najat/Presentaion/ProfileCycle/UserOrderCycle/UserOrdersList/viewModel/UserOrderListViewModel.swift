//
//  UserOrderListViewModel.swift
//  Najat
//
//  Created by rania refaat on 20/08/2024.
//

import Combine
import Foundation

class UserOrderListViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var ordersArray: [OrdersModelData] = []

    @Published var reloadData = false
    @Published var showEmptyView = false

    private var lastPage = 1
    private var currentPage = 0

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

extension UserOrderListViewModel {
    
    private func isLoadData() -> Bool{
        print(currentPage , "lastPage" , lastPage )
        if currentPage != lastPage {
            currentPage = currentPage + 1
            print(currentPage)
            return true
        }else {
            return false
        }
    }
    @MainActor
    func getOrders() async {
        guard isLoadData() else {return}
        loadingIndicator = .loading
        
        let orders = await generalUseCase.getOrder(currentPage)
        
        switch orders {
        case .success(let data):
            loadingIndicator = .success(())
            lastPage = data.paginate?.totalPages ?? 1
            currentPage = data.paginate?.currentPage ?? 1
            ordersArray.append(contentsOf: data.items ?? [])
            showEmptyView = ordersArray.isEmpty
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
    func viewWillAppear(){
        lastPage = 1
        currentPage = 0
        ordersArray = []
        
    }
}
extension UserOrderListViewModel {
    
    var numberOfRows: Int {
        ordersArray.count
    }
    
    func cellData(at index: Int) -> OrdersModelData {
        return ordersArray[index]
    }
}
