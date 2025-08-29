//
//  LoginBody.swift
//  MyApp
//
//  Created by Ahmed Taha on 31/12/2023.
//

import Foundation

struct LoginBody: JsonEncadable {
    
    var phone: String?
    
    // MARK: - Validation for Login
    
    var validateBody: Validate<LoginBody> {
        guard let phone, !phone.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.emptyPhone))
        }
        
        guard !(phone.count < 8) else {
            return .failure(.init(type: .phone, error: NajatError.smallPhoneNumber))
        }
        return .success(LoginBody(phone: phone))
    }
    
}
