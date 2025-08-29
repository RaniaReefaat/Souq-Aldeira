//
//  RegisterUseCase.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

protocol RegisterUseCaseProtocol {
    mutating func RegisterUseCase(body: RegisterBody) async -> Result<EmptyData, MyAppError>
}

struct RegisterUseCase: RegisterUseCaseProtocol {
    var registerRepo: RegisterRequestRepoProtocol
    
    private var bag = AppBag()
    
    init(registerRepo: RegisterRequestRepoProtocol = RegisterRepoImplementation()) {
        self.registerRepo = registerRepo
    }
    
    mutating func RegisterUseCase(body: RegisterBody) async -> Result<EmptyData, MyAppError> {
        if case .failure(let error) = body.validateBody {
            return .failure(MyAppError.localValidation(error))
        }
        
        return await registerRepo
            .register(body: body)
            .singleOutput(with: &bag)
            .result()
            .map {
                return $0
            }
    }
}
