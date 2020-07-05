//
//  SubscriptionViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 24/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class SubscriptionViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    
    //MARK:- Variables
    var isFirstScreen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.mainContainer?.topBarView.isHidden = true
        
        if !isFirstScreen {
            self.lblTitle.isHidden = false
            self.btnBack.isHidden = false
            self.btnClose.isHidden = true
            self.lblTitle.text = NavigationTitles.Subscription
        }else {
            self.lblTitle.isHidden = true
            self.btnBack.isHidden = true
            self.btnClose.isHidden = false
        }
    }
    
    //MARK:- Action methods
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        let storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.MainContainerViewController) as! MainContainerViewController
        self.navigationController?.setViewControllers([controller], animated: true)
    }
    
    @IBAction func actionMonthlySubscription(_ sender: Any) {
    }
    
    @IBAction func actionaYearlySubscription(_ sender: Any) {
    }
    
    
}
