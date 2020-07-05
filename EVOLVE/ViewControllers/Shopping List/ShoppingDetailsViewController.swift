//
//  ShoppingDetailsViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 30/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class ShoppingDetailsViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var imgRecipeImage: UIImageView!
    @IBOutlet weak var lblRecipeName: UILabel!
    @IBOutlet weak var lblServingSize: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var recipe:RecipeViewModel!
    var ingredients = [IngredientViewModel]()
    var checkedIngredients = [Int]()
    var checkedSpiceIngredients = [Int]()
    var checkedGarlicIngredients = [Int]()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.delegate = self
            container.setBackButton()
            container.setTitle(NavigationTitles.Ingredients)
        }
        
        self.tableView.reloadData()
    }
    
    //MARK:- Custom methods
    fileprivate func setupViews() {
        self.setImageWithUrl(imageView: self.imgRecipeImage, url: self.recipe.image, placeholderImage: AssetNames.recipePlaceHolder)
        lblRecipeName.text = recipe.title
        lblServingSize.text = recipe.servingSize
        
        self.ingredients = recipe.getIngredients()
        self.ingredients.append(contentsOf: recipe.getSpiceIngredients())
        self.ingredients.append(contentsOf: recipe.getGarlicIngredients())
        
        self.checkedIngredients = recipe.getCheckedIngredients()
        self.checkedSpiceIngredients = recipe.getCheckedSpiceIngredients()
        self.checkedGarlicIngredients = recipe.getCheckedGarlicIngredients()
        
        let nib = UINib(nibName: ShoppingIngredientTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ShoppingIngredientTableViewCell.reuseIdentifier)
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateIngredientsOnServer() {
        let params:ParamsAny = [DictKeys.recipeId:self.recipe.id,
                                DictKeys.userId:Global.shared.user.id,
                                DictKeys.ingredientList:(self.checkedIngredients.map {String($0)}).joined(separator: ","),
                                DictKeys.spicesList:(self.checkedSpiceIngredients.map {String($0)}).joined(separator: ","),
                                DictKeys.garlicShallotList:(self.checkedGarlicIngredients.map {String($0)}).joined(separator: ",")]
        self.updateRecipeDetails(with: params)
    }
    
}

//MARK:- API Calls
extension ShoppingDetailsViewController {
    fileprivate func updateRecipeDetails(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Main) {
            RecipeService.shared().updateRecipeIngredients(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.showAlertView(message: message)
                }
            }
        }
    }
}

//MARK:- TableView delegate
extension ShoppingDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingIngredientTableViewCell.reuseIdentifier, for: indexPath) as! ShoppingIngredientTableViewCell
        let ingredient = self.ingredients[indexPath.row]
        cell.configure(ingredient: ingredient)
        
        if ingredient.type == .simple {
            if self.checkedIngredients.contains(ingredient.id) {
                cell.markAsOwned(isOwned: true)
            }else {
                cell.markAsOwned(isOwned: false)
            }
        }else if ingredient.type == .spicePaste {
            if self.checkedSpiceIngredients.contains(ingredient.id) {
                cell.markAsOwned(isOwned: true)
            }else {
                cell.markAsOwned(isOwned: false)
            }
        }else if ingredient.type == .garlicShallot {
            if self.checkedGarlicIngredients.contains(ingredient.id) {
                cell.markAsOwned(isOwned: true)
            }else {
                cell.markAsOwned(isOwned: false)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! ShoppingIngredientTableViewCell
        if cell.ingredient.type == .simple {
            if self.checkedIngredients.contains(cell.ingredient.id) {
                cell.markAsOwned(isOwned: false)
                self.checkedIngredients.removeAll() {$0 == cell.ingredient.id}
            }else {
                cell.markAsOwned(isOwned: true)
                self.checkedIngredients.append(cell.ingredient.id)
            }
        }else if cell.ingredient.type == .spicePaste {
            if self.checkedSpiceIngredients.contains(cell.ingredient.id) {
                cell.markAsOwned(isOwned: false)
                self.checkedSpiceIngredients.removeAll() {$0 == cell.ingredient.id}
            }else {
                cell.markAsOwned(isOwned: true)
                self.checkedSpiceIngredients.append(cell.ingredient.id)
            }
        }else if cell.ingredient.type == .garlicShallot {
            if self.checkedGarlicIngredients.contains(cell.ingredient.id) {
                cell.markAsOwned(isOwned: false)
                self.checkedGarlicIngredients.removeAll() {$0 == cell.ingredient.id}
            }else {
                cell.markAsOwned(isOwned: true)
                self.checkedGarlicIngredients.append(cell.ingredient.id)
            }
        }
        self.updateIngredientsOnServer()
    }
}
