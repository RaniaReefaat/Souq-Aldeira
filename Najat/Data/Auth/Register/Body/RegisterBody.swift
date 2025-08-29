//
//  RegisterBody.swift
//  Najat
//
//  Created by rania refaat on 26/07/2024.
//

import Foundation

struct RegisterBody: JsonEncadable {
    
    var phone: String?
    var name: String?
    var isSelectTerms: Bool? = true
    
    // MARK: - Validation for Login
    
    var validateBody: Validate<RegisterBody> {
        guard let phone, !phone.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.emptyPhone))
        }
        
        guard !(phone.count < 8) else {
            return .failure(.init(type: .phone, error: NajatError.smallPhoneNumber))
        }
        guard let name, !name.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.emptyName))
        }
        
        guard !(name.count < 3) else {
            return .failure(.init(type: .phone, error: NajatError.shortName))
        }
        if !(isSelectTerms ?? false) {
            return .failure(.init(type: .phone, error: NajatError.termsNotSelected))
        }
        return .success(RegisterBody(phone: phone , name: name))
    }
    
}
