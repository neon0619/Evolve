//
//  SigninViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 20/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import AuthenticationServices

class SigninViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var advanceLoginView: UIView!
    
    //MARK:- Variables
    lazy var loginManager = LoginManager()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppleLogin()
    }
    
    //MARK:- Custom methods
    fileprivate func setupAppleLogin() {
        if #available(iOS 13.0, *) {
            btnFacebook.isHidden = true
            advanceLoginView.isHidden = false
        }else {
            btnFacebook.isHidden = false
            advanceLoginView.isHidden = true
        }
    }
    
    fileprivate func navigateToMain() {
        let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.MainContainerViewController) as! MainContainerViewController
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    
    //MARK:- Action methods
    @IBAction func actionForgotPassword(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.GetPincodeViewController) as! GetPincodeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionSignin(_ sender: Any) {
        let emailValidation = Validations.emailValidation(txtEmail.text!)
        let passwordValidation = Validations.passwordValidation(txtPassword.text!)
        
        if !emailValidation.isValid {
            self.showAlertView(message: emailValidation.message)
        }else if !passwordValidation.isValid {
            self.showAlertView(message: passwordValidation.message)
        }else {
            let params:ParamsAny = [DictKeys.email:emailValidation.text,
                                    DictKeys.password:passwordValidation.text,
                                    DictKeys.loginType:"custom"]
            self.signinUser(with: params)
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
    
    @IBAction func actionSignup(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.SignupViewController) as! SignupViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionAppleLogin(_ sender: Any) {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
    
    
}

@available(iOS 13.0, *)
extension SigninViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        self.showAlertView(message: PopupMessages.SomethingWentWrong)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let params:ParamsAny = [DictKeys.email:email!,
                                    DictKeys.loginType:"apple",
                                    DictKeys.name:fullName!]
            self.signinUser(with: params)
        }
    }
}

//MARK:- API Calls
extension SigninViewController {
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
