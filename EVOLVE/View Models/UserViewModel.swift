//
//  UserViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 25/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserViewModel:NSObject, NSCoding {

    let id: Int
    let name: String
    let email: String
    let avatar: String
    let loginType: String
    let fcmToken: String
    
    override init() {
        id = kInt0
        name = kBlankString
        email = kBlankString
        avatar = kBlankString
        loginType = "custom"
        fcmToken = kBlankString
    }

    init(_ json: JSON) {
        id = json["id"].intValue
        name = json["user_name"].stringValue
        email = json["email"].stringValue
        avatar = json["avatar"].stringValue
        loginType = json["login_type"].stringValue
        fcmToken = json["fcm_token"].stringValue
    }
    
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        name = aDecoder.decodeObject(forKey: "name") as? String ?? kBlankString
        email = aDecoder.decodeObject(forKey: "email") as? String ?? kBlankString
        avatar = aDecoder.decodeObject(forKey: "avatar") as? String ?? kBlankString
        loginType = aDecoder.decodeObject(forKey: "loginType") as? String ?? kBlankString
        fcmToken = aDecoder.decodeObject(forKey: "fcmToken") as? String ?? kBlankString
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.avatar, forKey: "avatar")
        aCoder.encode(self.loginType, forKey: "loginType")
        aCoder.encode(self.fcmToken, forKey: "fcmToken")
    }

}
