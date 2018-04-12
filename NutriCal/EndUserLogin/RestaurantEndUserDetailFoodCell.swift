//
//  RestaurantEndUserDetailFoodCell.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    var row = Int()
    var section = Int()
}

class RestaurantEndUserDetailFoodCell: UITableViewCell {
    
    var restaurantEndUserDetailViewController = RestaurantEndUserDetailViewController()
    
    var dataSource: Any? {
        didSet {
            guard let food = dataSource as? Food else { return }
            
            self.foodNameLabel.text = food.name
            self.descriptionLabel.text = food.description
            self.kCalLabel.text = "\(food.kCal) kCal"
            self.priceButton.setTitle("\(food.price) €", for: .normal)
        }
    }
    
    private let foodNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 21)
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let kCalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var priceButton: CustomButton = {
        let button = CustomButton()
        button.addTarget(restaurantEndUserDetailViewController, action: #selector(restaurantEndUserDetailViewController.priceButtonTapped(sender:)), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 3
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: foodNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        self.add(subview: priceButton) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -15),
            v.widthAnchor.constraint(equalToConstant: 70),
            v.heightAnchor.constraint(equalToConstant: 36)
            ]}
        
        self.add(subview: descriptionLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: foodNameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: priceButton.leadingAnchor, constant: -15)
            ]}
        
        self.add(subview: kCalLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -5)
            ]}
        
        self.add(subview: separatorLine) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.6)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
