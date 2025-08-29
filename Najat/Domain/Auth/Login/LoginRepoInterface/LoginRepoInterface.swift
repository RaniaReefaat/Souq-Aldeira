//
//  LoginRepoInterface.swift
//  App
//
//  Created by Mohammed Balegh on 08/11/2023.
//

import Foundation

protocol LoginRequestRepoProtocol {
    func login(body: LoginBody) async ->  RequestPublisher<EmptyData>
}
