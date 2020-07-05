//
//  Validations.swift
//  SimSwitch
//
//  Created by iOS Developer on 29/10/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import Foundation


class Validations {
    
    struct ValidationResult {
        var isValid:Bool
        var text:String
        var message:String
        
        init() {
            isValid = true
            text = kBlankString
            message = kBlankString
        }
        
        init(isValid:Bool, message:String, text:String) {
            self.text = text
            self.isValid = isValid
            self.message = message
        }
    }
    
    class func nameValidation(_ name:String) -> ValidationResult {
        var result = ValidationResult()
        result.text = name
        if name.trim().count == 0 {
            result.isValid = false
            result.message = ValidationMessages.emptyName
        }
        
        return result
    }
    
    class func pincodeValidation(_ code:String) -> ValidationResult {
        var result = ValidationResult()
        result.text = code
        if code.trim().count == 0 {
            result.isValid = false
            result.message = ValidationMessages.emptyPincode
        }
        
        return result
    }
    
    class func emailValidation(_ email:String) -> ValidationResult {
        var validationResult = ValidationResult()
        validationResult.text = email
        
        let emailRegEx = EMAIL_REGULAR_EXPRESSION
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email.trim())
        
        validationResult.isValid = result
        if !result {
            validationResult.message = ValidationMessages.enterValidEmail
        }
        
        return validationResult
    }
    
    class func passwordValidation(_ password:String, shouldCheckLength:Bool = true) -> ValidationResult {
        var validationResult = ValidationResult()
        validationResult.isValid = true
        validationResult.text = password
        
        if password.trim().count == kInt0 {
            validationResult.isValid = false
            validationResult.message = ValidationMessages.emptyPassword
        }

        return validationResult
    }
    
    class func confirmPasswordValidation(_ password:String, repeat samePassword:String) -> ValidationResult {
        var validationResult = ValidationResult()
        
        if samePassword.count == 0 {
            validationResult.isValid = false
            validationResult.message = ValidationMessages.reTypePassword
        }else if password != samePassword {
            validationResult.isValid = false
            validationResult.message = ValidationMessages.nonMatchingPassword
        }
        
        return validationResult
    }
    
    class func phoneNumberValidation(_ phoneNumber:String) -> ValidationResult {
        var validationResult = ValidationResult()
        validationResult.text = phoneNumber
        
        if phoneNumber.count < 9 {
            validationResult.isValid = false
            validationResult.message = ValidationMessages.invalidPhoneNumber
        }
        
        return validationResult
    }
    
}
