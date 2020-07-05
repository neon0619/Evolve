//
//  RegisterationService.swift
//  EVOLVE
//
//  Created by iOS Developer on 04/09/2019.
//  Copyright © 2019 AcclivousByte. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RegisterationService: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> RegisterationService {
        return RegisterationService()
    }
    
    fileprivate func saveUserInfo(_ userInfo:UserViewModel) {
        Global.shared.user = userInfo
        UserDefaultsManager.shared.isUserLoggedIn = true
        UserDefaultsManager.shared.userInfo = userInfo
    }
    
    //MARK:- Register User API.
    func getUserRegister(params:ParamsAny, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.Register
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let userInfo = UserViewModel(json![KEY_RESPONSE_DATA])
                self.saveUserInfo(userInfo)
            }
            completion(message,success)
        }
    }
    
    //MARK:- Login user API.
    func getUserLogin(params:Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.login
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let userInfo = UserViewModel(json![KEY_RESPONSE_DATA])
                self.saveUserInfo(userInfo)
            }
            completion(message,success)
        }
    }
    
    //MARK:- Register User API.
    func updateUserProfile(params:ParamsString, profileImage:UIImage?, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.updateProfile
        var imageDict = [String:Data]()
        if let image = profileImage {
            imageDict[DictKeys.profileImage] = image.jpegData(compressionQuality: 0.8)!
        }
        self.makePostAPICallWithMultipart(with: completeURL, dict: imageDict, params: params, headers: self.getHeaders()) { (message, success, json) in
            if success {
                let userInfo = UserViewModel(json![KEY_RESPONSE_DATA])
                self.saveUserInfo(userInfo)
            }
            completion(message,success)
        }
    }
    
    //MARK:- Forget password API
    func forgetPassword(params:Parameters?,completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.forgetPassword
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            completion(message,success)
        }
    }
    
    //MARK:- Change Password API
    func changePassword(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.changePassword
        self.makePostAPICall(with: completeUrl, params: params, headers: self.getHeaders()) { (message, success, json) in
            completion(message,success)
        }
    }
    
    //MARK:- Update Password API
    func updatePassword(params:ParamsAny?, completion: @escaping (_ message:String, _ success:Bool)->Void) {
        let completeUrl = EndPoints.BASE_URL + EndPoints.updatePassword
        self.makePostAPICall(with: completeUrl, params: params) { (message, success, json) in
            completion(message,success)
        }
    }
//    
//    //MARK:- Logout user API
//    func getUserLogout(params:Parameters?,completion: @escaping (_ message: String, _ success: Bool)->Void){
//        
//        let completeURL = EndPoints.BASE_URL + EndPoints.logout
//        let header:HTTPHeaders = [DictKeys.authoraization:Global.shared.user?.token ?? kBlankString]
//        self.makePostAPICall(with: completeURL, params: params, headers: header) { (message, success, json, responseType) in
//            completion(message,success)
//        }
//    }
    
}
