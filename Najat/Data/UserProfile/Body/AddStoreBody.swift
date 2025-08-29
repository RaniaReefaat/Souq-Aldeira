//
//  AddStoreBody.swift
//  Najat
//
//  Created by rania refaat on 01/08/2024.
//

import Foundation

struct CreateStoreBody: JsonEncadable {
    
    var whatsapp: String?
    var name: String?
    var bio: String?
//    var image: Data?
//    var license: Data?
    var email: String?
    var delivery_fee: String?

    // MARK: - Validation for Login
    
    var validateBody: Validate<CreateStoreBody> {

        if !email.isNilOrEmpty {
            if email!.isEmail {
                if !bio.isNilOrEmpty && bio?.count ?? 0 > 4 {
                        if let name, !name.isEmpty{
                            if name.count > 2 {
//                                if image == nil {
//                                    return .failure(.init(type: .phone, error: NajatError.storeImage))
//                                }
//                                else{
//                                    if license == nil {
//                                        return .failure(.init(type: .phone, error: NajatError.licenseImage))
//
//                                    }else{
//                                        
//                                    }
//                                }
                                return .success(CreateStoreBody())

                            }else{
                                return .failure(.init(type: .phone, error: NajatError.shortName))
                            }
                        }else{
                            return .failure(.init(type: .phone, error: NajatError.emptyName))
                        }
                }else{
                    return .failure(.init(type: .bio, error: NajatError.userBio))
                }
            }else{
                return .failure(.init(type: .email, error: NajatError.inValidEmail))
            }
        }else{
            return .failure(.init(type: .email, error: NajatError.inValidEmail))
        }
    }
}
