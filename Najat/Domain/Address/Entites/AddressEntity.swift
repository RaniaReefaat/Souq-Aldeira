//
//  AddressEntity.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

// MARK: - AddressEntity
struct AddressEntity: Codable {
    var id: Int?
    var name, address, lat, lng: String?
    var area: Area?
    var streetNo, homeNo, flatNo: String?

    enum CodingKeys: String, CodingKey {
        case id, name, address, lat, lng, area
        case streetNo = "street_no"
        case homeNo = "home_no"
        case flatNo = "flat_no"
    }
}

// MARK: - Area
struct Area: Codable {
    var id: Int?
    var name: String?
}
