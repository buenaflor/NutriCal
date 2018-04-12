//
//  FoodDetailViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SDWebImage
import SwiftSpinner

class FoodDetailViewController: UIViewController {
    
    var food: Food? {
        didSet {
            guard let food = food, let imageURL = URL(string: food.imageLink) else { return }
            self.foodImageView.sd_setImage(with: imageURL)
           
            SwiftSpinner.hide()
        }
    }
    
    private let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: foodImageView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.3)
            ]}
    }
}

extension FoodDetailViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("")
    }
}
