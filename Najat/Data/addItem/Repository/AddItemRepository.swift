//
//  AddItemRepository.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

struct AddItemRepository: AddItemRepoInterface {
    
    let network = AddItemNetwork()
    
    func addItem(body: addItemBody, uploadData: [UploadData]) -> RequestPublisher<EmptyData> {
        var newBody = addItemBody()
        if body.price == nil || body.price == 0{
            newBody = addItemBody(name: body.name, description: body.description , categoryId: body.categoryId , subcategoryId: body.subcategoryId , qty: body.qty)
            return network.addItem
                 .makeRequest(with: newBody, uploadData: uploadData)

        }else{
            return network.addItem
                 .makeRequest(with: body, uploadData: uploadData)

        }
    }
    
    func editItem(id: Int, body: EditItemBody, uploadData: [UploadData]) -> RequestPublisher<EmptyData> {
        var newBody = EditItemBody()
        if body.price == nil || body.price == 0{
            newBody = EditItemBody(name: body.name, description: body.description , categoryId: body.categoryId , subcategoryId: body.subcategoryId , qty: body.qty , is_visible: body.is_visible , _method: body._method )
            return network.editItem
                 .addPathVariables(path: "\(id)")
                 .makeRequest(with: newBody, uploadData: uploadData)

        }else{
            return network.editItem
                 .addPathVariables(path: "\(id)")
                 .makeRequest(with: body, uploadData: uploadData)

        }
    }
}
