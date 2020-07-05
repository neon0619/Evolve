//
//  UpdatePasswordViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 26/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class UpdatePasswordViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var txtPincode: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var email:String!
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- Action methods
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionResetPassword(_ sender: Any) {
        let passwordValidation = Validations.passwordValidation(txtPassword.text!)
        let pincode = txtPincode.text!
        if pincode.count == 0 {
            self.showAlertView(message: ValidationMessages.emptyPincode)
        }else if !passwordValidation.isValid {
            self.showAlertView(message: passwordValidation.message)
        }else {
            let params:ParamsAny = [DictKeys.email:self.email ?? kBlankString,
                                    DictKeys.pincode:pincode,
                                    DictKeys.newPassword:passwordValidation.text]
            self.resetPassword(with: params)
        }
    }
    
}

//MARK:- API Calls
extension UpdatePasswordViewController {
    fileprivate func resetPassword(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RegisterationService.shared().updatePassword(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.showAlertView(message: message, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
