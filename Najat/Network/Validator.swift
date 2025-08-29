//
//  Validator.swift
//  SaudiMarch
//
//  Created by Youssef on 10/20/22.
//  Copyright © 2022 Youssef. All rights reserved.
//

import Foundation

public class Validator {
    
    public static var isUserLoggedIn: Bool {
        UserDefaults.userData?.token != nil
    }
    
    @discardableResult
    static func validateAccountName(with name: String?) throws -> String {
        if let name = name {
            if name.isEmpty {
                throw UserAuthenticationError.accountName
            } else {
                return name
            }
        } else {
            throw UserAuthenticationError.accountName
        }
    }
    @discardableResult
    static func validateAccountNumber(with number: String?) throws -> String {
        if let number = number {
            if number.isEmpty {
                throw UserAuthenticationError.accountNumber
            } else {
                return number
            }
        }else {
            throw UserAuthenticationError.accountNumber
        }
    }
    @discardableResult
    static func validateBankName(with name: String?) throws -> String {
        if let name = name {
            if name.isEmpty {
                throw UserAuthenticationError.bankName
            } else {
                return name
            }
        }else {
            throw UserAuthenticationError.bankName
        }
    }
    @discardableResult
    static func validateIBAN(with IBAN: String?) throws -> String {
        if let IBAN = IBAN {
            if IBAN.isEmpty {
                throw UserAuthenticationError.IBAN
            } else {
                return IBAN
            }
        }else {
            throw UserAuthenticationError.IBAN
        }
    }
    @discardableResult
    static func validatePhone(with phone: String?, count: Int = 9) throws -> String {
        if let phone = phone {
            if phone.isEmpty {
                throw UserAuthenticationError.emptyPhone
            }
                        else if !phone.isInt {
                            if phone.replacingOccurrences(of: "+", with: "").isInt {
                                return phone
                            } else {
                                throw UserAuthenticationError.invalidPhone
                            }
                        }
            else if phone.count != count  {
                throw UserAuthenticationError.tooShortPhone(count: count)
//            } else if validatePhoneRegex(with: phone) == false{
//                throw UserAuthenticationError.invalidPhoneRegEx
            } else {
                return phone
            }
        } else {
            throw UserAuthenticationError.emptyPhone
        }
    }
    
    @discardableResult
    static func validateRequestArea(with value: String?) throws -> String {
        if let value = value {
          let doubleValue = Double(value) ?? 0
          if value.isEmpty {
            throw UserAuthenticationError.emptyField(description: UserAuthenticationError.invalidRequestArea.validatorErrorAssociatedMessage)
          } else if doubleValue > 100 || doubleValue == 0{
            throw UserAuthenticationError.invalidRequestArea
          } else {
            return value
          }
        } else {
          throw UserAuthenticationError.invalidRequestArea
        }
      }
    
    static func validatePhoneRegex(with phone: String?) -> Bool {
        let phoneReEx = "^(05|5)([0-9])+"  //"^[0-9]{8}$"
        let mobileTest = NSPredicate(format:"SELF MATCHES %@", phoneReEx)
        let result = mobileTest.evaluate(with: phone)
        if result{
            return true
        }else{
            return false
        }
    }
    
    @discardableResult
    static func validateMail(with mail: String?) throws -> String {
        if let mail = mail {
            if mail.isEmpty {
                throw UserAuthenticationError.emptyMail
            } else if !mail.trimmedString.isEmail {
                throw UserAuthenticationError.invalidMail
            } else {
                return mail.trimmedString
            }
        } else {
            throw UserAuthenticationError.emptyMail
        }
    }
    
    @discardableResult
    static func validatePlace(with place: String?) throws -> String {
        if let place = place {
            if place.isEmpty {
                throw UserAuthenticationError.emptyPlace
            } else {
                return place
            }
        } else {
            throw UserAuthenticationError.emptyPlace
        }
    }
    
    @discardableResult
    static func validateName(with name: String?) throws -> String {
        if let name = name {
            if name.isEmpty {
                throw UserAuthenticationError.emptyName
            } else if name.count < 3 {
                throw UserAuthenticationError.tooShortName
            } else {
                return name
            }
        } else {
            throw UserAuthenticationError.emptyName
        }
    }
    
    @discardableResult
    static func validateAge(with age: String?) throws -> String {
        if let age = age {
            if age.isEmpty {
                throw UserAuthenticationError.age
            } else {
                return age
            }
        }else {
            throw UserAuthenticationError.age
        }
    }
    
