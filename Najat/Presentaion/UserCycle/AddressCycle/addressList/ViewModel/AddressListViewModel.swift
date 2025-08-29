//
//  AddressListViewModel.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

@MainActor
protocol AddressListViewModelProtocol: AnyObject {
    
    var uiModel: AddressListViewModel.UIModel { get }
    func getAddress() async
    func deleteAddress(id: Int) async
    
    var numberOfRows: Int { get }
    func cellData(at index: Int) -> AddressEntity
}

final class AddressListViewModel: AddressListViewModelProtocol {
  
    var uiModel: UIModel
    private var addressList = [AddressEntity]()
    private let coordinator: CoordinatorProtocol
    private let useCase: AddressUseCases
    
    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: AddressUseCases = AddressUseCases()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
    }
}
// MARK: - ViewModel UIModel
extension AddressListViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var reloadViews = false
        @Published var showEmptyView = false
    }
}
// MARK: - Setup AddressList Data
extension AddressListViewModel {
    var numberOfRows: Int {
        addressList.count
    }
    
    func cellData(at index: Int) -> AddressEntity {
        addressList[index]
    }
}
// MARK: - Screen Requests
extension AddressListViewModel {

    func getAddress() async {
        uiModel.isLoading = true
        let addressResult = await useCase.getAddress()
        uiModel.isLoading = false
        switch addressResult {
        case .success(let data):
            addressList = data
            uiModel.showEmptyView = addressList.isEmpty
            uiModel.reloadViews = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    func deleteAddress(id: Int) async {
        uiModel.isLoading = true
        let addressResult = await useCase.deleteAddress(id: id)
        uiModel.isLoading = false
        switch addressResult {
        case .success(let data):
            Task {
                await getAddress()
            }
            uiModel.showEmptyView = addressList.isEmpty
            uiModel.reloadViews = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
}
