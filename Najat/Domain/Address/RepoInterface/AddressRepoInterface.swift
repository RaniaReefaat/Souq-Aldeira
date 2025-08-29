//
//  AddressRepoInterface.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

protocol AddressRepoInterface {
    func getAddress() -> RequestPublisher<[AddressEntity]>
    func addAddress(body: AddressBody) -> RequestPublisher<EmptyData>
    func deleteAddress(id: Int) -> RequestPublisher<EmptyData>
}
