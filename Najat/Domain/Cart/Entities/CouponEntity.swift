//
//  CouponeEntity.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation
// MARK: - CouponeEntity
struct CouponEntity: Codable {
    var id: Int?
    var name, code, type, amount: String?
    var minOrderAmount: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, code, type, amount
        case minOrderAmount = "min_order_amount"
    }
}
