//
//  HomeDataViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 25/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class HomeDataViewModel {
    
    var recentList = RecipeListViewModel()
    var bannerList = RecipeListViewModel()
    var populerList = RecipeListViewModel()
    var categoriesList = [CategoryViewModel]()
    
    init() {
    }
    
    init(_ json:JSON) {
        recentList = RecipeListViewModel(json["Recent"])
        bannerList = RecipeListViewModel(json["banner"])
        populerList = RecipeListViewModel(json["popular"])
        categoriesList = (json["top_categories"].arrayValue).map {CategoryViewModel($0)}
    }
    
}
