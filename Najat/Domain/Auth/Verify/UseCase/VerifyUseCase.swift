//
//  VerifyUseCase.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

protocol VerifyUseCaseProtocol {
    mutating func verify(body: VerifyPhoneBody) async -> Result<UserDataModel, MyAppError>
    mutating func resendVerificationCode(with phone: String) async -> Result<EmptyData, MyAppError>

}

struct VerifyUseCase: VerifyUseCaseProtocol {

    var verifyRepo: VerifyRequestRepoProtocol
    
    private var bag = AppBag()
    
    init(verifyRepo: VerifyRequestRepoProtocol = VerifyRepoImplementation()) {
        self.verifyRepo = verifyRepo
    }
    
    mutating func verify(body: VerifyPhoneBody) async -> Result<UserDataModel, MyAppError> {
        
        return await verifyRepo
            .verify(body: body)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
    mutating func resendVerificationCode(with phone: String) async -> Result<EmptyData, MyAppError> {
        await verifyRepo.resendVerificationCode(with: phone)
            .singleOutput(with: &bag)
            .result()
            .map { return $0 }
    }
}
