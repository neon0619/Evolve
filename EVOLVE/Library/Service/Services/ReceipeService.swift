//
//  ReceipeService.swift
//  EVOLVE
//
//  Created by iOS Developer on 25/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RecipeService: BaseService {
    
    //MARK:- Shared Instance
    private override init() {}
    static func shared() -> RecipeService {
        return RecipeService()
    }
    
    //MARK:- Get Home Listing
    func getHomeDataListing(completion: @escaping (_ error: String, _ success: Bool,_ data:HomeDataViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.HomeData
        self.makeGetAPICall(with: completeURL, params: nil) { (message, success, json) in
            if success {
                let homeData = HomeDataViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success,homeData)
            }else {
                completion(message,success,nil)
            }
        }
    }
    
    //MARK:- Get Recipe Details
    func getRecipeDetails(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool,_ data:RecipeViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.getReceipeDetails
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let recipe = RecipeViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success,recipe)
            }else {
                completion(message,success,nil)
            }
        }
    }
    
    //MARK:- Get Favourite Recipes
    func getFavouriteRecipes(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool,_ data:RecipeListViewModel?)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.getFavoriteListing
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let recipe = RecipeListViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success,recipe)
            }else {
                completion(message,success,nil)
            }
        }
    }
    
    //MARK:- Favourite / Unfavourite Recipe
    func markFavouriteRecipe(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.favouriteReceipe
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            completion(message,success)
        }
    }
    
    //MARK:- Search Recipes
    func searchRecipes(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool,_ data:RecipeListViewModel?)->Void) {
        
        let completeURL = EndPoints.BASE_URL + EndPoints.searchRecipes
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let recipe = RecipeListViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success,recipe)
            }else {
                completion(message,success,nil)
            }
        }
    }
    
    //MARK:- add shopping Recipe
    func addToShoppingRecipe(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool)->Void){
        
        let completeURL = EndPoints.BASE_URL + EndPoints.addToShoppingList
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            completion(message,success)
        }
    }
    
    //MARK:- Get Shopping Recipes
    func getShoppingRecipes(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool,_ data:RecipeListViewModel?)->Void) {
        
        let completeURL = EndPoints.BASE_URL + EndPoints.getShoppingList
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            if success {
                let recipe = RecipeListViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success,recipe)
            }else {
                completion(message,success,nil)
            }
        }
    }
    
    //MARK:- Get Shopping Recipes
    func updateRecipeIngredients(params: ParamsAny, completion: @escaping (_ error: String, _ success: Bool)->Void) {
        
        let completeURL = EndPoints.BASE_URL + EndPoints.updateIngredientList
        self.makePostAPICall(with: completeURL, params: params) { (message, success, json) in
            completion(message,success)
        }
    }
    
    //MARK:- Get Shopping Recipes
    func getCategoriesData(completion: @escaping (_ error: String, _ success: Bool, _ data:CategoryListViewModel?)->Void) {
        
        let completeURL = EndPoints.BASE_URL + EndPoints.getAllCategories
        self.makeGetAPICall(with: completeURL, params: nil) { (message, success, json) in
            if success {
                let categoryList = CategoryListViewModel(json![KEY_RESPONSE_DATA])
                completion(message,success, categoryList)
            }else {
                completion(message,success, nil)
            }
        }
    }
    
}
