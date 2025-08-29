//
//  ContactUSBody.swift
//  Najat
//
//  Created by rania refaat on 23/08/2024.
//

import Foundation

struct ContactUSBody: JsonEncadable {
    
    var name: String?
    var email: String?
    var message: String?

    // MARK: - Validation for Login
    
    var validateBody: Validate<ContactUSBody> {
        guard let name, !name.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.emptyName))
        }
        
        guard !(name.count < 3) else {
            return .failure(.init(type: .phone, error: NajatError.shortName))
        }
        guard let email, !email.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.emptyEmail))
        }
        
        guard email.isEmail else {
            return .failure(.init(type: .phone, error: NajatError.inValidEmail))
        }
        guard let message, !message.isEmpty else {
            return .failure(.init(type: .phone, error: NajatError.contactMessage))
        }
        return .success(ContactUSBody(name: name, email: email , message: message))
    }
}
