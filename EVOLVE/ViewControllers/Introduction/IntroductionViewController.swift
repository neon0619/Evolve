//
//  IntroductionViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 13/05/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class IntroductionViewController: BaseViewController {
    
    
    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var currentIndex = 0
    var images = [AssetNames.introImage1,
                  AssetNames.introImage2,
                  AssetNames.introImage3,
                  AssetNames.introImage4,
                  AssetNames.introImage5]
    
    var index1String = "Get inspired by nutritious and simple recipes that you can make at home!"
    var index2String = "Discover delicious meals to create for yourself, your family and your friends."
    var index3String = "Quickly add items from your favourite recipes to curate easy shopping lists."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
    }
    
    //MARK:- Custom methods
    fileprivate func setupCollectionView() {
        let introNib = UINib(nibName: IntroCollectionViewCell.reuseIdentifier, bundle: nil)
        let detailNib = UINib(nibName: IntroDetailsCollectionViewCell.reuseIdentifier, bundle: nil)
        mainCollectionView.register(introNib, forCellWithReuseIdentifier: IntroCollectionViewCell.reuseIdentifier)
        mainCollectionView.register(detailNib, forCellWithReuseIdentifier: IntroDetailsCollectionViewCell.reuseIdentifier)
    }
    
    func moveCollectionToFrame(contentOffset : CGFloat) {
        let frame: CGRect = CGRect(x : contentOffset ,y : mainCollectionView.contentOffset.y ,width : mainCollectionView.frame.width,height : mainCollectionView.frame.height)
        mainCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    fileprivate func moveToSigninScreen() {
        UserDefaultsManager.shared.shouldShowLoginScreen = true
        let controller = storyboard?.instantiateViewController(withIdentifier: ControllerIdentifier.SigninViewController) as! SigninViewController
        self.navigationController?.setViewControllers([controller], animated: true)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    //MARK:- Action methods
    @IBAction func actionNext(_ sender: Any) {
        let cellWidth = self.mainCollectionView.visibleCells[0].bounds.size.width
        let offset = floor(self.mainCollectionView.contentOffset.x + cellWidth)
        self.pageControl.currentPage = self.pageControl.currentPage + 1
        
        if pageControl.currentPage == 4 {
            self.btnSkip.isHidden = true
            self.btnNext.isHidden = true
        }else {
            self.btnSkip.isHidden = false
            self.btnNext.isHidden = false
        }
        
        self.moveCollectionToFrame(contentOffset: offset)
    }
    
    @IBAction func actionSkip(_ sender: Any) {
        self.moveToSigninScreen()
    }
    
    
}

extension IntroductionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == images.count - 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroDetailsCollectionViewCell.reuseIdentifier, for: indexPath) as! IntroDetailsCollectionViewCell
            cell.watchForClickHandler {
                self.moveToSigninScreen()
            }
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IntroCollectionViewCell.reuseIdentifier, for: indexPath) as! IntroCollectionViewCell
            
            if indexPath.row == 0 {
                cell.firstView.isHidden = false
                cell.secondView.isHidden = true
                cell.imgImage.image = UIImage(named: images[indexPath.item])
            }else {
                cell.firstView.isHidden = true
                cell.secondView.isHidden = false
                cell.imgImage.image = UIImage(named: AssetNames.introImage5)
                cell.imgSecondImage.image = UIImage(named: images[indexPath.item])
                
                if indexPath.row == 1 {
                    cell.lblSecondLabel.text = self.index1String
                }else if indexPath.row == 2 {
                    cell.lblSecondLabel.text = self.index2String
                }else if indexPath.row == 3 {
                    cell.lblSecondLabel.text = self.index3String
                }
                
                
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        let number = Int(x / view.frame.width)
        pageControl.currentPage = number
        
        if pageControl.currentPage == 4 {
            self.btnSkip.isHidden = true
            self.btnNext.isHidden = true
        }else {
            self.btnSkip.isHidden = false
            self.btnNext.isHidden = false
        }
    }
    
}