    @discardableResult
    static func validateHealthState(with healthState: String?) throws -> String {
        if let healthState = healthState {
            if healthState.isEmpty {
                throw UserAuthenticationError.healthState
            } else {
                return healthState
            }
        }else {
            throw UserAuthenticationError.healthState
        }
    }
    
    
    @discardableResult
    static func validateCVV(with cvv: String?) throws -> String {
        if let cvv = cvv {
            if cvv.isEmpty {
                throw UserAuthenticationError.emptyPayment
            }else if cvv.count < 5 {
                throw UserAuthenticationError.cvv
            } else {
                return cvv
            }
        } else {
            throw UserAuthenticationError.emptyPayment
        }
    }
    
    @discardableResult
    static func validateCreditCardNumber(with card: String?) throws -> String {
        if let card = card {
            if card.isEmpty {
                throw UserAuthenticationError.emptyPayment
            }else if card.count < 5 {
                throw UserAuthenticationError.creditCardNumber
            } else {
                return card
            }
        } else {
            throw UserAuthenticationError.emptyPayment
        }
    }
    
    @discardableResult
    static func validateAmount(with amount: String?) throws -> String {
        if let amount = amount {
            if amount.isEmpty {
                throw UserAuthenticationError.emptyPayment
            }else if amount.count < 1 {
                throw UserAuthenticationError.creditCardNumber
            } else {
                return amount
            }
        } else {
            throw UserAuthenticationError.emptyPayment
        }
    }
    
    @discardableResult
    static func validateCardName(with card: String?) throws -> String {
        if let card = card {
            if card.isEmpty {
                throw UserAuthenticationError.cardName
            } else {
                return card
            }
        }else {
            throw UserAuthenticationError.cardName
        }
    }
    
    
    @discardableResult
    static func validate(with value: String?, description: String? = nil, count: Int = 1) throws -> String {
        if let value = value {
            if value.isEmpty {
                throw UserAuthenticationError.emptyField(description: description ?? "")
            } else if value.count < count {
                throw UserAuthenticationError.tooShortField(description: description ?? "", count: count)
            } else {
                return value
            }
        } else {
            throw UserAuthenticationError.emptyField(description: description ?? "")
        }
    }
    
    @discardableResult
    static func validateBool(with value: Bool?, description: String? = nil, count: Int = 1) throws -> Bool {
        if let value = value {
            if value == true {
               return value
            } else {
                throw UserAuthenticationError.accept(description: description.unwrapped(or: ""))
            }
        } else {
            throw UserAuthenticationError.emptyField(description: description ?? "")
        }
    }

    @discardableResult
    static func validateCity(with city: String?) throws -> String {
        if let city = city {
            if city.isEmpty {
                throw UserAuthenticationError.city
            } else {
                return city
            }
        }else {
            throw UserAuthenticationError.city
        }
    }
    
    @discardableResult
    static func validateDistrict(with district: String?) throws -> String {
        if let district = district {
            if district.isEmpty {
                throw UserAuthenticationError.district
            } else {
                return district
            }
        }else {
            throw UserAuthenticationError.district
        }
    }
    
    @discardableResult
    static func validateMeal(with meal: String?) throws -> String {
        if let meal = meal {
            if meal.isEmpty {
                throw UserAuthenticationError.meal
            } else {
                return meal
            }
        }else {
            throw UserAuthenticationError.meal
        }
    }
    
    @discardableResult
    static func validateCountry(with country: String?) throws -> String {
        if let country = country {
            if country.isEmpty {
                throw UserAuthenticationError.country
            } else {
                return country
            }
        }else {
            throw UserAuthenticationError.country
        }
    }
    
    @discardableResult
    static func validateGender(with gender: String?) throws -> String {
        if let gender = gender {
            if gender.isEmpty {
                throw UserAuthenticationError.gender
            } else {
                return gender
            }
        }else {
            throw UserAuthenticationError.gender
        }
    }
    
    @discardableResult
    static func validateMealSize(with size: Int?) throws -> String {
        if let mealSize = size {
            if mealSize <= 0 {
                throw UserAuthenticationError.mealSize
            } else {
                return "\(mealSize)"
            }
        }else {
            throw UserAuthenticationError.mealSize
        }
    }
    
