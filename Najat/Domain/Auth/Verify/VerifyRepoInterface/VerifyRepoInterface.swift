//
//  VerifyRepoInterface.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

protocol VerifyRequestRepoProtocol {
    func verify(body: VerifyPhoneBody) async ->  RequestPublisher<UserDataModel>
    func resendVerificationCode(with phone: String) -> RequestPublisher<EmptyData>

}
