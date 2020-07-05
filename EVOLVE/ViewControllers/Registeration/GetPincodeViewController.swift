//
//  GetPincodeViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 26/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class GetPincodeViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var txtEmail: UITextField!
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Custom methods
    fileprivate func navigateToUpdatePassword() {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.UpdatePasswordViewController) as! UpdatePasswordViewController
        controller.email = txtEmail.text!
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK:- Action methods
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionSendCode(_ sender: Any) {
        let emailValidation = Validations.emailValidation(txtEmail.text!)
        
        if !emailValidation.isValid {
            self.showAlertView(message: emailValidation.message)
        }else {
            let params:ParamsAny = [DictKeys.email:emailValidation.text]
            self.sendVerificationCode(params)
        }
    }
    
}

//MARK:- API Calls
extension GetPincodeViewController {
    fileprivate func sendVerificationCode(_ params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RegisterationService.shared().forgetPassword(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.showAlertView(message: message, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                            self.navigateToUpdatePassword()
                        }
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
