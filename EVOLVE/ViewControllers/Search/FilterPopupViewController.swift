//
//  FilterPopupViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 22/05/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import TagListView

protocol FilterViewDelegate:class {
    func didSelectFilter(meal:String, diet:String, time:String, recent:String)
}

class FilterPopupViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: FilterViewDelegate?
    var dataList = CategoryListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: SearchReceipeTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SearchReceipeTableViewCell.reuseIdentifier)
    }
    
    fileprivate func removeFilterView() {
        UIView.transition(with: self.view, duration: 0.4, options: .beginFromCurrentState, animations: {
            self.view.frame.origin.y = self.view.frame.height
        }) { (completed) in
            self.view.removeFromSuperview()
        }
    }
    
    //MARK:- Action methods
    @IBAction func actionDone(_ sender: Any) {
        self.removeFilterView()
    }
    
}

//MARK:- TagListView delegate
extension FilterPopupViewController: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if sender.tag == 1 {
            delegate?.didSelectFilter(meal: kBlankString, diet: kBlankString, time: kBlankString, recent: title)
        }else if sender.tag == 2 {
            delegate?.didSelectFilter(meal: title, diet: kBlankString, time: kBlankString, recent: kBlankString)
        }else if sender.tag == 3 {
            delegate?.didSelectFilter(meal: kBlankString, diet: title, time: kBlankString, recent: kBlankString)
        }else if sender.tag == 4 {
            delegate?.didSelectFilter(meal: kBlankString, diet: kBlankString, time: title, recent: kBlankString)
        }
        
        self.removeFilterView()
    }
}

//MARK:- TableView delegate
extension FilterPopupViewController: UITableViewDelegate, UITableViewDataSource {
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
