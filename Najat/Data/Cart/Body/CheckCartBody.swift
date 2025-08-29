//
//  CheckCartBody.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

struct CheckCartBody: JsonEncadable {
    var paymentMethod: String
    var addressId: String
    var coupon: String?
}
