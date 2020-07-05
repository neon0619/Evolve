//
//  HomeBannerCollectionViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class HomeBannerCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblBakingTime: UILabel!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblDishDescription: UILabel!
    
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with banner:RecipeViewModel) {
        self.setImageWithUrl(imageView: self.imgImage, url: banner.image, placeholder: AssetNames.recipePlaceHolder)
        lblBakingTime.text = "\(banner.preperationTime)m"
        lblDishName.text = banner.title
        lblDishDescription.text = banner.description
    }
    
}
