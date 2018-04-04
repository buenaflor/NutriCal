//
//  ManageRestaurantCell.swift
//  NutriCal
//
//  Created by Giancarlo on 03.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SDWebImage

class ManageRestaurantCell: UITableViewCell {
    
    var dataSource: Any? {
        didSet {
            guard let restaurantIdentifier = dataSource as? RestaurantIdentifier else { return }
        
            if let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) {
                self.restaurantLogoImageView.sd_setImage(with: imgURL)
            }
            else {
                self.restaurantLogoImageView.image = #imageLiteral(resourceName: "pexels-photo-696218")
            }

            switch restaurantIdentifier.restaurant.confirmation {
            case ConfirmationState.pending.rawValue:
                self.statusCodeLabel.text = "Status: Pending"
                self.statusCodeLabel.textColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
            case ConfirmationState.denied.rawValue:
                self.statusCodeLabel.text = "Status: Denied"
                self.statusCodeLabel.textColor = .red
            case ConfirmationState.confirmed.rawValue:
                self.statusCodeLabel.text = "Status: Approved"
                self.statusCodeLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            default:
                break;
            }
            
            self.restaurantNameLabel.text = restaurantIdentifier.restaurant.name
            
            let street = restaurantIdentifier.restaurant.street
            let postalCode = restaurantIdentifier.restaurant.postalCode
            let city = restaurantIdentifier.restaurant.city
            self.addressLabel.text = "\(street), \(postalCode) \(city)"
            
            self.avgRatingLabel.text = "Avg. Rating: "
        }
    }
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 22.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 17.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let avgRatingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 17.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let restaurantLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let statusCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 15.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let leftContainerView = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.StandardMode.LightBackground
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: leftContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.3),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor)
            ]}
        
        self.leftContainerView.add(subview: restaurantLogoImageView) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.85),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.85)
            ]}
        
        self.add(subview: restaurantNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor,constant: 17),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor)
            ]}
        
        self.add(subview: addressLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor)
            ]}
        
        self.add(subview: avgRatingLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor)
            ]}
        
        self.add(subview: statusCodeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: avgRatingLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