    @discardableResult
    static func validateMealCount(with count: String?) throws -> String {
        if let mealCount = count {
            if mealCount.isEmpty {
                throw UserAuthenticationError.mealCount
            } else {
                return mealCount
            }
        }else {
            throw UserAuthenticationError.mealCount
        }
    }
    
    @discardableResult
    static func validatePersonCount(with count: Int?) throws -> String {
        if let count = count {
            if count <= 0 {
                throw UserAuthenticationError.personCount
            } else {
                return "\(count)"
            }
        }else {
            throw UserAuthenticationError.personCount
        }
    }
    
    @discardableResult
    static func validateID(with id: String?) throws -> String {
        if let id = id {
            if id.isEmpty {
                throw UserAuthenticationError.ID
            } else {
                return id
            }
        }else {
            throw UserAuthenticationError.ID
        }
    }
    @discardableResult
    static func validateUserType(with userType: String?) throws -> String {
        if let userType = userType {
            if userType.isEmpty {
                throw UserAuthenticationError.userType
            } else {
                return userType
            }
        }else {
            throw UserAuthenticationError.userType
        }
    }
    
    @discardableResult
    static func validateImage(with image: Data?) throws -> String {
        if let image = image {
            if image.isEmpty {
                throw UserAuthenticationError.image
            } else {
                return String(decoding: image, as: UTF8.self)
            }
        }else {
            throw UserAuthenticationError.image
        }
    }
    
    static func validateFeature(with feature: String?) throws -> String {
        if let feature = feature {
            if feature.isEmpty {
                throw UserAuthenticationError.feature
            } else {
                return feature
            }
        } else {
            throw UserAuthenticationError.feature
        }
    }
    
    
    static func validateServiceType(with service: String?) throws -> String {
        if let service = service {
            if service.isEmpty {
                throw UserAuthenticationError.serviceType
            } else {
                return service
            }
        } else {
            throw UserAuthenticationError.serviceType
        }
    }
    @discardableResult
    static func validateDate(with date: String?) throws -> String {
        if let date = date {
            if date.isEmpty {
                throw UserAuthenticationError.date
            } else {
                return date
            }
        } else {
            throw UserAuthenticationError.date
        }
    }
    
    static func validateStartTime(with startTime: String?) throws -> String {
        if let startTime = startTime {
            if startTime.isEmpty {
                throw UserAuthenticationError.startTime
            } else {
                return startTime
            }
        } else {
            throw UserAuthenticationError.startTime
        }
    }
    
    static func validateEndTime(with endTime: String?) throws -> String {
        if let endTime = endTime {
            if endTime.isEmpty {
                throw UserAuthenticationError.endTime
            } else {
                return endTime
            }
        } else {
            throw UserAuthenticationError.endTime
        }
    }
    
    @discardableResult
    static func validateLocation(with location: String?) throws -> String {
        if let location = location {
            if location.isEmpty {
                throw UserAuthenticationError.location
            } else {
                return location
            }
        }else {
            throw UserAuthenticationError.location
        }
    }
    static func validateKids(with kids: String?) throws -> String {
        if let kids = kids {
            if kids.isEmpty {
                throw UserAuthenticationError.kids
            } else {
                return kids
            }
        }else {
            throw UserAuthenticationError.kids
        }
    }
    
    @discardableResult
    static func validateRate(with rate: String?) throws -> String {
        if let rate = rate {
            if rate.isEmpty {
                throw UserAuthenticationError.rate
            } else {
                return rate
            }
        }else {
            throw UserAuthenticationError.rate
        }
    }
    
    @discardableResult
    static func validateComment(with comment: String?) throws -> String {
        if let comment = comment {
            if comment.isEmpty {
                throw UserAuthenticationError.comment
            } else {
                return comment
            }
        }else {
            throw UserAuthenticationError.comment
        }
    }
    
    @discardableResult
    static func validateMessage(with message: String?) throws -> String {
        if let message = message {
            if message.isEmpty {
                throw UserAuthenticationError.message
            } else {
                return message
            }
        }else {
            throw UserAuthenticationError.message
        }
    }
    
    static func validateTitle(with title: String?) throws -> String {
        if let title = title {
            if title.isEmpty {
                throw UserAuthenticationError.title
            } else {
                return title
            }
        }else {
            throw UserAuthenticationError.title
        }
    }
    
    static func validateMaxiMumNum(with maxiMumNum: String?) throws -> String {
        if let maxiMumNum = maxiMumNum {
            if maxiMumNum.isEmpty {
                throw UserAuthenticationError.maxiMumNum
            } else {
                return maxiMumNum
            }
        }else {
            throw UserAuthenticationError.maxiMumNum
        }
    }
    
