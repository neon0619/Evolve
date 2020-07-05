//
//  IngredientHeaderTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class IngredientHeaderTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    
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
    
    @IBAction func actionCart(_ sender: Any) {
        guard let completion = self.clickHandler else {return}
        completion()
    }
    
    
}
