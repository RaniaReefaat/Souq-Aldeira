//
//  RegisterRepoImplementation.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation
import Combine

struct RegisterRepoImplementation: RegisterRequestRepoProtocol {

    let network = RegisterDataSource()
    
    func register(body: RegisterBody) ->  RequestPublisher<EmptyData> {
        return network.registerAPI.makeRequest(with: body)

    }
}
