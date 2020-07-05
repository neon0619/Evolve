//
//  CookingInstructionTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class CookingInstructionTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var lblStepNumber: UILabel!
    @IBOutlet weak var lblInstruction: UILabel!
    @IBOutlet weak var lblBottomLine: UILabel!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
