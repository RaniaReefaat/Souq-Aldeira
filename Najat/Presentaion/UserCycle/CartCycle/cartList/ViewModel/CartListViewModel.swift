//
//  CartListViewModel.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

@MainActor
protocol CartListViewModellProtocol: AnyObject {
    var uiModel: CartListViewModel.UIModel { get }
    
    var numberOfRows: Int { get }
    func storeID(at index: Int) -> Int
    func cellData(at index: Int) -> CartListDataModel
    func getCartListRequest() async
}

final class CartListViewModel: CartListViewModellProtocol {
    
    var uiModel: UIModel
    
    var CartListData = [CartListDataModel]()
    private let coordinator: CoordinatorProtocol
    private var useCase: CartUseCasesProtocol
    
    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: CartUseCasesProtocol = CartUseCases()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
    }
}

// MARK: - ViewModel UIModel
extension CartListViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var reloadViews = false
        @Published var showEmptyView = false
        @Published var cartCount = 0
    }
}

// MARK: - Setup CartList Data
extension CartListViewModel {

    var numberOfRows: Int {
        CartListData.count
    }
    
    func storeID(at index: Int) -> Int {
        CartListData[index].id
    }
    
    func cellData(at index: Int) -> CartListDataModel {
        return CartListData[index]
    }
}

// MARK: - Screen Requests

extension CartListViewModel {
    
    func getCartListRequest() async {
        uiModel.isLoading = true
        let requestResults = await useCase.getCartList()
        uiModel.isLoading = false
        
        switch requestResults {
        case .success(let data):
            CartListData = getCartArray(data.carts ?? [])
            uiModel.cartCount = data.count ?? 0
            uiModel.reloadViews = true
            print(data.count)
            setupEmptyView()
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    
    func setupEmptyView() {
        uiModel.showEmptyView = CartListData.isEmpty
    }
    func getCartArray(_ entities: [CartListEntity]) -> [CartListDataModel] {
        return entities.compactMap { entity in
            // Ensure required fields are not nil
            guard let id = entity.id,
                  let store = entity.store,
                  let productsCount = entity.productsCount else {
                return nil // Skip if any required value is missing
            }
            
            return CartListDataModel(id: id, store: store, productsCount: productsCount)
        }
    }
}
