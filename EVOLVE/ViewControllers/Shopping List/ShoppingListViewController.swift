//
//  ShoppingListViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class ShoppingListViewController: BaseViewController, TopBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var recipes = RecipeListViewModel()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTablView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.setBackButton()
            container.delegate = self
            container.setTitle(NavigationTitles.ShoppingList)
        }
        self.getShoppingList()
    }
    
    override func handleRefreshController(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.getShoppingList()
    }
    
    //MARK:- Custom methods
    fileprivate func setupTablView() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        }else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        self.tableView.backgroundView = UIView()
        let nib = UINib(nibName: ShoppingItemTableViewCell.reuseIdentifier, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: ShoppingItemTableViewCell.reuseIdentifier)
    }
    
    fileprivate func refreshCollectionView(_ list:RecipeListViewModel) {
        self.recipes = list
        
        if list.list.count > 0 {
            self.tableView.removeBackground()
        }else{
            self.tableView.setNoDataMessage()
        }
        self.tableView.reloadData()
    }

    func actionBack() {
        self.tabBarController?.selectedIndex = 0
    }
    
}

//MARK:- API Calls
extension ShoppingListViewController {
    fileprivate func getShoppingList() {
        let params:ParamsAny = [DictKeys.userId:Global.shared.user.id]
        
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().getShoppingRecipes(params: params) { (message, success, recipes) in
                self.stopActivity()
                if success {
                    self.refreshCollectionView(recipes!)
                }else {
                    self.recipes = RecipeListViewModel()
                    self.tableView.reloadData()
                    self.tableView.setNoDataMessage(message)
                }
            }
        }
    }
    
    fileprivate func removeRecipe(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().addToShoppingRecipe(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.showAlertView(message: message, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                            self.getShoppingList()
                        }
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
}

//MARK:- TableView Delegate
extension ShoppingListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipes.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ShoppingItemTableViewCell.reuseIdentifier, for: indexPath) as! ShoppingItemTableViewCell
        cell.viewController = self
        cell.configure(with: self.recipes.list[indexPath.row])
        
        cell.watchForClickHandler {
            self.showAlertView(message: PopupMessages.sureToRemoveFromShopping, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.Yes, doneButtonCompletion: { (_) in
                let params:ParamsAny = [DictKeys.recipeId: self.recipes.list[indexPath.item].id,
                                        DictKeys.userId: Global.shared.user.id,
                                        DictKeys.status:LocalStrings.remove]
                self.removeRecipe(with: params)
            }, cancelButtonTitle: LocalStrings.Cancel, cancelButtonCompletion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.ShoppingDetailsViewController) as! ShoppingDetailsViewController
//        controller.recipe = recipes.list[indexPath.row]
//        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
