//
//  RecipeListViewModel.swift
//  EVOLVE
//
//  Created by iOS Developer on 25/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation
import SwiftyJSON

class RecipeListViewModel {
    var list: [RecipeViewModel]
    
    init() {
        list = []
    }
    
    init(_ json:JSON) {
        list = json.arrayValue.map({RecipeViewModel($0)})
    }
}
