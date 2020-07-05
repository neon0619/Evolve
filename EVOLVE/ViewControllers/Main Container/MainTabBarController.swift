//
//  MainTabBarController.swift
//  EVOLVE
//
//  Created by iOS Developer on 20/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if let navController = self.viewControllers?[selectedIndex] as? UINavigationController {
            navController.popToRootViewController(animated: false)
        }
        
//        var tabBarView: [UIView] = []
//
//        for i in tabBar.subviews {
//            if i.isKind(of: NSClassFromString("UITabBarButton")! ) {
//                tabBarView.append(i)
//            }
//        }
//
//        if !tabBarView.isEmpty {
//            UIView.animate(withDuration: 0.15, animations: {
//                tabBarView[item.tag].transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//            }, completion: { _ in
//                UIView.animate(withDuration: 0.15) {
//                    tabBarView[item.tag].transform = CGAffineTransform.identity
//                }
//            })
//        }
    }
    
}
