//
//  AddressUseCase.swift
//  Najat
//
//  Created by mahroUS on 07/08/2567 BE.
//

import Foundation
protocol AddressUseCasesProtocol {
    func getAddress() async -> RequestResponse<[AddressEntity]>
    func addAddress(body: AddressBody) async -> RequestResponse<EmptyData>
    func deleteAddress(id: Int) async -> RequestResponse<EmptyData>
}

final class AddressUseCases: AddressUseCasesProtocol {
    
    let repo: AddressRepoInterface
    var bag = AppBag()
    
    init(repo: AddressRepoInterface = AddressRepository()) {
        self.repo = repo
    }
    
    func getAddress() async -> RequestResponse<[AddressEntity]> {
        await repo.getAddress()
            .singleOutput(with: &bag)
            .result()
    }
    
    func addAddress(body: AddressBody) async -> RequestResponse<EmptyData> {
        await repo.addAddress(body: body)
            .singleOutput(with: &bag)
            .result()
    }
    
    func deleteAddress(id: Int) async -> RequestResponse<EmptyData> {
        await repo.deleteAddress(id: id)
            .singleOutput(with: &bag)
            .result()
    }
}
