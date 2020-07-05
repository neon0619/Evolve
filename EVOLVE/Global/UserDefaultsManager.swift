//
//  UserDefaultsManager.swift
//  OrderAte
//
//  Created by iOS Developer on 12/09/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import Foundation

fileprivate struct UserDefaultsKeys {
    static let isUserLoggedIn = "isUserLoggedIn"
    static let loggedInUserInfo = "loggedInUserInfo"
    static let configurationUrl = "configurationUrl"
    static let shouldShowLoginScreen = "shouldShowLoginScreen"
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let manager = UserDefaults.standard
    
    private init() {}
    
    var isUserLoggedIn:Bool {
        set {
            manager.set(newValue, forKey:UserDefaultsKeys.isUserLoggedIn)
            manager.synchronize()
        }
        get {
            return manager.bool(forKey: UserDefaultsKeys.isUserLoggedIn)
        }
    }
    
    var shouldShowLoginScreen:Bool {
        set {
            manager.set(newValue, forKey:UserDefaultsKeys.shouldShowLoginScreen)
            manager.synchronize()
        }
        get {
            return manager.bool(forKey: UserDefaultsKeys.shouldShowLoginScreen)
        }
    }
    
    var userInfo:UserViewModel! {
        set {
            let data = NSKeyedArchiver.archivedData(withRootObject: newValue!)
            manager.set(data, forKey: UserDefaultsKeys.loggedInUserInfo)
            manager.synchronize()
        }
        get {
            if let data = manager.data(forKey: UserDefaultsKeys.loggedInUserInfo) {
                let userInfo = NSKeyedUnarchiver.unarchiveObject(with: data) as! UserViewModel
                return userInfo
            }else {
                return nil
            }
            
        }
    }
    
    func clearUserData() {
        Global.shared.user = nil
        Global.shared.isLogedIn = false
        manager.removeObject(forKey: UserDefaultsKeys.loggedInUserInfo)
        manager.set(false, forKey: UserDefaultsKeys.isUserLoggedIn)
        manager.synchronize()
    }
    
}
