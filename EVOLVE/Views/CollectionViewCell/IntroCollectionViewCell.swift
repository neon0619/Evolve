//
//  IntroDotsCollectionViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 13/05/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class IntroCollectionViewCell: BaseCollectionViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var lblSecondLabel: UILabel!
    @IBOutlet weak var imgSecondImage: UIImageView!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
}
