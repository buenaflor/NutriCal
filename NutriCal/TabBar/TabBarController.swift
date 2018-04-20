//
//  TabBarController.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    lazy var home: HomeViewController = HomeViewController()
    lazy var homeNav: UINavigationController = {
        let vc = UINavigationController(rootViewController: self.home)
        vc.tabBarItem.image = #imageLiteral(resourceName: "home-transparent")
        vc.title = "Home"
        return vc
    }()
    
    lazy var map: MapViewController = MapViewController()
    lazy var mapNav: UINavigationController = {
        let vc = UINavigationController(rootViewController: self.map)
        vc.tabBarItem.image = #imageLiteral(resourceName: "map")
        vc.title = "Map"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(ApiPath.books)
        viewControllers = [ homeNav, mapNav ]
    }
}

