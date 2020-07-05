//
//  HomeBannerTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class HomeBannerTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var index:Int!
    var bannerList = [RecipeViewModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    weak var delegate: HomeRecipeDelegate?
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let bannerNib = UINib(nibName: HomeBannerCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(bannerNib, forCellWithReuseIdentifier: HomeBannerCollectionViewCell.reuseIdentifier)
        
        let itemSize = UIScreen.main.bounds.width - 40
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)

        layout.minimumInteritemSpacing = 3
        layout.minimumLineSpacing = 3
        layout.scrollDirection = .horizontal

        collectionView.collectionViewLayout = layout
    }

}

extension HomeBannerTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.bannerList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeBannerCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeBannerCollectionViewCell
        cell.configure(with: bannerList[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.delegate?.didSelect(recipe: self.bannerList[indexPath.item])
    }
    
}
