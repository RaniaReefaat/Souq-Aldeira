//
//  AddressRepository.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation

struct AddressRepository: AddressRepoInterface {
   
    let network = AddressNetwork()
    
    func getAddress() -> RequestPublisher<[AddressEntity]> {
        network.getAddress
            .makeRequest()
    }
    
    func addAddress(body: AddressBody) -> RequestPublisher<EmptyData> {
        network.addAddress
            .makeRequest(with: body)
    }
    
    func deleteAddress(id: Int) -> RequestPublisher<EmptyData> {
        network.deleteAddress
            .addPathVariables(path: id.string)
            .makeRequest()
    }

}
