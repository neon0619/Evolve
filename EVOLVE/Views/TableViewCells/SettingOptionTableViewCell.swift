//
//  SettingOptionTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class SettingOptionTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblOption: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with object:[String:String]) {
        lblOption.text = object["title"]
        imgImage.image = UIImage(named: object["image"]!)
    }

}
