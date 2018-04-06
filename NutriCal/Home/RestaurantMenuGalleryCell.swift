//
//  RestaurantMenuGalleryCell.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RestaurantMenuGalleryCell: UICollectionViewCell {
    
    var dataSource: Any? {
        didSet {
            guard let food = dataSource as? Food else { return }
            
            self.foodNameLabel.text = food.name
        }
    }
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir-Black", size: 19)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .gray
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.add(subview: foodNameLabel) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
