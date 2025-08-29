//
//  PaymentsEntity.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation
// MARK: - PaymentsEntity
struct PaymentsEntity: Codable {
    var name, key: String?
    var isSelected: Bool? = false
}
