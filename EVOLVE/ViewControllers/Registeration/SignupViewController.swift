//
//  SignupViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 20/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class SignupViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    //MARK:- variables
    lazy var loginManager = LoginManager()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK:- Custom methods
    fileprivate func navigateToMain() {
        let storyboard = UIStoryboard(name: StoryboardNames.Profile, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SubscriptionViewController) as! SubscriptionViewController
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    
    //MARK:- Action methods
    @IBAction func actionSignup(_ sender: Any) {
        let nameValidation = Validations.nameValidation(txtName.text!)
        let emailValidation = Validations.emailValidation(txtEmail.text!)
        let passwordValidation = Validations.passwordValidation(txtPassword.text!)
        let confirmPassValidation = Validations.confirmPasswordValidation(passwordValidation.text, repeat: txtConfirmPassword.text!)
        
        if !nameValidation.isValid {
            self.showAlertView(message: nameValidation.message)
        }else if !emailValidation.isValid {
            self.showAlertView(message: emailValidation.message)
        }else if !passwordValidation.isValid {
            self.showAlertView(message: passwordValidation.message)
        }else if !confirmPassValidation.isValid {
            self.showAlertView(message: confirmPassValidation.message)
        }else {
            let params:ParamsAny = [DictKeys.name:nameValidation.text,
                                    DictKeys.email:emailValidation.text,
                                    DictKeys.password:passwordValidation.text,
                                    DictKeys.loginType:"custom"]
            self.registerUser(with: params)
        }
    }
    
    @IBAction func actionFacebookLogin(_ sender: Any) {
        loginManager.logIn(permissions:["public_profile", "email"], from: self) {[weak self] (result, error) in
            guard let self = self else {return}
            
            if let error = error {
                self.showAlertView(message: error.localizedDescription)
                return
            }
            
            if let result = result {
                if result.isCancelled {
                    self.showAlertView(message: PopupMessages.fbLoginCanceled)
                }else if result.declinedPermissions.contains("email") || result.declinedPermissions.contains("public_profile") {
                    self.showAlertView(message: PopupMessages.fbEmailRequired)
                }else {
                    let request = GraphRequest(graphPath: "me", parameters: ["fields":"email,name,picture.type(large)"], tokenString: result.token?.tokenString, version: nil, httpMethod: .get)
                    request.start { (connection, result, error) in
                        let fields = result as! [String:Any]
                        let name = (fields["name"] as? String) ?? kBlankString
                        let email = fields["email"] as? String
                        let imageURL = (((fields["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String) ?? kBlankString
                        if let email = email {
                            if email.trim().count > 0 {
                                let params:ParamsAny = [DictKeys.email:email,
                                                        DictKeys.loginType:"fb",
                                                        DictKeys.name:name,
                                                        DictKeys.profileImage: imageURL]
                                self.signinUser(with: params)
                            }else {
                                self.showAlertView(message: PopupMessages.fbEmailRequired)
                            }
                        }else {
                            self.showAlertView(message: PopupMessages.SomethingWentWrong)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func actionLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- API Calls
extension SignupViewController {
    fileprivate func registerUser(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RegisterationService.shared().getUserRegister(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.navigateToMain()
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
    fileprivate func signinUser(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RegisterationService.shared().getUserLogin(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.navigateToMain()
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}
