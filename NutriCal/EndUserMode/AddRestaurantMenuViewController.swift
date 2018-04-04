//
//  AddMenuViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class AddRestaurantMenuViewController: UIViewController {
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            guard let restaurantIdentifier = restaurantIdentifier else { return }
            guard let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
  
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
}
