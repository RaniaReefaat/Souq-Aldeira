//
//  AppError.swift
//  Youssef
//
//  Created by Youssef on 16/12/2021.
//  Copyright © 2021 Youssef. All rights reserved.
//

import Foundation

protocol AppError: LocalizedError {
    var validatorErrorAssociatedMessage: String { get }
}

enum MyAppError: AppError {
    
    case networkError
    case businessError(String)
    case basicError
    case localValidation(NajatError)
    
    public var validatorErrorAssociatedMessage: String {
        switch self {
        case .networkError:
            return Constants.Error.networkErrorMessage
        case .businessError( let error):
            return error
        case .basicError:
            return "Something wrong happened, try again later."
        case .localValidation(let error):
            return error.localizedDescription
        }
    }
    
    public var errorHandler: NajatError {
        switch self {
        case .networkError:
            return .init(type: .defaultError, error: Constants.Error.networkErrorMessage)
        case .businessError(let error):
            return .init(type: .defaultError, error: error)
        case .basicError:
            return .init(type: .defaultError, error: "Something wrong happened, try again later.")
        case .localValidation(let error):
            return error
        }
    }
}

enum NajatErrorTypes {
    case defaultError
    case phone
    case password
    case confirmPassword
    case email
    case name
    case providerId
    case providerName
    case addressTitle
    case addressLocation
    case buildNumber
    case floorNumber
    case apartmentNumber
    case terms
case bio
    case description
    case price
    case storeImage
    case licenseImage

}

struct NajatError: AppError {
    var type: NajatErrorTypes
    var error: String
}

extension NajatError {
    static var phoneNotHaveCode = "not_have_phoneCode_validation".localized
    static var emptyPhone = "Phone number field is empty".localized
    static var smallPhoneNumber = "Phone number is inValid".localized
    static var emptyName = "Name Field is empty".localized
    static var shortName = "Name is too short".localized
    static var termsNotSelected = "You should check terms and conditions".localized
    static var inValidEmail = "Email is not valid".localized
    static var userBio = "Enter valid bio".localized
    static var contactMessage = "Enter your message".localized
    static var emptyEmail = "Email Field is empty".localized
    static var description = "Enter description".localized
    static var price = "Enter delivery price".localized
    static var storeImage = "Choose store image".localized
    static var licenseImage = "Choose store license image".localized
}
