//
//  HomeCategoryCollectionViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 10/04/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class HomeCategoryCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var lblCategoryName: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var imgCategoryImage: UIImageView!
    
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientView.backgroundColor = .clear
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with data:CategoryViewModel) {
        self.lblCategoryName.text = data.name
        self.setImageWithUrl(imageView: self.imgCategoryImage, url: data.image, placeholder: AssetNames.recipePlaceHolder)
    }
    
}
