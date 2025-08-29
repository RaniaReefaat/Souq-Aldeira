//
//  LoginRepoImplementation.swift
//  MyApp
//
//  Created by Mohammed Balegh on 08/11/2023.
//

import Combine

struct LoginRepoImplementation: LoginRequestRepoProtocol {

    let network = LoginDataSource()
    
    func login(body: LoginBody) ->  RequestPublisher<EmptyData> {
        return network.loginAPI.makeRequest(with: body)

    }
}
