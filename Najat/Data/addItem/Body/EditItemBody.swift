//
//  EditItemBody.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

struct EditItemBody: JsonEncadable {
    var name: String?
    var description: String?
    var price: Int?
    var categoryId: Int?
    var subcategoryId: Int?
    var qty: Int?
    var is_visible: Int?
    var _method: String = "put"
}
