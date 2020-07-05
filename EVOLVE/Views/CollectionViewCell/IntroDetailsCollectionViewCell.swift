//
//  IntroDetailsCollectionViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 13/05/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class IntroDetailsCollectionViewCell: BaseCollectionViewCell {
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var clickHandler: (()->())?
    
    func watchForClickHandler(completion: @escaping ()-> Void) {
        self.clickHandler = completion
    }
    
    @IBAction func actionGetCooking(_ sender: Any) {
        guard let completion = self.clickHandler else  {return}
        completion()
    }
    
    
}
