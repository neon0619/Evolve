//
//  MainContainerViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 20/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class MainContainerViewController: BaseViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var btnBackHeight: NSLayoutConstraint!
    
    weak var delegate:TopBarDelegate?
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
        showHomeController()

    }
    
    //MARK:- Custom methods
    func setBackButton(shouldHide: Bool = false) {
        btnBack.isHidden = shouldHide
    }
    
    func setTitle(_ title:String) {
        self.lblTitle.text = title
    }
    
    func setRightButton(imageName:String) {
        self.setRightButton(shouldHide: false, imageName: imageName, title: kBlankString)
    }
    
    func setRightButton(title:String = kBlankString) {
        if title == kBlankString {
            setRightButton(shouldHide: true, imageName: nil, title: title)
        }else {
            setRightButton(shouldHide: false, imageName: nil, title: title)
        }
    }
    
    fileprivate func setRightButton(shouldHide:Bool = true, imageName:String? = nil, title:String) {
        btnRight.isHidden = shouldHide
        if shouldHide {
            btnRight.setImage(nil, for: .normal)
        }else if let name = imageName {
            btnRight.setImage(UIImage(named: name), for: .normal)
        }else {
            btnRight.setTitle(title, for: .normal)
        }
    }
    
    func showHomeController()  {
        let storyBoard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        let controller = storyBoard.instantiateViewController(withIdentifier: ControllerIdentifier.MainTabBarController) as! MainTabBarController
        addChild(controller)
        controller.view.frame = self.viewContainer.bounds
        self.viewContainer.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
    
    
    //MARK:- Action methods
    @IBAction func actionRightButton(_ sender: Any) {
        self.delegate?.rightButtonAction()
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.delegate?.actionBack()
    }
    
    
}
