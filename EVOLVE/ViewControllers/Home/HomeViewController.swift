//
//  HomeViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

protocol HomeRecipeDelegate: class {
    func didSelect(recipe:RecipeViewModel)
    func didSelect(category:CategoryViewModel)
}

class HomeViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstriant: NSLayoutConstraint!
    
    //MARK:- Variables
    var homeData = HomeDataViewModel()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.topBarView.isHidden = true
        }
        self.getHomeData()
        constraintChecker()
    }
    
    override func handleRefreshController(_ refreshControl: UIRefreshControl) {
        refreshControl.endRefreshing()
        self.getHomeData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.mainContainer?.topBarView.isHidden = true
    }

    fileprivate func constraintChecker() {

        let SCREEN_MAX_LENGTH = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        let iPhone_X_XS       = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 812.0
        let iPhone_XR_XsMax   = UIDevice.current.userInterfaceIdiom == .phone && SCREEN_MAX_LENGTH == 896.0

        if iPhone_X_XS || iPhone_XR_XsMax {
            topConstriant.constant = 44
        }
    }
    
    //MARK:- Custom methods
    fileprivate func setupTableView() {
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        }else {
            self.tableView.addSubview(self.refreshControl)
        }
    }
    
    fileprivate func navigateToSearch() {
        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SearchReceipeViewController) as! SearchReceipeViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func refreshTableData(_ data:HomeDataViewModel) {
        self.homeData = data
        if data.bannerList.list.count == 0 && data.recentList.list.count == 0 && data.populerList.list.count == 0 && data.categoriesList.count == 0 {
            self.tableView.setNoDataMessage()
        }else {
            self.tableView.removeBackground()
        }
        tableView.reloadData()
    }

}

//MARK:- Textfield delegate
extension HomeViewController: UITextFieldDelegate, HomeRecipeDelegate {
    func didSelect(category: CategoryViewModel) {
        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SearchResultsViewController) as! SearchResultsViewController
        controller.searchText = category.name
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didSelect(recipe: RecipeViewModel) {
        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.ReceipeDetailsViewController) as! ReceipeDetailsViewController
        controller.recipeId = recipe.id
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.navigateToSearch()
        return false
    }
}

//MARK:- API Calls
extension HomeViewController {
    fileprivate func getHomeData() {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().getHomeDataListing { (message, success, homeData) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.refreshTableData(homeData!)
                    }else {
                        self.tableView.setNoDataMessage(message)
                    }
                }
            }
        }
    }
}

//MARK:- TableView Delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeBannerTableViewCell.reuseIdentifier, for: indexPath) as! HomeBannerTableViewCell
            cell.bannerList = homeData.bannerList.list
            cell.delegate = self
            cell.index = indexPath.row
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeReceipeTableViewCell.reuseIdentifier, for: indexPath) as! HomeReceipeTableViewCell
            cell.delegate = self
            cell.index = indexPath.row
            
            if indexPath.row == 1 {
                cell.lblTitle.text = "Popular"
                cell.dataList = homeData.populerList
            }else if indexPath.row == 2 {
                cell.lblTitle.text = "Top Categories"
                cell.categories = homeData.categoriesList
            }else  {
                cell.lblTitle.text = "Recent"
                cell.dataList = homeData.recentList
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 360
        }else if indexPath.row == 2 {
            return 200
        }else {
            return 235
        }
    }
}
