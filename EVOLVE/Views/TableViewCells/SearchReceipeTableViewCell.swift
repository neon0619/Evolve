//
//  SearchReceipeTableViewCell.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import TagListView

class SearchReceipeTableViewCell: BaseTableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    class var reuseIdentifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.textFont = AppFonts.ProximaNovaReguler(ofSize: 15)
    }
    
}
