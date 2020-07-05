//
//  CategoryListViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 02/04/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class CategoryListViewModel {
    
    //MARK:- data members
    var recents = [CategoryViewModel]()
    var meals = [CategoryViewModel]()
    var diets = [CategoryViewModel]()
    var times = [CategoryViewModel]()
    
    //MARK:- Init methods
    init() {
        recents = []
        meals = []
        diets = []
        times = []
    }
    
    convenience init(_ jsonDict:JSON) {
        self.init()
        recents = jsonDict["recently"].arrayValue.map {CategoryViewModel($0)}
        meals = jsonDict["meal"].arrayValue.map {CategoryViewModel($0)}
        diets = jsonDict["diet"].arrayValue.map {CategoryViewModel($0)}
        times = jsonDict["time"].arrayValue.map {CategoryViewModel($0)}
    }
}
