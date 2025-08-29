//
//  addItemBody.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

struct addItemBody: JsonEncadable {
    var name: String?
    var description: String?
    var price: Double?
    var categoryId: Int?
    var subcategoryId: Int?
    var qty: Int?
}
