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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        setupFireBase()
        
        return true
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
        UINavigationBar.appearance().barTintColor = UIColor.StandardMode.TabBarColor
        UINavigationBar.appearance().tintColor = .white
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = UIColor.StandardMode.TabBarColor
    }
}

