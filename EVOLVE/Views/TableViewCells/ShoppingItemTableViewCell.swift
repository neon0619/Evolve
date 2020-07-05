//
//  ShoppingItemTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class ShoppingItemTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblReceipeName: UILabel!
    @IBOutlet weak var lblTotalServing: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var isLastCell = false
    var clickHandler: (()->())?
    var recipe:RecipeViewModel!
    weak var viewController: BaseViewController?
    
    var ingredients = [IngredientViewModel]()
    var checkedIngredients = [Int]()
    var checkedSpiceIngredients = [Int]()
    var checkedGarlicIngredients = [Int]()
    
    func watchForClickHandler(completion: @escaping ()-> Void) {
        self.clickHandler = completion
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func configure(with recipe:RecipeViewModel) {
        self.recipe = recipe
        self.lblReceipeName.text = recipe.title
        self.lblTotalServing.text = "\(recipe.servingSize) servings"
        self.setImageWithUrl(imageView: self.imgImage, url: recipe.image, placeholder: AssetNames.recipePlaceHolder)
        
        self.ingredients = recipe.getIngredients()
        self.ingredients.append(contentsOf: recipe.getSpiceIngredients())
        self.ingredients.append(contentsOf: recipe.getGarlicIngredients())
        
        self.checkedIngredients = recipe.getCheckedIngredients()
        self.checkedSpiceIngredients = recipe.getCheckedSpiceIngredients()
        self.checkedGarlicIngredients = recipe.getCheckedGarlicIngredients()
        
        let nib = UINib(nibName: ShoppingIngredientTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ShoppingIngredientTableViewCell.reuseIdentifier)
        
        self.tableViewHeight.constant = CGFloat(self.ingredients.count * 60)
        self.tableView.reloadData()
    }

    @IBAction func actionDelete(_ sender: Any) {
        guard let completion = self.clickHandler else {return}
        completion()
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
    extension ShoppingItemTableViewCell {
        fileprivate func updateRecipeDetails(with params:ParamsAny) {
            viewController?.startActivity()
            GCD.async(.Main) {
                RecipeService.shared().updateRecipeIngredients(params: params) { (message, success) in
                    GCD.async(.Main) {
                        self.viewController?.stopActivity()
                        if !success {
                            self.viewController?.showAlertView(message: message)
                        }
                    }
                }
            }
        }
    }

    //MARK:- TableView delegate
    extension ShoppingItemTableViewCell: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.ingredients.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingIngredientTableViewCell.reuseIdentifier, for: indexPath) as! ShoppingIngredientTableViewCell
            let ingredient = self.ingredients[indexPath.row]
            
            if self.isLastCell {
                if indexPath.row == self.ingredients.count - 1 {
                    cell.lblBottomLine.isHidden = true
                }
            }
            
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
