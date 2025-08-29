//
//  CartListDataModel.swift
//  Najat
//
//  Created by mahroUS on 05/08/2567 BE.
//

import Foundation

struct CartListDataModel: Hashable {

    private let itemID = UUID().uuidString
    
    static func == (lhs: CartListDataModel, rhs: CartListDataModel) -> Bool {
        lhs.itemID == rhs.itemID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(itemID)
    }
    var id: Int
    var store: Store
    var productsCount: Int
    
}
