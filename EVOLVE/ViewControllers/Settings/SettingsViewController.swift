//
//  SettingsViewController.swift
//  EVOLVE
//
//  Created by iOS Developer on 23/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit

class SettingsViewController: BaseViewController, TopBarDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Override methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let container = self.mainContainer {
            container.setBackButton()
            container.delegate = self
            container.setTitle(NavigationTitles.Settings)
        }
        self.tableView.reloadData()
    }
    
    //MARK:- Custom methods
    fileprivate func navigateToSubscription() {
        let storyboard = UIStoryboard(name: StoryboardNames.Profile, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SubscriptionViewController) as! SubscriptionViewController
        controller.isFirstScreen = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func navigateToProfileUpdate() {
        let storyboard = UIStoryboard(name: StoryboardNames.Profile, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.UpdateProfileViewController) as! UpdateProfileViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func logoutUser() {
        self.startActivity()
        GCD.async(.Main, delay: 1.5) {
            self.stopActivity()
            UserDefaultsManager.shared.clearUserData()
            let storyboard = UIStoryboard(name: StoryboardNames.Registeration, bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.SigninViewController) as! SigninViewController
            self.mainContainer?.navigationController?.setViewControllers([controller], animated: true)
            self.mainContainer?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func actionBack() {
        self.tabBarController?.selectedIndex = 0
    }
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsList.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingUserTableViewCell.reuseIdentifier, for: indexPath) as! SettingUserTableViewCell
            cell.configure()
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingOptionTableViewCell.reuseIdentifier, for: indexPath) as! SettingOptionTableViewCell
            cell.configure(with: SettingsList.data[indexPath.row])
            
            if indexPath.row == SettingsList.data.count - 1 {
                cell.lblBottomLine.isHidden = true
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 120
        }else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 1 {
            self.navigateToProfileUpdate()
        }else if indexPath.row == 2 {
            self.navigateToSubscription()
        }else if indexPath.row == 4 {
            self.logoutUser()
        }
    }
    
}