    static func validateDiscount(with discount: String?) throws -> String {
        if let discount = discount {
            if discount.isEmpty {
                throw UserAuthenticationError.discount
            } else {
                return discount
            }
        }else {
            throw UserAuthenticationError.discount
        }
    }
    
    @discardableResult
    static func validatePromoCode(with pronoCode: String?) throws -> String {
        if let pronoCode = pronoCode {
            if pronoCode.isEmpty {
                throw UserAuthenticationError.pronoCode
            } else {
                return pronoCode
            }
        }else {
            throw UserAuthenticationError.pronoCode
        }
    }
    
    @discardableResult
    static func validatePayType(with payType: String?) throws -> String {
        if let payType = payType {
            if payType.isEmpty {
                throw UserAuthenticationError.payType
            } else {
                return payType
            }
        }else {
            throw UserAuthenticationError.payType
        }
    }
    
    @discardableResult
    static func validateTransactionID(with transactionID: String?) throws -> String {
        if let transactionID = transactionID {
            if transactionID.isEmpty {
                throw UserAuthenticationError.transactionID
            } else {
                return transactionID
            }
        }else {
            throw UserAuthenticationError.transactionID
        }
    }
    
    @discardableResult
    static func validate<T: Any>(with value: T?, decription: String? = nil) throws -> T {
        if let value = value {
            return value
        } else {
            throw UserAuthenticationError.emptyField(description: decription ?? "")
        }
    }
    
    @discardableResult
    static func validate<T: Any>(array value: [T]?, decription: String? = nil, count: Int = 1) throws -> [T] {
        guard let value = value, !value.isEmpty else {
            throw UserAuthenticationError.emptyField(description: decription ?? "")
        }
        guard value.count >= count else {
            throw UserAuthenticationError.tooShortField(description: decription ?? "", count: count)
        }
        return value
    }
    
    
    @discardableResult
    static func validatePassword(with password: String?, minCount: Int = 6) throws -> String {
        guard let password = password, !password.isEmpty else {
            throw UserAuthenticationError.emptyPass
        }
       
        guard password.count >= minCount else {
            throw UserAuthenticationError.tooShortPass(count: minCount)
        }
        
        guard isValidPassword(password) else {
            throw UserAuthenticationError.wrongPass
        }
        
        return password
    }
  
    @discardableResult
    static func isValidPassword(_ password: String?) -> Bool {
        let passwordRegEx = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{6,}$"


        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    @discardableResult
    static func validateTwoPasswords(password: String?, confirmPassword: String?, minCount: Int = 6) throws  -> String {
        guard let password = password, !password.isEmpty else {
            throw UserAuthenticationError.emptyPass
        }
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            throw UserAuthenticationError.emptyConfirmPass
        }
        
        guard password == confirmPassword else {
            throw UserAuthenticationError.notTheSamePasswords
        }
        guard password.count >= minCount else {
            throw UserAuthenticationError.tooShortPass(count: minCount)
        }
        
        guard isValidPassword(password) else {
            throw UserAuthenticationError.wrongPass
        }
        
        return password
    }

    @discardableResult
    static func validateLocation(lat: String?, lng: String?) throws  -> (lat: String, lng: String) {
        if let lat = lat, let lng = lng, !lat.isEmpty, !lng.isEmpty {
            return (lat: lat, lng: lng)
        } else {
            throw UserAuthenticationError.selectLocation
        }
    }
    
    enum UserAuthenticationError: AppError {
        
        case invalidMail
        case invalidPhone
        case tooShortName
        case tooShortPass(count: Int)
        case tooShortPhone(count: Int)
        case invalidPhoneRegEx
        
        // Parent
        case emptyName
        case emptyLastName
        case ID
        case gender
        case city
        case country
        case emptyPass
        case emptyConfirmPass
        
        //Sevice
        case userType
        case emptyMail
        case emptyPhone
        case image
        case feature
        //Reserve Order
        case serviceType
        case date
        case startTime
        case endTime
        case location
        case kids
        case healthState
        case title
        case maxiMumNum
        case discount
        case pronoCode
        case age
        case notTheSamePasswords
        case selectLocation
        case emptyField(description: String)
        case accept(description: String)
        case tooShortField(description: String, count: Int)
        case mealSize
        case mealCount
        case personCount
        case emptyPayment
        case meal
        case district
        case rate
        case comment
        case message
        
