//
//  SettingUserTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class SettingUserTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure() {
        if let user = Global.shared.user {
            lblName.text = user.name
            lblEmail.text = user.email
            self.imgProfile.sd_setImage(with: URL(string: user.avatar), placeholderImage: self.imgProfile.image(with: user.name))
        }
    }
    
}
