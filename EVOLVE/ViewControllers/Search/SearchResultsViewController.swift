//
//  SearchResultsViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import TagListView

class SearchResultsViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var tagList: TagListView!
    @IBOutlet weak var btnChangeView: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnChangeBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var tagListTopMargin: NSLayoutConstraint!
    
    //MARK:- Variables
    var isSingleView = false
    var time = kBlankString
    var diet = kBlankString
    var meal = kBlankString
    var searchText = kBlankString
    
    var recipes = RecipeListViewModel()
    var dataList = CategoryListViewModel()
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSearchParams()
        self.setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.delegate = self
//            container.setBackButton()
//            container.setTitle(NavigationTitles.Results)
            container.setTitle("")

        }
    }
    
    //MARK:- Custom methods
    fileprivate func setupCollectionView() {
        self.tagList.textFont = AppFonts.ProximaNovaReguler(ofSize: 15)
        
        let bannerNib = UINib(nibName: HomeBannerCollectionViewCell.reuseIdentifier, bundle: nil)
        let receipeNib = UINib(nibName: HomeReceipeCollectionViewCell.reuseIdentifier, bundle: nil)
        
        collectionView.register(bannerNib, forCellWithReuseIdentifier: HomeBannerCollectionViewCell.reuseIdentifier)
        collectionView.register(receipeNib, forCellWithReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier)
        
        self.callSearchApi()
    }
    
    fileprivate func setSearchParams() {
        txtSearch.text = searchText
        
        if meal != kBlankString {
            tagList.addTag(meal)
        }
        
        if diet != kBlankString {
            tagList.addTag(diet)
        }
        
        if time != kBlankString {
            tagList.addTag(time)
        }
        
        if time == kBlankString && diet == kBlankString && meal == kBlankString {
            tagListTopMargin.constant = 0
            btnChangeBottomMargin.constant = 0
        }else {
            tagListTopMargin.constant = 10
            btnChangeBottomMargin.constant = 10
        }
        
    }
    
    fileprivate func refreshCollectionView(_ list:RecipeListViewModel) {
        self.recipes = list
        if list.list.count > 0 {
            self.collectionView.removeBackground()
        }else{
            self.collectionView.setNoDataMessage()
        }
        self.removeSwitchViewIcon()
        self.collectionView.reloadData()
    }
    
    fileprivate func callSearchApi() {
        let params:ParamsAny = [DictKeys.meal: self.meal,
                                DictKeys.diet: self.diet,
                                DictKeys.time: self.time,
                                DictKeys.searchText:self.searchText]
        self.searchRecipes(with: params)
    }
    
    fileprivate func removeSwitchViewIcon() {
        self.btnChangeView.isHidden = self.recipes.list.count == 0
    }
    
    func actionBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func addFilterView() {
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.FilterPopupViewController) as! FilterPopupViewController
        
        controller.delegate = self
        controller.dataList = self.dataList
        
        self.addChild(controller)
        self.view.addSubview(controller.view)
        controller.view.frame.origin.y = self.view.bounds.height
        
        UIView.transition(with: controller.view, duration: 0.4, options: .curveEaseIn, animations: {
            controller.view.frame = self.view.frame
            controller.view.frame.origin.y = 0
        }) { (completed) in
            controller.didMove(toParent: self)
        }
        
    }
    
    //MARK:- Action methods
    @IBAction func actionChangeCollectionView(_ sender: Any) {
        self.isSingleView = !self.isSingleView
        let imageName = !self.isSingleView ? AssetNames.listView : AssetNames.gridView
        self.btnChangeView.setImage(UIImage(named: imageName), for: .normal)
        UIView.transition(with: self.btnChangeView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.btnChangeView.setImage(UIImage(named: imageName), for: .normal)
        }, completion: nil)
//        UIView.transition(with: self.collectionView, duration: 0.6, options: .transitionFlipFromRight, animations: {
//            self.collectionView.reloadData()
//        }, completion: nil)
        self.collectionView.reloadData()
    }
    
}

extension SearchResultsViewController: TagListViewDelegate, UITextFieldDelegate, FilterViewDelegate {
    func didSelectFilter(meal:String, diet:String, time:String, recent:String) {
        if recent != kBlankString {
            self.searchText = recent
            self.txtSearch.text = recent
        }else {
            tagListTopMargin.constant = 10
            btnChangeBottomMargin.constant = 10
            tagList.removeAllTags()
            
            if self.meal != kBlankString {
                if meal != kBlankString {
                    self.meal = meal
                    self.tagList.addTag(meal)
                }else {
                    self.tagList.addTag(self.meal)
                }
            }else {
                if meal != kBlankString {
                    self.meal = meal
                    self.tagList.addTag(meal)
                }
            }
            
            if self.diet != kBlankString {
                if diet != kBlankString {
                    self.diet = diet
                    self.tagList.addTag(diet)
                }else {
                    self.tagList.addTag(self.diet)
                }
            }else {
                if diet != kBlankString {
                    self.diet = diet
                    self.tagList.addTag(diet)
                }
            }
            
            if self.time != kBlankString {
                if time != kBlankString {
                    self.time = time
                    self.tagList.addTag(time)
                }else {
                    self.tagList.addTag(self.time)
                }
            }else {
                if time != kBlankString {
                    self.time = time
                    self.tagList.addTag(time)
                }
            }
            
        }
        self.callSearchApi()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.addFilterView()
        return false
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        sender.removeTag(title)
        if title == self.meal {
            self.meal = kBlankString
        }else if title == self.diet {
            self.diet = kBlankString
        }else if title == self.time {
            self.time = kBlankString
        }
        
        self.callSearchApi()
    }
}

//MARK:- API Calls
extension SearchResultsViewController {
    fileprivate func searchRecipes(with params:ParamsAny) {
        self.startActivity()
        GCD.async(.Background) {
            RecipeService.shared().searchRecipes(params: params) { (message, success, recipes) in
                GCD.async(.Main) {
                    self.stopActivity()
                    if success {
                        self.refreshCollectionView(recipes!)
                    }else {
                        self.recipes = RecipeListViewModel()
                        self.collectionView.reloadData()
                        self.removeSwitchViewIcon()
                        self.collectionView.setNoDataMessage(message)
                    }
                }
            }
        }
    }
}

//MARK:- CollectionView Delegate
extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recipes.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.isSingleView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeBannerCollectionViewCell
            cell.configure(with: self.recipes.list[indexPath.item])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeReceipeCollectionViewCell
            cell.configure(with: self.recipes.list[indexPath.item], hideGradient: false)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.isSingleView {
            let width = UIScreen.main.bounds.size.width - 40
            return CGSize(width: width, height: 340)
        }else {
            return CGSize(width: 160, height: 200)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: StoryboardNames.ReceipeDetails, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.ReceipeDetailsViewController) as! ReceipeDetailsViewController
        controller.recipe = self.recipes.list[indexPath.item]
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
