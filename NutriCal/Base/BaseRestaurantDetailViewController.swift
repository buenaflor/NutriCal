//
//  BaseRestaurantDetailViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Cosmos
import SwiftSpinner

protocol BaseRestaurantDetailViewControllerDelegate: class {
    func baseRestaurantDetailViewController(_ baseRestaurantDetailViewController: BaseRestaurantDetailViewController, didSet restaurant: RestaurantIdentifier, menus: [Menu])
}

class BaseRestaurantDetailViewController: BaseImagePickerViewController {
    
    weak var delegate: BaseRestaurantDetailViewControllerDelegate?
    
    let firebaseManager = FirebaseManager()
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            
            SwiftSpinner.show("Loading Data")
            
            guard let restaurantIdentifier = restaurantIdentifier else { return }
            guard let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
            self.firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier, completion: { (menu) in
                
                self.menus = menu
                self.setupCountLabelText(for: self.menuCountLabel, count: self.menus.count, searchString: "Menus")
                self.delegate?.baseRestaurantDetailViewController(self, didSet: restaurantIdentifier, menus: self.menus)
                SwiftSpinner.hide()
            })
            
            self.imagePickerButton.sd_setImage(with: imgURL, for: .normal)
            self.setupCountLabelText(for: reviewsCountLabel, count: 0, searchString: "Reviews")
            self.setupCountLabelText(for: menuCountLabel, count: self.menus.count, searchString: "Menus")
            self.ratingLabel.text = "Avg. Rating: 4.3"
            
            self.nameLabel.text = restaurantIdentifier.restaurant.name
            
            let street = restaurantIdentifier.restaurant.street
            let postalCode = restaurantIdentifier.restaurant.postalCode
            let city = restaurantIdentifier.restaurant.city
            self.addressLabel.text = "\(street), \(postalCode) \(city)"
        }
    }
    
    var menus = [Menu]()
    
    private let menuCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 22.0)
        label.numberOfLines = 1
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 19.0)
        label.numberOfLines = 1
        return label
    }()
    
    let separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.StandardMode.TabBarColor
        return separatorLine
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.rating = 1
        view.text = "(32)"
        view.settings.starSize = 30
        view.settings.textFont = UIFont(name: "Avenir", size: 16)!
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: imagePickerButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.26),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.26)
            ]}
        
        self.view.add(subview: menuCountLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 35),
            v.leadingAnchor.constraint(equalTo: imagePickerButton.trailingAnchor, constant: 40),
            ]}
        
        self.view.add(subview: reviewsCountLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 35),
            v.leadingAnchor.constraint(equalTo: menuCountLabel.trailingAnchor, constant: 45),
            ]}
        
        self.view.add(subview: cosmosView) { (v, p) in [
            v.topAnchor.constraint(equalTo: menuCountLabel.bottomAnchor, constant: 15),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
        self.view.add(subview: ratingLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: menuCountLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: imagePickerButton.trailingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: cosmosView.leadingAnchor)
            ]}
        
        self.view.add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        self.view.add(subview: addressLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        self.view.add(subview: separatorLine) { (v, p) in [
            v.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
    }
    
    private func setupCountLabelText(for label: UILabel, count: Int, searchString: String) {
        let labelString = "\(count)\n\(searchString)"
        
        let wholeRange = (labelString as NSString).range(of: labelString)
        let range = (labelString as NSString).range(of: searchString)
        
        let attributedText = NSMutableAttributedString.init(string: labelString)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range)
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 22), range: wholeRange)
        label.attributedText = attributedText
    }
}
