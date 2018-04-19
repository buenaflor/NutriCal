//
//  AppDelegate.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var mainTabBarController: TabBarController = {
        return TabBarController()
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        setupFireBase()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        guard mainTabBarController.presentedViewController == nil else {
            return
        }
        
        guard let navVC = mainTabBarController.selectedViewController as? UINavigationController else {
            return
        }
        
        guard let loadCtrl = navVC.topViewController as? LoadingController else {
            return
        }
        
        loadCtrl.loadData(force: false)
    }
    
    func setupFireBase() {
        
        FirebaseApp.configure()
    }
    
    func setupUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        
        configureAppearances()
    }
    
    func configureAppearances() {
    
        ThemeManager.applyTheme(theme: ThemeManager.currentTheme())
    }
}
