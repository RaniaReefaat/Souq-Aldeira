//
//  AddItemUseCase.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation
protocol AddItemUseCaseProtocol {
    func addItem(body: addItemBody, uploadData: [UploadData]) async -> RequestResponse<EmptyData>
    func editItem(id: Int, body: EditItemBody, uploadData: [UploadData]) async -> RequestResponse<EmptyData>
}

final class AddItemUseCase: AddItemUseCaseProtocol {
    
    let repo: AddItemRepoInterface
    var bag = AppBag()
    
    init(repo: AddItemRepoInterface = AddItemRepository()) {
        self.repo = repo
    }
    
    func addItem(body: addItemBody, uploadData: [UploadData]) async -> RequestResponse<EmptyData> {
        await repo.addItem(body: body,uploadData: uploadData)
            .singleOutput(with: &bag)
            .result()
    }
    
    func editItem(id: Int, body: EditItemBody, uploadData: [UploadData]) async -> RequestResponse<EmptyData> {
        await repo.editItem(id: id, body: body, uploadData: uploadData)
            .singleOutput(with: &bag)
            .result()
    }
}
