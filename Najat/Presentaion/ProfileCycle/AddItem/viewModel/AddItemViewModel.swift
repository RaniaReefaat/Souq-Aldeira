//
// AddItemViewModel.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

@MainActor
protocol AddItemViewModellProtocol: AnyObject {
    var uiModel:AddItemViewModel.UIModel { get }
  
    func getCategory() async
    func getSubCategory(_ categoryID: Int) async
    
    func categoryTitle() -> [String]
    func categoryID(index: Int) -> Int

    func subCategoryTitle() -> [String]
    func subCategoryID(index: Int) -> Int

    func AddItem(body: addItemBody, image: [AttachmentsMediaData]) async
    func editItem(id: Int, body: EditItemBody, image: [AttachmentsMediaData]) async
}

class AddItemViewModel: AddItemViewModellProtocol {
    
    var uiModel: UIModel
   
    var categoryArray: [Category] = []
    var subCategoryArray: [Category] = []

    private let coordinator: CoordinatorProtocol
    private var useCase: AddItemUseCaseProtocol
    private var generalUseCase: GeneralUseCaseProtocol

    init(
        coordinator: CoordinatorProtocol,
        uiModel: UIModel = .init(),
        useCase: AddItemUseCaseProtocol = AddItemUseCase(),
        generalUseCase: GeneralUseCaseProtocol = GeneralUseCase()
    ) {
        self.coordinator = coordinator
        self.uiModel = uiModel
        self.useCase = useCase
        self.generalUseCase = generalUseCase
    }
}

// MARK: - ViewModel UIModel
extension AddItemViewModel {
    class UIModel {
        @Published var isLoading = false
        @Published var fetchData = false
        @Published var reloadProducts = false
        @Published var showEmptyView = false
        @Published var addSuccess = false
    }
}

// MARK: - Setup AddItem Data
extension AddItemViewModel {

    func categoryTitle() -> [String] {
        categoryArray.map({$0.name ?? ""})
    }
    
    func categoryID(index: Int) -> Int {
        categoryArray[index].id.unwrapped(or: 0)
    }
    
    func subCategoryTitle() -> [String] {
        subCategoryArray.map({$0.name ?? ""})
    }
    
    func subCategoryID(index: Int) -> Int {
        subCategoryArray[index].id.unwrapped(or: 0)
    }

}

// MARK: - Screen Requests

extension AddItemViewModel {
    
    @MainActor
    func getCategory() async {
        uiModel.isLoading = true
        let category = await generalUseCase.getCategory()
        uiModel.isLoading = false
        switch category {
        case .success(let category):
            categoryArray = category
            uiModel.fetchData = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    @MainActor
    func getSubCategory(_ categoryID: Int) async {
        uiModel.isLoading = true
        let subCategory = await generalUseCase.getSubCategory(categoryID )
        uiModel.isLoading = false
        switch subCategory {
        case .success(let category):
            subCategoryArray = category
            uiModel.fetchData = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    @MainActor
    func AddItem(body: addItemBody, image: [AttachmentsMediaData]) async {
        uiModel.isLoading = true
        let products = await useCase.addItem(body: body, uploadData: getUploadData(image: image))
        uiModel.isLoading = false
       
        switch products {
        case .success(_):
     
            AppWindowManger.openTabBar()
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }
    
    @MainActor
    func editItem(id: Int, body: EditItemBody, image: [AttachmentsMediaData]) async {
        uiModel.isLoading = true
        let products = await useCase.editItem(id: id, body: body, uploadData: getUploadData(image: image))
        uiModel.isLoading = false
       
        switch products {
        case .success(_):
     
            uiModel.addSuccess = true
        case .failure(let error):
            coordinator.showAlert(message: error.validatorErrorAssociatedMessage, title: .error)
        }
    }

    
    @Sendable
    func getUploadData(image: [AttachmentsMediaData]) -> [UploadData] {
        var uploadData: [UploadData] = []
        for (index, element) in image.enumerated() {
            print(element.data)
            if element.isImage ?? false {
                uploadData.append(.init(data: element.data ?? Data(), name: "attachments[]"))

            }else{
                uploadData.append(.init(data: element.data ?? Data(), name: "attachments[]", mimeType: "mp4"))
            }

        }
        return uploadData
    }

}
