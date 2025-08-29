//
//  CartDataModel.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation
struct CartDataModel: Hashable {

    private let itemID = UUID().uuidString
    
    static func == (lhs: CartDataModel, rhs: CartDataModel) -> Bool {
        lhs.itemID == rhs.itemID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemID)
    }
    
    var id: Int
    var store: Store
    var items: [ItemEntity]
    var subtotal: Int
    var deliveryFee: Int
    var total: Int
}
