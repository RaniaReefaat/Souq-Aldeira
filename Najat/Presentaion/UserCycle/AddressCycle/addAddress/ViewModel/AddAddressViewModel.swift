//
//  AddAddressViewModel.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation
@MainActor
protocol AddAddressViewModelProtocol: AnyObject {
    var uiModel: AddAddressViewModel.UIModel { get }
    func addAddress(body: AddressBody) async
    func governoratesItem(for index: Int) -> AreaEntity
    func governoratesTitle() -> [String]
    func getGovernorates() async
}

final class AddAddressViewModel: AddAddressViewModelProtocol {
  
    var uiModel: UIModel

    private var governoratesList = [AreaEntity]()

    private let coordinator: CoordinatorProtocol
    private let useCase: AddressUseCasesProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: AddressUseCasesProtocol = AddressUseCases(),
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
        self.generalUseCase = generalUseCase
    }
}
// MARK: - ViewModel UIModel
extension AddAddressViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var fetchData = false
        @Published var reloadViews = false
    }
}

extension AddAddressViewModel {
    
    func governoratesItem(for index: Int) -> AreaEntity {
        governoratesList[index]
    }
    
    func governoratesTitle() -> [String] {
        var governoratesTitle: [String] = []
        governoratesTitle.append(contentsOf: governoratesList.map({ $0.name ?? "" }))
        return governoratesTitle
    }
}
// MARK: - Screen Requests
extension AddAddressViewModel {
   
    func getGovernorates() async {
        uiModel.isLoading = true
        let addressResult = await generalUseCase.getArea()
        uiModel.isLoading = false
        switch addressResult {
        case .success(let data):
            governoratesList = data
            uiModel.fetchData = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    func addAddress(body: AddressBody) async {
        uiModel.isLoading = true
        let addressResult = await useCase.addAddress(body: body)
        uiModel.isLoading = false
        switch addressResult {
        case .success( _):
            uiModel.reloadViews = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
}
