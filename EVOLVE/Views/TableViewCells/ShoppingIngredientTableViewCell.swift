//
//  ShoppingIngredientTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class ShoppingIngredientTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imgCheckUncheck: UIImageView!
    @IBOutlet weak var lblIngredient: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblCuttingLine: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    var ingredient:IngredientViewModel!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblIngredient.attributedText = nil
        self.imgCheckUncheck.image = UIImage(named: AssetNames.iconUnchecked)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(ingredient:IngredientViewModel) {
        self.ingredient = ingredient
        self.lblIngredient.text = ingredient.getIngredientName()
        self.lblQuantity.text = ingredient.getIngredientQuantity()
    }
    
    func markAsOwned(isOwned: Bool) {
        if isOwned {
            self.lblCuttingLine.isHidden = false
            self.lblQuantity.textColor = AppColors.selectedText
            self.lblIngredient.textColor = AppColors.selectedText
            self.imgCheckUncheck.image = UIImage(named: AssetNames.iconChecked)
        }else {
            self.lblCuttingLine.isHidden = true
            self.lblQuantity.textColor = AppColors.textColor
            self.lblIngredient.textColor = AppColors.textColor
            self.imgCheckUncheck.image = UIImage(named: AssetNames.iconUnchecked)
        }
//        let name = NSMutableAttributedString(string: self.ingredient.getIngredientName())
//        let quantity = NSMutableAttributedString(string: self.ingredient.getIngredientQuantity())
//
//        if isOwned {
//            self.imgCheckUncheck.image = UIImage(named: AssetNames.iconChecked)
//            self.lblIngredient.textColor = AppColors.selectedText
//            self.lblQuantity.textColor = AppColors.selectedText
//            name.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, name.length))
//            quantity.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, quantity.length))
//            self.lblIngredient.attributedText = name
//            self.lblQuantity.attributedText = quantity
//        }else {
//            self.lblIngredient.attributedText = name
//            self.lblQuantity.attributedText = quantity
//            self.lblIngredient.textColor = AppColors.textColor
//            self.lblQuantity.textColor = AppColors.textColor
//            self.imgCheckUncheck.image = UIImage(named: AssetNames.iconUnchecked)
//        }
    }
    
}
