//
//  AuthService.swift
//
//
//  Created by Youssef on 03/10/2022.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation
//import InstantSearch
//import AlgoliaSearchClient

enum LoginTypes: Codable {
    case defaultLogin
    case socialLoginWithoutPhone
    case socialLoginWithPhone
}

extension UserDefaults {
    @UserDefault(key: "show_overview", defaultValue: true)
    static var showOverview: Bool
    
    @UserDefault(key: "show_specifications", defaultValue: true)
    static var showSpecifications: Bool
    
    @UserDefault(key: Constants.Keys.userDataKey, defaultValue: nil)
    static var userData: UserDataModel?
    
    @UserDefault(key: "Guest Token", defaultValue: nil)
    static var token: String?
    
    @UserDefault(key: "is_loggedin", defaultValue: false)
    static var isLoggedIn: Bool
    
    @UserDefault(key: "login_type", defaultValue: .defaultLogin)
    static var loginType: LoginTypes
    
    @UserDefault(key: "recent_categories", defaultValue: [])
    static var recentCategories: [String]
    
    @UserDefault(key: "UserSelectLang", defaultValue: nil)
    static var UserSelectLang: String?
//
//    @UserDefault(key: "DidUserSeeOnbourding", defaultValue: false)
//    static var didUserSeeOnbourding: Bool
//
//    @UserDefault(key: "DidUserSeeProfileData", defaultValue: false)
//    static var didUserSeeProfileData: Bool
    
    @UserDefault(key: "RecentSearches", defaultValue: [])
    static var recentSearches: [String]
    
    @UserDefault(key: "addressID", defaultValue: 0)
    static var addressID: Int
    
    @UserDefault(key: Constants.Keys.showUnlikeWarning, defaultValue: true)
    static var UnlikeWarning: Bool?
    
    @UserDefault(key: "baseUrl", defaultValue: "https://aldira.work/api/")
//    @UserDefault(key: "baseUrl", defaultValue: "https://Appv2.products.aait-d.com/api/")
    static var baseUrl: String
    
    @UserDefault(key: "isDriver", defaultValue: false)
    static var isDriver: Bool?
    
    @UserDefault(key: "orderID", defaultValue: nil)
    static var hasOrderNotification: Int?
    
    @UserDefault(key: "orderIDWhenOutOfStock", defaultValue: nil)
    static var hasOrderOutOfStockNotification: Int?
    
    @UserDefault(key: "contactUsTapped", defaultValue: false)
    static var isContactUsTapped: Bool?
    
}

class AuthService {
    static func updateNotifications(allow: Bool) {
        var oldData = UserDefaults.userData
//        oldData?.allowNotification = allow
        UserDefaults.userData = oldData
    }
}

public struct UserData: Codable {
    
//  Optional Init
    init() {
        self.id = nil
        self.fullName = nil
        self.email = nil
        self.phoneCode = nil
        self.phone = nil
        self.isActive = nil
        self.gender = nil
        self.isComplete = nil
        self.registerCompleteStep = nil
        self.locale = nil
        self.avatar = nil
//        self.country = nil
//        self.nationality = nil
        self.phoneCompleteForm = nil
        self.isVerify = nil
        self.wallet = nil
        self.points = nil
        self.cashback = nil
        self.token = nil
        self.isAllowNotifications = nil
        self.userType = nil
    }
    
    init(name: String, email: String) {
        self.id = nil
        self.fullName = name
        self.email = email
        self.phoneCode = nil
        self.phone = nil
        self.isActive = nil
        self.gender = nil
        self.isComplete = nil
        self.registerCompleteStep = nil
        self.locale = nil
        self.avatar = nil
//        self.country = nil
//        self.nationality = nil
        self.phoneCompleteForm = nil
        self.isVerify = nil
        self.wallet = nil
        self.points = nil
        self.cashback = nil
        self.token = nil
        self.isAllowNotifications = nil
        self.userType = nil
    }
    
    let id: Int?
    let fullName, email: String?
    let phoneCode, phone: String?
    let isActive: Bool?
    let gender: String?
    let isComplete: Bool?
    let registerCompleteStep: Int?
    let locale: String?
    let avatar: String?
//    let country: CountryModel?
//    let nationality: Nationality?
    let phoneCompleteForm: String?
    let isVerify: Bool?
    let wallet, points, cashback: Double?
    let token: String?
    var isAllowNotifications: Bool?
    var userType: String?

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "full_name"
        case email
        case phoneCode = "phone_code"
        case phone
        case isActive = "is_active"
        case gender
        case isComplete = "is_complete"
        case registerCompleteStep = "register_complete_step"
        case locale, avatar
        case phoneCompleteForm = "phone_complete_form"
        case isVerify = "is_verify"
        case wallet, token, points, cashback
        case isAllowNotifications = "is_allow_notification"
        case userType = "user_type"
    }
}

public enum Constants {
  enum Address {
    static let addressLine1Length = 200
    static let addressLine2Length = 200
    static let cityLength = 50
    static let stateLength = 50
    static let zipLength = 50
    static let countryLength = 2
  }

    public enum Phone {
        public static let phoneMaxLength = 25
        static let phoneMinLength = 6
        static let countryCodeMinLength = 1
        static let countryCodeMaxLength = 7
    }

  enum Product {
    static let version = "4.2.0"
    static let name = "checkout-ios-sdk"
    static let userAgent = "checkout-sdk-ios/\(version)"
  }
    
    static var baseUrl: String {
        get {
            UserDefaults.baseUrl
        } set {
            UserDefaults.baseUrl = newValue
        }
    }
   
    static let currency = "KD".localized
    static let appId = "id1486154220"

    struct Error {
        static let networkErrorMessage = "networkErrorMessage"
    }
    
    struct Keys {
        static let userDataKey = "|_User_|_Data_|"
        static let userSubScripDataKey = "|_User_|_SubSrip_|"
        static let userIntroKey = "|_User_|_Intro_|"
        static let showUnlikeWarning = "removeItemItemFromFavourites"
    }
    
    struct HeaderKind {
        static let space = "SpaceCollectionReusableView"
        static let globalSegmentedControl = "segmentedControlHeader"
    }
    
    static let apiGoogleMap = "AIzaSyAV3ZKirEWJIMW8T4SWoK9rXd7VThciUtw"

    
}
