//
//  AddressNetwork.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

struct AddressNetwork {
    let getAddress: any RequestMaker<[AddressEntity]> = NetworkWrapper(url: .path("user/address"), method: .get)
    let addAddress: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/address"), method: .post)
    let deleteAddress: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("user/address/"), method: .delete)
}

