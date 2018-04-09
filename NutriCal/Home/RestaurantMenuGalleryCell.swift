//
//  RestaurantMenuGalleryCell.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner
import AMPopTip

class RestaurantMenuGalleryCell: UICollectionViewCell {
    
    var isHot = false
    
    var firstDataSource: Any? {
        didSet {
            guard let firstFood = firstDataSource as? Food else { return }
            self.isHot = true
            
        }
    }
    
    var dataSource: Any? {
        didSet {
            guard let food = dataSource as? Food else { return }

            self.foodNameLabel.text = food.name
            self.priceLabel.text = "\(food.price) €"
            self.kcalLabel.text = "\(food.kCal) kCal"
            
            var ingredients = ""
            
            food.ingredients.forEach({
                if food.ingredients.first == $0 {
                    ingredients.append("\($0)")
                }
                else {
                    ingredients.append(", \($0)")
                }
            })
            
            self.ingredientsLabel.text = "\(ingredients)"
            
            SwiftSpinner.hide()
        }
    }
    
    private lazy var hotTipButton: UIButton = {
        let button = UIButton()
        button.setTitle("HOT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        return button
    }()
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir", size: 20)
        label.numberOfLines = 1
        return label
    }()
    
    private let kcalLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir", size: 20)
        label.numberOfLines = 1
        return label
    }()
    
    private let ingredientsLabel: UILabel = {
        let label = UILabel()
        label.font =  UIFont(name: "Avenir", size: 20)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.StandardMode.LightBackground
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: hotTipButton) { (v, p) in [
                v.topAnchor.constraint(equalTo: p.topAnchor, constant: 12),
                v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 6),
                v.widthAnchor.constraint(equalToConstant: 60),
                v.heightAnchor.constraint(equalToConstant: 20)
                ]}
        
        self.add(subview: foodNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.hotTipButton.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 6),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -3)
            ]}
        
        self.add(subview: priceLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 6)
            ]}
        
        self.add(subview: kcalLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -6),
            v.leadingAnchor.constraint(equalTo: kcalLabel.leadingAnchor, constant: 5)
            ]}
        
        self.add(subview: ingredientsLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 6),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -6)
            ]}
        
    }
    
    @objc private func hotTipButtonTapped() {
        print("clicked")
        let popTip = PopTip()
        popTip.show(text: "This is HOT", direction: .up, maxWidth: 200, in: self, from: hotTipButton.frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
