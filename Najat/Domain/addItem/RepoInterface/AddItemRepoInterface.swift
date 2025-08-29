//
//  AddItemRepoInterface.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

protocol AddItemRepoInterface {
    func addItem(body: addItemBody, uploadData: [UploadData]) -> RequestPublisher<EmptyData>
    func editItem(id: Int, body: EditItemBody, uploadData: [UploadData]) -> RequestPublisher<EmptyData>
}
