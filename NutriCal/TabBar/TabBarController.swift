//
//  TabBarController.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeViewController = HomeViewController()
        let homeViewNavController = UINavigationController(rootViewController: homeViewController)
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "home-transparent"), tag: 0)
        
        let mapViewController = MapViewController()
        let mapNavController = UINavigationController(rootViewController: mapViewController)
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: #imageLiteral(resourceName: "map"), tag: 1)
        
        viewControllers = [homeViewNavController, mapNavController]
    }
}

