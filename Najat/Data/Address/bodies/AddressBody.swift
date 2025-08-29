//
//  AddressBody.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

struct AddressBody: JsonEncadable {
    var name: String
    var address: String
    var lat: Double
    var lng: Double
    var areaId: Int
    var streetNo: Int
    var homeNo: Int
    var flatNo: Int
}
