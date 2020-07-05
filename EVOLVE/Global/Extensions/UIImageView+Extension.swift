//
//  UIImageView+Extension.swift
//  EVOLVE
//
//  Created by iOS Developer on 09/04/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import Foundation

extension UIImageView {
    private func getInitials(text:String) -> String {
        
        let names = text.trim().components(separatedBy: " ")
            
        if names.count > 1 {
            
            let firstName = names[0]
            let lastName = names[names.count - 1]
            
            let firstNameInitial = firstName.first!
            let lastNameInitial = lastName.first!
            
            return "\(firstNameInitial)\(lastNameInitial)"
            
        } else {
            
            if text == kBlankString {
                return kBlankString
            }
            
            let firstName = text
            let firstNameInitial = firstName.first!
            return "\(firstNameInitial)"
        }
        
    }
    
    func image(with name:String) -> UIImage? {
        let initails = getInitials(text: name)
        let lblNameInitials = UILabel()
        lblNameInitials.frame.size = self.bounds.size
        lblNameInitials.textColor = UIColor.white
        lblNameInitials.text = initails
        lblNameInitials.font = UIFont.boldSystemFont(ofSize: 25)
        lblNameInitials.textAlignment = NSTextAlignment.center
        lblNameInitials.backgroundColor = AppColors.imageBackColor
        lblNameInitials.layer.cornerRadius = 50.0

        UIGraphicsBeginImageContext(lblNameInitials.frame.size)
        lblNameInitials.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
