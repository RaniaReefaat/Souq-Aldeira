//
//  AddItemNetwork.swift
//  Najat
//
//  Created by mohamed mahrous on 07/09/2024.
//

import Foundation

struct AddItemNetwork {
    let addItem: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("store/product"), method: .post)
    let editItem: any RequestMaker<EmptyData> = NetworkWrapper(url: .path("store/product/"), method: .post)
}