        //Payment
        case cvv
        case creditCardNumber
        case cardName
        case amount
        case payType
        case transactionID
        
        case bankName
        case accountName
        case accountNumber
        case IBAN
        case wrongPass
        case invalidRequestArea
        case emptyPlace
        
        var validatorErrorAssociatedMessage: String {
            var message = "Error"
            
            switch self {
            case .invalidMail:
                message = "Enter Your Valid E-mail."
            case .tooShortName:
                message = "Enter Your Full Name, Must Be At Least 6 Chars."
            case .tooShortPass(let count):
                message = "\("Password Should Be At Least".localized) \(count) \("Chars".localized)."

            case .accept(let description):
                message = description

            case .emptyName:
                message = "Empty Name."
            case .emptyLastName:
                message = "Please Enter Your Last Name"
            case .ID:
                message = "Please Enter Your ID"
            case .gender:
                message = "Please Enter Your gender"
            case .city:
                message = "Please Enter Your City"
            case .country:
                message = "Please Enter Your Country"
            case .userType:
                message = "Please Enter userType"
            case .feature:
                message = "Please select Features"
                
            case .emptyPass:
                message = "Please Enter Your Password."
            case .emptyConfirmPass:
                message = "Please Confirm Your Password."
                
                //Reserve
            case .serviceType:
                message = "Please select Service Type."
            case .date:
                message = "Please select Date."
                
            case .startTime:
                message = "Please select Start Time."
                
            case .endTime:
                message = "Please select end Time."
                
            case .location:
                message = "Please select Location."
                
            case .kids:
                message = "Please select Kids."
            case .age:
                message = "Please insert age."
            case .healthState:
                message = "Please insert health state"
            case .image:
                message = "Please uploade  Image."
                
            case .title:
                message = "Please Insert Title."
                
            case .maxiMumNum:
                message = "Please Insert Maximum Num."
                
            case .discount:
                message = "Please Insert discount."
            case .pronoCode:
                message = "Please Insert promoCode."
                
            case .emptyMail:
                message = "Empty Mail!"
            case .emptyField(let decription):
                message = "\("Please Enter Valid".localized) \(decription)"
            case .tooShortField(let decription, let count):
                message = "\("Please Enter Valid".localized) \(decription), \("Must Be At least".localized) \(count)."
            case .tooShortPhone(let count):
                let txt = "Enter Your Valid Phone Number, Must Be".localized
                message = txt + " \(count) " + "Digits".localized
            case .emptyPhone:
                message = "Enter Your Valid Phone Number."
            case .invalidPhone:
                message = "Your Phone Number Is Invalid."
            case .notTheSamePasswords:
                message = "Enter The Same Password Twice."
            case .selectLocation:
                message = "Please Select Your Location."
            case .mealSize:
                message = "Please Select Your Meal Size."
            case .mealCount:
                message = "Please Select Your Meals Count."
            case .personCount:
                message = "Number of person should be > zero."
            case .cvv:
                message = "Number of digits should 3-4 digit"
            case .creditCardNumber:
                message = "Number of digits should 19 digit"
            case .emptyPayment:
                message = "Enter Your Valid Number."
            case .meal:
                message = "Please Enter Your Meal"
            case .district:
                message = "Please Enter Your District"
            case .rate:
                message = "Please Enter Your Rate"
            case .comment:
                message = "Please Enter Your Comment"
            case .cardName:
                message = "Please Enter Card Name"
            case .payType:
                message = "Please Select Payment Method"
            case .amount:
                message = "Please Enter Your Amount "
            case .message:
                message = "Please Enter Your Message"
            case .invalidPhoneRegEx:
                message = "Phone Number should start with 05 or 9665"
            case .transactionID:
                message = "Please Enter Transaction ID"
                
            case .bankName:
                message = "please enter bank name"
            case .accountName:
                message = "please enter account name"
            case .accountNumber:
                message = "please enter account number"
            case .IBAN:
                message = "please enter IBAN"
            case .wrongPass:
                message = "Password must contain uppercase and lowercase letters, and numbers"
            case .invalidRequestArea:
                    message = "Please Enter valid request area from 0 to 100 kilo meter"

            case .emptyPlace:
                message = "Please enter a valid place description."
            }
            return message.localized
        }
    }
}

extension String {
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: trimmedString)
    }
}
