//
//  AppDelegate.swift
//  EVOLVE
//
//  Created by iOS Developer on 20/03/2020.
//  Copyright © 2020 Rapidzz. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
//        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
//        navigationController?.navigationBar.barTintColor = UIColor.green
//        UINavigationBar.appearance().backgroundColor = .red
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        setupInitailController()
        return true
    }
    
    fileprivate func setupInitailController() {
        if window == nil {
            window = UIWindow()
        }
        
        let storyboard:UIStoryboard
        
        if UserDefaultsManager.shared.isUserLoggedIn {
            Global.shared.user = UserDefaultsManager.shared.userInfo
            storyboard = UIStoryboard(name: StoryboardNames.Main, bundle: nil)
        }else {
            storyboard = UIStoryboard(name: StoryboardNames.Registeration, bundle: nil)
        }
        
        if !UserDefaultsManager.shared.shouldShowLoginScreen {
            let controller = storyboard.instantiateViewController(withIdentifier: ControllerIdentifier.BaseIntroductionViewController)
            window?.rootViewController = controller
        }else {
            let controller = storyboard.instantiateInitialViewController()
            window?.rootViewController = controller
        }
        window?.makeKeyAndVisible()
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

