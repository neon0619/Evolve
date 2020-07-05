//
//  IngredientViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 30/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation

class IngredientViewModel {
    
    //MARK:- data members
    var id:Int
    var name:String
    var type:IngredientType
    
    //MARK:- Init methods
    init() {
        id = kInt0
        name = kBlankString
        type = .none
    }
    
    init(id:Int, name:String, type: IngredientType) {
        self.id = id
        self.name = name
        self.type = type
    }
    
    func getIngredientName() -> String {
        let list = name.components(separatedBy: "||")
        if list.count > 1 {
            return list[1].trim()
        }
        
        return name.trim()
    }
    
    func getIngredientQuantity() -> String {
        let list = name.components(separatedBy: "||")
        if list.count > 0 {
            return list[0].trim()
        }
        
        return kBlankString
    }
    
}
