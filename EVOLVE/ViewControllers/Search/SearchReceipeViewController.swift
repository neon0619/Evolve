//
//  SearchReceipeViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import TagListView

class SearchReceipeViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- variables
    var time = kBlankString
    var diet = kBlankString
    var meal = kBlankString
    
    var dataList = CategoryListViewModel()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: SearchReceipeTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchReceipeTableViewCell.reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.delegate = self
            container.setBackButton()
            container.setRightButton(title: "Refine")
            container.setTitle("")
        }
        self.time = kBlankString
        self.diet = kBlankString
        self.meal = kBlankString
        self.txtSearch.text = kBlankString
        
        self.getAllCategories()
    }
    
    //MARK:- Custom methods
    fileprivate func navigateToResults() {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.SearchResultsViewController) as! SearchResultsViewController
        controller.meal = self.meal
        controller.diet = self.diet
        controller.time = self.time
        controller.dataList = self.dataList
        controller.searchText = self.txtSearch.text!
        
        self.txtSearch.text?.removeAll()
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightButtonAction() {
        self.view.endEditing(true)
        self.navigateToResults()
    }
    
    fileprivate func refreshData(_ data:CategoryListViewModel) {
        self.dataList = data
        self.tableView.reloadData()
    }
    
}

extension SearchReceipeViewController {
    fileprivate func getAllCategories() {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().getCategoriesData { (message, success, dataList) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.refreshData(dataList!)
                    }else {
                        self.tableView.setNoDataMessage(message)
                    }
                }
            }
        }
    }
}

//MARK:- Textfield delegate
extension SearchReceipeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.meal != kBlankString || self.diet != kBlankString || self.time != kBlankString {
            self.meal = kBlankString
            self.diet = kBlankString
            self.time = kBlankString
            self.txtSearch.text = kBlankString
        }
        
        return true
    }
}

//MARK:- TagListView delegate
extension SearchReceipeViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.tagViews.forEach {
            if $0 == tagView {
                $0.isSelected = !$0.isSelected
                
                if sender.tag == 1 {
                    self.txtSearch.text = $0.isSelected ? title : kBlankString
                }else if sender.tag == 2 {
                    self.meal = $0.isSelected ? title : kBlankString
                }else if sender.tag == 3 {
                    self.diet = $0.isSelected ? title : kBlankString
                }else {
                    self.time = $0.isSelected ? title : kBlankString
                }
                
            }else {
                $0.isSelected = false
            }
        }
    }
}

//MARK:- TableView delegate
extension SearchReceipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchReceipeTableViewCell.reuseIdentifier, for: indexPath) as! SearchReceipeTableViewCell
        cell.tagListView.delegate = self
        cell.tagListView.tag = indexPath.row + 1
        
        if indexPath.row == 0 {
            if self.dataList.recents.count > 0 {
                cell.lblTitle.text = "Recent"
                cell.tagListView.removeAllTags()
                cell.tagListView.addTags(self.dataList.recents.map({$0.name}))
            }
        }else if indexPath.row == 1 {
            if self.dataList.meals.count > 0 {
                cell.lblTitle.text = "Meal"
                cell.tagListView.removeAllTags()
                cell.tagListView.addTags(self.dataList.meals.map({$0.name}))
            }
        }else if indexPath.row == 2 {
            if self.dataList.diets.count > 0 {
                cell.lblTitle.text = "Diet"
                cell.tagListView.removeAllTags()
                cell.tagListView.addTags(self.dataList.diets.map({$0.name}))
            }
        }else if indexPath.row == 3 {
            if self.dataList.times.count > 0 {
                cell.lblTitle.text = "Time"
                cell.tagListView.removeAllTags()
                cell.tagListView.addTags(self.dataList.times.map({$0.name}))
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
