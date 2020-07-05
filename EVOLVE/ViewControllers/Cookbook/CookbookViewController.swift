//
//  CookbookViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class CookbookViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Variables
    var recipes = RecipeListViewModel()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.setBackButton()
            container.delegate = self
            container.setTitle(NavigationTitles.MyCookbook)
        }
        self.getRecipeList()
    }
    
    override func handleRefreshController(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.getRecipeList()
    }
    
    //MARK:- Custom methods
    fileprivate func setupCollectionView() {
        if #available(iOS 10.0, *) {
            self.collectionView.refreshControl = self.refreshControl
        }else {
            self.collectionView.addSubview(self.refreshControl)
        }
        
        let nib = UINib(nibName: HomeReceipeCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier)
    }
    
    fileprivate func refreshCollectionView(_ list:RecipeListViewModel) {
        self.recipes = list
        
        if list.list.count > 0 {
            self.collectionView.removeBackground()
        }else{
            self.collectionView.setNoDataMessage()
        }
        self.collectionView.reloadData()
    }
    
    func actionBack() {
        self.tabBarController?.selectedIndex = 0
    }
    
}

//MARK:- API Calls
extension CookbookViewController {
    fileprivate func getRecipeList() {
        let params:ParamsAny = [DictKeys.userId:Global.shared.user.id]
        self.startActivity()
        
        GCD.async(.Background) {
            RecipeService.shared().getFavouriteRecipes(params: params) { (message, success, recipes) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.refreshCollectionView(recipes!)
                    }else {
                        self.recipes = RecipeListViewModel()
                        self.collectionView.reloadData()
                        self.collectionView.setNoDataMessage(message)
                    }
                }
            }
        }
    }
    
    fileprivate func unfavouriteRecipe(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().markFavouriteRecipe(params: params) { (message, success) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.showAlertView(message: message, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.ok) { (_) in
                            self.getRecipeList()
                        }
                    }else {
                        self.showAlertView(message: message)
                    }
                }
            }
        }
    }
    
}

//MARK:- CollectionView Delegate
extension CookbookViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeReceipeCollectionViewCell
        cell.btnDelete.isHidden = false
        cell.configure(with: self.recipes.list[indexPath.item], hideGradient: false)
        cell.watchForClickHandler {
            self.showAlertView(message: PopupMessages.sureToMarkUnfavorite, title: ALERT_TITLE_APP_NAME, doneButtonTitle: LocalStrings.Yes, doneButtonCompletion: { (_) in
                let params:ParamsAny = [DictKeys.recipeId: self.recipes.list[indexPath.item].id,
                                        DictKeys.userId: Global.shared.user.id,
                                        DictKeys.status:LocalStrings.unfavorite]
                self.unfavouriteRecipe(with: params)
            }, cancelButtonTitle: LocalStrings.Cancel, cancelButtonCompletion: nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.size.width - 20) / 2
        return CGSize(width: width, height: width + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.ReceipeDetailsViewController) as! ReceipeDetailsViewController
        controller.recipe = self.recipes.list[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
