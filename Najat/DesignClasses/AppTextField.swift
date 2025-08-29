//
//  AppTextField.swift
//  New-Zoz-Resturant
//
//  Created by Youssef on 12/01/2023.
//

import UIKit


enum TextFieldType {
    case name
    case email
    case password
    case phone(count: Int = 8)
    case subject
    case message
    case repeatPassword(textFieldToCompare: UITextField)
    case newPassword
    case code
    case cardNumber
    case cvv
}

class AppTextField: SkyFloatingLabelTextField {
    
    var type: TextFieldType = .name

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        borderStyle = .none
        
        lineColor = .gray
        selectedLineColor = .gray
        
        tintColor = .blue // Indicator
        textColor = .blackColor // Text
        titleColor = .blackColor
        
        lineHeight = 0
        placeholderColor = .gray
        selectedTitleColor = .gray
        errorColor = .redColor
        
        titleFont = .regularFont(of: 14)
        font = .regularFont(of: 16)
        placeholderFont = .regularFont(of: 16)
        setLeftPaddingPoints(10)
        setRightPaddingPoints(10)
    }

    func isValidText() -> Bool {
        switch type {
        case .name:
            do {
                try Validator.validateName(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .email:
            do {
                try Validator.validateMail(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .password:
            do {
                try Validator.validatePassword(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .phone(let count):
            do {
                try Validator.validatePhone(with: text, count: count)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .repeatPassword(let password):
            do {
                try Validator.validateTwoPasswords(password: password.text, confirmPassword: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .newPassword:
            do {
                try Validator.validatePassword(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        case .cardNumber:
            do {
                try Validator.validateCreditCardNumber(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
            
        case .cvv:
            do {
                try Validator.validateCVV(with: text)
                return true
            } catch {
                showError(with: error.validatorErrorAssociatedMessage)
                return false
            }
        default:
            return true
        }
    }
    
    override func createLineView() {
        
    }
}

