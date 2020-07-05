//
//  HomeReceipeCollectionViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class HomeReceipeCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var imgGradientBackground: UIImageView!
    @IBOutlet weak var LblDishName: UILabel!
    @IBOutlet weak var lblBakingTime: UILabel!
    @IBOutlet weak var btnDelete: UIButton!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    var clickHandler: (()->())?
    
    func watchForClickHandler(completion: @escaping ()-> Void) {
        self.clickHandler = completion
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !isHidden else { return nil }
        guard alpha >= 0.01 else { return nil }
        guard isUserInteractionEnabled else { return nil }
        guard self.point(inside: point, with: event) else { return nil }

        if self.btnDelete.point(inside: convert(point, to: self.btnDelete), with: event) {
            return self.btnDelete
        }

        return super.hitTest(point, with: event)
    }
    
    func configure(with data:RecipeViewModel, hideGradient:Bool = true) {
        imgGradientBackground.isHidden = hideGradient
        setImageWithUrl(imageView: self.imgImage, url: data.image, placeholder: AssetNames.recipePlaceHolder)
        LblDishName.text = data.title
        lblBakingTime.text = "\(data.preperationTime)m"
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        guard let completion = self.clickHandler else {return}
        completion()
    }
    
    
}
