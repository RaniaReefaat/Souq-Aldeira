//
//  ConfirmOrderViewModel.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

@MainActor
protocol ConfirmOrderViewModellProtocol: AnyObject {
    var uiModel: ConfirmOrderViewModel.UIModel { get }
  
    var numberOfRows: Int { get }
    func cellData(at index: Int) -> PaymentsEntity
    func checkPayment(at index: Int)
    func getConfirmOrderRequest(cartID: String, body: CheckCartBody) async
    func addCoupon(code: String, subtotal: String) async
    func getPaymentMethods() async
    func getAddress() async 
}

class ConfirmOrderViewModel: ConfirmOrderViewModellProtocol {
    
    var uiModel: UIModel
    
    var paymentList = [PaymentsEntity]()
    private let coordinator: CoordinatorProtocol
    private var useCase: CartUseCasesProtocol
    private var generalUseCase: GeneralUseCaseProtocol
    private let addressUseCase: AddressUseCases

    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: CartUseCasesProtocol = CartUseCases(),
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase(),
        addressUseCase: AddressUseCases = AddressUseCases()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
        self.generalUseCase = generalUseCase
        self.addressUseCase = addressUseCase
    }
}

// MARK: - ViewModel UIModel
extension ConfirmOrderViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var reloadProducts = false
        @Published var fetchData = [PaymentsEntity]()
        @Published var fetchAddress: AddressEntity?
        @Published var couponValue: String?
    }
}

// MARK: - Setup ConfirmOrder Data
extension ConfirmOrderViewModel {
    var numberOfRows: Int {
//        paymentList.count
        1
    }
    
    func cellData(at index: Int) -> PaymentsEntity {
        PaymentsEntity(name: "كي نت", key: "knet", isSelected: true)
//        return paymentList[index]
    }
    func checkPayment(at index: Int) {
        paymentList[index].isSelected.toggle()
        uiModel.reloadProducts = true
    }
}

// MARK: - Screen Requests

extension ConfirmOrderViewModel {
  
    func getConfirmOrderRequest(cartID: String, body: CheckCartBody) async {
        uiModel.isLoading = true
        let coupon = await useCase.makeCart(cartID: cartID, body: body)
        uiModel.isLoading = false
       
        switch coupon {
        case .success(let url):
            coordinator.push(PaymentViewController(paymentURL: url))
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }

    }

    func addCoupon(code: String, subtotal: String) async {
        uiModel.isLoading = true
        let coupon = await useCase.checkCoupon(code: code, subtotal: subtotal)
        uiModel.isLoading = false
       
        switch coupon {
        case .success(let data):
            if data.type == "percentage" {
                let amount = (((subtotal.double ?? 0.0) * (data.amount?.double ?? 0.0)) / 100)
                uiModel.couponValue = amount.string
            } else {
                uiModel.couponValue = data.amount ?? ""
            }
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    
    func getPaymentMethods() async {
        uiModel.isLoading = true
        let coupon = await generalUseCase.getPayments()
        uiModel.isLoading = false
       
        switch coupon {
        case .success(let data):
            paymentList = data
            uiModel.fetchData = data
            uiModel.reloadProducts = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    
    func getAddress() async {
        uiModel.isLoading = true
        let addressResult = await addressUseCase.getAddress()
        uiModel.isLoading = false
        switch addressResult {
        case .success(let data):
            uiModel.fetchAddress = data.first
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

}
