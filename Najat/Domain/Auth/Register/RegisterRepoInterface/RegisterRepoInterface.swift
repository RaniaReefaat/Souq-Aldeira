//
//  RegisterRepoInterface.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

protocol RegisterRequestRepoProtocol {
    func register(body: RegisterBody) async ->  RequestPublisher<EmptyData>
}
