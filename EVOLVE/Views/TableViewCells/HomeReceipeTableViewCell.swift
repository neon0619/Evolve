//
//  HomeReceipeTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class HomeReceipeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var index:Int!
    weak var delegate:HomeRecipeDelegate?
    
    var categories: [CategoryViewModel] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var dataList = RecipeListViewModel() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataList = RecipeListViewModel()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let receipeNib = UINib(nibName: HomeReceipeCollectionViewCell.reuseIdentifier, bundle: nil)
        let categoryNib = UINib(nibName: HomeCategoryCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(receipeNib, forCellWithReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier)
        collectionView.register(categoryNib, forCellWithReuseIdentifier: HomeCategoryCollectionViewCell.reuseIdentifier)
    }

}

extension HomeReceipeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if index == 2 {
            return categories.count
        }else {
            return dataList.list.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.index == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCategoryCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCategoryCollectionViewCell
            cell.configure(with: self.categories[indexPath.item])
            
            if (indexPath.item % 2) == 0 {
                cell.gradientView.backgroundColor = AppColors.lightOverlay
            }else {
                cell.gradientView.backgroundColor = AppColors.darkOverlay
            }
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeReceipeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeReceipeCollectionViewCell
            cell.configure(with: dataList.list[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if index == 2 {
            return CGSize(width: 140, height: 140)
        }else {
            return CGSize(width: 140, height: 180)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if index == 2 {
            self.delegate?.didSelect(category: self.categories[indexPath.item])
        }else {
            self.delegate?.didSelect(recipe: dataList.list[indexPath.item])
        }
    }
    
}
