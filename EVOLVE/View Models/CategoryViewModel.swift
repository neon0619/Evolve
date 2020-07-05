//
//  SearchCategoryViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 02/04/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryViewModel {
    
    //MARK:- data members
    var id:Int
    var name:String
    var type:String
    var status:Int
    var image:String
    
    //MARK:- Init methods
    init() {
        id = kInt0
        name = kBlankString
        type = kBlankString
        status = kInt0
        image = kBlankString
    }
    
    convenience init(_ jsonDict:JSON) {
        self.init()
        id = jsonDict["id"].intValue
        name = jsonDict["category_name"].stringValue
        type = jsonDict["type"].stringValue
        image = jsonDict["image"].stringValue
        status = jsonDict["status"].intValue
    }
}
