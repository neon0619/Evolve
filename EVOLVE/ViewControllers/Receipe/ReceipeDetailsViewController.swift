//
//  ReceipeDetailsViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class ReceipeDetailsViewController: BaseViewController {
    
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblPrepTime: UILabel!
    @IBOutlet weak var lblCookingTime: UILabel!
    @IBOutlet weak var lblServingSize: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var lblNoteDetails: UILabel!
    @IBOutlet weak var imgReceipeImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    //MARK:- Variables
    var recipeId: Int!
    var recipe: RecipeViewModel!
    var ingredients = [IngredientViewModel]()
    var spiceIngredients = [IngredientViewModel]()
    var shallotGarlicIngredients = [IngredientViewModel]()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if let id = self.recipeId {
            let params:ParamsAny  = [DictKeys.recipeId:id,
                                     DictKeys.userId:Global.shared.user.id]
            self.getRecipeDetails(with: params)
        }else if self.recipe != nil {
            self.loadRecipeDetails(self.recipe)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.topBarView.isHidden = true
        }
    }
    
    //MARK:- Custom methods
    fileprivate func loadRecipeDetails(_ recipe: RecipeViewModel) {
        self.recipe = recipe
        self.lblNote.text = "Note: \(recipe.note)"
        self.lblDishName.text = recipe.title
        self.lblPrepTime.text = "\(recipe.preperationTime) mins"
        self.lblCookingTime.text = recipe.cookingTime
        self.lblServingSize.text = recipe.servingSize
        self.lblNoteDetails.text = recipe.description
        self.setImageWithUrl(imageView: self.imgReceipeImage, url: recipe.image, placeholderImage: AssetNames.recipePlaceHolder)
        
        self.ingredients = recipe.getIngredients()
        self.spiceIngredients = recipe.getSpiceIngredients()
        self.shallotGarlicIngredients = recipe.getGarlicIngredients()
        
        self.calculateTableHeight()
    }
    
    fileprivate func calculateTableHeight() {
        var height:CGFloat = 0
        
        if ingredients.count > 0 {
            height += 60
            
            for ingredient in ingredients {
                let _height = ingredient.getIngredientName().estimatedHeight(width: (tableView.bounds.size.width - 60), font: AppFonts.ProximaNovaReguler(ofSize: 15))
                height += (_height + 40)
            }
            
//            height += CGFloat(60 * ingredients.count)
        }
        
        if spiceIngredients.count > 0 {
            height += 60
            
            for ingredient in spiceIngredients {
                let _height = ingredient.getIngredientName().estimatedHeight(width: (tableView.bounds.size.width - 60), font: AppFonts.ProximaNovaReguler(ofSize: 15))
                height += (_height + 40)
            }
        }
        
        if shallotGarlicIngredients.count > 0 {
            height += 60
            
            for ingredient in shallotGarlicIngredients {
                let _height = ingredient.getIngredientName().estimatedHeight(width: (tableView.bounds.size.width - 60), font: AppFonts.ProximaNovaReguler(ofSize: 15))
                height += (_height + 40)
            }
        }
        
        self.tableViewHeight.constant = height
        self.view.layoutIfNeeded()
        self.tableView.reloadData()
    }
    
    
    //MARK:- Action methods
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionViewCookingHelp(_ sender: Any) {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.CookingInstructionViewController) as! CookingInstructionViewController
        controller.instructions = self.recipe.getInstructions()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func actionMarkFavourite(_ sender: Any) {
        let params:ParamsAny = [DictKeys.recipeId: self.recipe.id,
                                DictKeys.userId: Global.shared.user.id,
                                DictKeys.status:LocalStrings.favorite]
        self.favouriteRecipe(with: params)
    }
    
    @IBAction func actionAddToShoppingList(_ sender: Any) {
        let params:ParamsAny = [DictKeys.recipeId: self.recipe.id,
                                DictKeys.userId: Global.shared.user.id,
                                DictKeys.status:LocalStrings.add]
        self.addRecipeToShopping(with: params)
    }
    
}

//MARK:- API Calls
extension ReceipeDetailsViewController {
    fileprivate func getRecipeDetails(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().getRecipeDetails(params: params) { (message, success, recipe) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.loadRecipeDetails(recipe!)
                    }else {
                        self.showAlertView(message: message, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    fileprivate func favouriteRecipe(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().markFavouriteRecipe(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.showAlertView(message: message)
                }
            }
        }
    }
    
    fileprivate func addRecipeToShopping(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().addToShoppingRecipe(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.showAlertView(message: message)
                }
            }
        }
    }
    
}

//MARK:- TableView Delegate
extension ReceipeDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return ingredients.count
        }else if section == 1 {
            return spiceIngredients.count
        }else{
            return shallotGarlicIngredients.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableCell(withIdentifier: IngredientHeaderTableViewCell.reuseIdentifier) as! IngredientHeaderTableViewCell
        if section == 0 {
            header.btnCart.isHidden = false
            header.lblTitle.text = "Ingredients"
            header.watchForClickHandler {
                let params:ParamsAny = [DictKeys.recipeId: self.recipe.id,
                                        DictKeys.userId: Global.shared.user.id,
                                        DictKeys.status:LocalStrings.add]
                self.addRecipeToShopping(with: params)
            }
        }else if section == 1 {
            header.lblTitle.text = "Spice Paste Ingredients"
        }else {
            header.lblTitle.text = "Fried Shallots or Garlic Ingredients"
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.reuseIdentifier, for: indexPath) as! IngredientTableViewCell
        if indexPath.section == 0 {
            let ingredient = ingredients[indexPath.row]
            cell.lblTitle.text = "\(ingredient.getIngredientQuantity()) \(ingredient.getIngredientName().lowercased())"
        }else if indexPath.section == 1 {
            let ingredient = spiceIngredients[indexPath.row]
            cell.lblTitle.text = "\(ingredient.getIngredientQuantity()) \(ingredient.getIngredientName().lowercased())"
        }else if indexPath.section == 2 {
            let ingredient = shallotGarlicIngredients[indexPath.row]
            cell.lblTitle.text = "\(ingredient.getIngredientQuantity()) \(ingredient.getIngredientName().lowercased())"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && ingredients.count == 0 {
            return 0
        }else if section == 1 && spiceIngredients.count == 0 {
            return 0
        }else if section == 2 && shallotGarlicIngredients.count == 0 {
            return 0
        }else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}
