//
//  Protocols.swift
//  UgoCab
//
//  Created by iOS Developer on 29/10/2019.
//  Copyright © 2019 Rapidzz. All rights reserved.
//

import Foundation

//MARK:- TopBarDelegate
protocol TopBarDelegate: class {
    func actionBack()
    func rightButtonAction()
}

extension TopBarDelegate {
    func rightButtonAction() {}
}

