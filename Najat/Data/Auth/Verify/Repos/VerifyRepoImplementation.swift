//
//  VerifyRepoImplementation.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation
import Combine

struct VerifyRepoImplementation: VerifyRequestRepoProtocol {

    let network = VerifyDataSource()
    
    func verify(body: VerifyPhoneBody) async -> RequestPublisher<UserDataModel> {
        return network.verifyAPI.makeRequest(with: body)

    }
    
    func resendVerificationCode(with phone: String) -> RequestPublisher<EmptyData> {
        let body: [String: Any]  = ["phone": phone]
        return network.resendVerifyCodeAPI.makeRequest(with: body)

    }

}
