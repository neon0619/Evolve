//
//  ReceipeViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 25/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

struct RecipeViewModel {

    var id: Int
    var status: Int
    var categoryId: Int
    var note: String
    var tags: String
    var title: String
    var image: String
    var cookingTime: String
    var servingTime: String
    var servingSize: String
    var description: String
    var ingredients: String
    var instructions: String
    var preperationTime: String
    var checkedIngredients:String
    var spicePasteIngredients: String
    var shallotGarlicIngredients: String
    var checkedSpicePasteIngredients: String
    var checkedShallotGarlicIngredients: String
    
    init() {
        id = kInt0
        status = kInt0
        categoryId = kInt0
        note = kBlankString
        tags = kBlankString
        title = kBlankString
        image = kBlankString
        cookingTime = kBlankString
        servingTime = kBlankString
        servingSize = kBlankString
        description = kBlankString
        ingredients = kBlankString
        instructions = kBlankString
        preperationTime = kBlankString
        checkedIngredients = kBlankString
        spicePasteIngredients = kBlankString
        shallotGarlicIngredients = kBlankString
        checkedSpicePasteIngredients = kBlankString
        checkedShallotGarlicIngredients = kBlankString
    }

    init(_ json: JSON) {
        id = json["id"].intValue
        note = json["note"].stringValue
        tags = json["tags"].stringValue
        status = json["status"].intValue
        title = json["title"].stringValue
        image = json["image"].stringValue
        categoryId = json["category_id"].intValue
        ingredients = json["ingridient"].stringValue
        description = json["description"].stringValue
        cookingTime = json["cooking_time"].stringValue
        servingTime = json["serving_time"].stringValue
        servingSize = json["serving_size"].stringValue
        instructions = json["instruction"].stringValue
        preperationTime = json["preparation_time"].stringValue
        checkedIngredients = json["checked_ingredients"].stringValue
        spicePasteIngredients = json["spice_paste_ingredients"].stringValue
        shallotGarlicIngredients = json["fried_shallots_or_garlic_ingredients"].stringValue
        checkedSpicePasteIngredients = json["checked_spice_paste_ingredients"].stringValue
        checkedShallotGarlicIngredients = json["checked_fried_shallots_garlic_ingredients "].stringValue
    }
    
    func getCheckedIngredients() -> [Int] {
        var indeces = [Int]()
        if self.checkedIngredients.trim().count != 0 {
            indeces = self.checkedIngredients.components(separatedBy: ",").map {Int($0)!}
        }
        return indeces
    }
    
    func getCheckedSpiceIngredients() -> [Int] {
        var indeces = [Int]()
        if self.checkedSpicePasteIngredients.trim().count != 0 {
            indeces = self.checkedSpicePasteIngredients.components(separatedBy: ",").map {Int($0)!}
        }
        return indeces
    }
    
    func getCheckedGarlicIngredients() -> [Int] {
        var indeces = [Int]()
        if self.checkedShallotGarlicIngredients.trim().count != 0 {
            indeces = self.checkedShallotGarlicIngredients.components(separatedBy: ",").map {Int($0)!}
        }
        return indeces
    }
    
    func getIngredients() -> [IngredientViewModel] {
        if ingredients.trim().count != 0 {
            let list = ingredients.components(separatedBy: "&&")
            var ingredients = [IngredientViewModel]()
            for index in 0..<list.count {
                let ingredient = IngredientViewModel(id: index, name: list[index], type: .simple)
                ingredients.append(ingredient)
            }
            return ingredients
        }else {
            return []
        }
    }
    
    func getSpiceIngredients() -> [IngredientViewModel] {
        if spicePasteIngredients.trim().count != 0 {
            let list = spicePasteIngredients.components(separatedBy: "&&")
            var ingredients = [IngredientViewModel]()
            for index in 0..<list.count {
                let ingredient = IngredientViewModel(id: index, name: list[index], type: .spicePaste)
                ingredients.append(ingredient)
            }
            return ingredients
        }else {
            return []
        }
    }
    
    func getGarlicIngredients() -> [IngredientViewModel] {
        if shallotGarlicIngredients.trim().count != 0 {
            let list = shallotGarlicIngredients.components(separatedBy: "&&")
            var ingredients = [IngredientViewModel]()
            for index in 0..<list.count {
                let ingredient = IngredientViewModel(id: index, name: list[index], type: .garlicShallot)
                ingredients.append(ingredient)
            }
            return ingredients
        }else {
            return []
        }
    }
    
    func getInstructions() -> [String] {
        var list = [String]()
        if instructions.trim().count != 0 {
            list = instructions.components(separatedBy: "&&")
        }
        return list
    }
}
