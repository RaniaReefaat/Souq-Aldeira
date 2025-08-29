//
//  CartDetailsViewModel.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

@MainActor
protocol CartDetailsViewModellProtocol: AnyObject {
    var uiModel: CartDetailsViewModel.UIModel { get }
    
    var numberOfRows: Int { get }
    var cartItem: CartDataModel { get }
    func cellData(at index: Int) -> ItemEntity
    func getCartDetailsRequest(cartID: Int) async
    func addtemCart(body: AddToCartBody) async
    func deleteItemCart(cartID: Int, itemID: Int) async
    func addToFavorite(productID: Int, fileID: Int) async
    func toggleFavourit(productID: Int)
}

class CartDetailsViewModel: CartDetailsViewModellProtocol {
    
    var uiModel: UIModel
    
    var cartDetailsData: CartDataModel?
    
    private let coordinator: CoordinatorProtocol
    private var useCase: CartUseCasesProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: CartUseCasesProtocol = CartUseCases(),
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
        self.generalUseCase = generalUseCase
    }
}

// MARK: - ViewModel UIModel
extension CartDetailsViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var reloadProducts = false
        @Published var fetchData: CartDataModel?
        @Published var showEmptyView = false
    }
}

// MARK: - Setup CartDetails Data
extension CartDetailsViewModel {
    
    var numberOfRows: Int {
        guard let items = cartDetailsData?.items else { return 0 }
        return items.count
    }
    
    var cartItem: CartDataModel {
        guard let items = cartDetailsData else { return CartDataModel(id: 0, store: Store(id: 0, name: "", image: "", bio: "", whatsapp: "", email: "", role: "", products: [], shareLnk: ""), items: [], subtotal: 0, deliveryFee: 0, total: 0) }

        return items
    }
    
    func cellData(at index: Int) -> ItemEntity {
        guard let items = cartDetailsData?.items else { return ItemEntity(id: -1, product: nil, qty: 0, price: "", total: 0) }

        return items[index]
    }
    
    func toggleFavourit(productID: Int) {
        print(productID)
        if let index = cartDetailsData?.items
            .firstIndex(where: { ($0.product?.id ?? 0) == productID }) {
            print(cartDetailsData?.items[index].product?.isFavourite)
            cartDetailsData?.items[index].product?.isFavourite?.toggle()
            print(cartDetailsData?.items[index].product?.isFavourite)

        }
    }

}

// MARK: - Screen Requests

extension CartDetailsViewModel {
    
    func getCartDetailsRequest(cartID: Int) async {
        uiModel.isLoading = true
        let requestResults = await useCase.showCart(cartID: cartID)
        uiModel.isLoading = false
        
        switch requestResults {
        case .success(let data):
            cartDetailsData = data
            uiModel.fetchData = data
            setupEmptyView()
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    
    func addtemCart(body: AddToCartBody) async {
        uiModel.isLoading = true
        let products = await useCase.addToCart(body: body)
        uiModel.isLoading = false
       
        switch products {
        case .success(_):
            Task {
                await getCartDetailsRequest(cartID: cartItem.id)
            }
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    func deleteItemCart(cartID: Int, itemID: Int) async {
        uiModel.isLoading = true
        let products = await useCase.deleteItem(cartID: cartID, itemID: itemID)
        uiModel.isLoading = false
       
        switch products {
        case .success(_):
            if let index = cartDetailsData?.items.firstIndex(where: { $0.id == itemID }) {
                cartDetailsData?.items.remove(at: index)
            }
            if cartDetailsData?.items.count == 0 {
                setupEmptyView()
            }else{
                uiModel.fetchData = cartDetailsData
            }
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    func addToFavorite(productID: Int, fileID: Int) async {
        uiModel.isLoading = true
        print(productID)
        let products = await generalUseCase.addToFavorite(productID, fileID: fileID)

        uiModel.isLoading = false
       
        switch products {
        case .success(_):
            uiModel.reloadProducts = true
//            toggleFavourit(productID: productID)
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    func setupEmptyView() {
        guard let items = cartDetailsData?.items else { return }

        uiModel.showEmptyView = items.isEmpty
    }
}
