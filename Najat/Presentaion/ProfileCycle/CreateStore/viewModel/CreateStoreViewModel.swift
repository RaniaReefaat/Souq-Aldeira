//
//  CreateStoreViewModel.swift
//  Najat
//
//  Created by rania refaat on 05/08/2024.
//

import Combine
import Foundation

class CreateStoreViewModel {
        
    @Published @MainActor var loadingIndicator: ScreenState<Void> = .ideal
    @Published var showPhoneValidation = ""
    @Published var showNameValidation = ""
    @Published var showEmailValidation = ""
    @Published var showDescriptionValidation = ""
    @Published var showPriceValidation = ""
    @Published var showStoreImageValidation = ""
    @Published var showLicenseImageValidation = ""

    @Published var pricesArray: [String] = []
    @Published var reloadPrices = false
    @Published var successMessage = String()

    var successCreateStoreState: PassthroughSubject<Void, Never> = .init()

    private let coordinator: CoordinatorProtocol
    private var profileUseCase: UserProfileUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        profileUseCase: UserProfileUseCaseProtocol = UserProfileUseCase()
    ) {
        self.coordinator = coordinator
        self.profileUseCase = profileUseCase
    }
}

extension CreateStoreViewModel {
    
    @MainActor
    func attemptCreateStore(body: CreateStoreBody, image: Data, license: Data, licenseISFile: Bool) async {
        loadingIndicator = .loading
        let data = getUploadData(image: image, license: license, licenseISFile: licenseISFile)
        let createStore = await profileUseCase.createStore(body: body, data: data)
        switch createStore {
        case .success(let data):
            loadingIndicator = .success(())
            successMessage = data.message ?? ""
            successCreateStoreState.send(())
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    
    @MainActor
    func getDeliveryPrice() async {
        loadingIndicator = .loading
        
        let deliveryPrice = await profileUseCase.getDeliveryPrice()
        
        switch deliveryPrice {
        case .success(let deliveryPrice):
            loadingIndicator = .success(())
            pricesArray = deliveryPrice
            reloadPrices = true
        case .failure(let error):
            showError(with: error.errorHandler)
        }
    }
    @MainActor
    private func showError(with error: NajatError) {
        loadingIndicator = .ideal
        switch error.type {
        case .phone:
            showPhoneValidation = error.error
        case .name:
            showNameValidation = error.error
        case .email:
            showEmailValidation = error.error
        case .description:
            showDescriptionValidation = error.error
        case .price:
            showPriceValidation = error.error
        case .storeImage:
            showStoreImageValidation = error.error
        case .licenseImage:
            showLicenseImageValidation = error.error
        default:
            loadingIndicator = .failure(error.error)
        }
    }
    
    @Sendable
    func getUploadData(image: Data, license: Data, licenseISFile: Bool) -> [UploadData] {
       
        
        var uploadData: [UploadData] = [
            .init(data: image, name: "image"),
//            .init(data: license, name: "license")
        ]
        if licenseISFile {
            uploadData.append(.init(data: license, name: "license", mimeType: "pdf", fileName: "license"))
        }else {
            uploadData.append(.init(data: license, name: "license"))

        }
        return uploadData
    }
}
