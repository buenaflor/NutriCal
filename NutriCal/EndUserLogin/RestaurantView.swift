//
//  RestaurantView.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Cosmos

protocol RestaurantViewDelegate: class {
    func restaurantView(_ restaurantView: UIView, didClick button: UIButton)
}

class RestaurantView: UIView {
    
    let firebaseManager = FirebaseManager()
    
    var dataSource: Any? {
        didSet {
            guard
                let restaurantIdentifier = dataSource as? RestaurantIdentifier,
                let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath)
                else { return }
            
            self.restaurantNameLabel.text = restaurantIdentifier.restaurant.name
            self.restaurantCuisineLabel.text = restaurantIdentifier.restaurant.cuisine
            self.restaurantImageView.image = #imageLiteral(resourceName: "restaurant-logo2")
            self.priceIndicatorLabel.text = "€€"
            
            self.firebaseManager.calculateAverageRating(from: restaurantIdentifier) { (rating) in
                self.cosmosView.rating = rating
            }
            
            self.firebaseManager.fetchReviews(from: restaurantIdentifier) { (reviews) in
                self.cosmosView.text = "\((reviews.count))"
            }
            
//            self.restaurantImageView.sd_setImage(with: imgURL)
        }
    }
    
    weak var delegate: RestaurantViewDelegate?
    
    private let settingsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "menu-vertical").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(settingsButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    private let restaurantNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir-Black", size: 23)
        label.numberOfLines = 1
        return label
    }()
    
    private let priceIndicatorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 19)
        label.numberOfLines = 1
        return label
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .precise
        view.settings.starSize = 30
        view.settings.textFont = UIFont(name: "Avenir", size: 16)!
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let restaurantCuisineLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 19)
        label.numberOfLines = 1
        return label
    }()
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let leftContainerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.cosmosView.didFinishTouchingCosmos = { rating in
            print(rating)
        }
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        leftContainerView.backgroundColor = UIColor(red:0.95, green:0.92, blue:0.89, alpha:1.0)
        
        self.add(subview: leftContainerView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.38),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.38)
            ]}
        
        self.leftContainerView.add(subview: restaurantImageView) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.heightAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor)
            ]}
        
        self.add(subview: restaurantNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 20)
            ]}
        
        self.add(subview: cosmosView) { (v, p) in [
            v.topAnchor.constraint(equalTo: restaurantNameLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 18),
            ]}
        
        self.add(subview: restaurantCuisineLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: leftContainerView.trailingAnchor, constant: 20)
            ]}
        
        self.add(subview: priceIndicatorLabel) { (v, p) in [
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 15)
            ]}
        
        self.add(subview: settingsButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.widthAnchor.constraint(equalToConstant: 26),
            v.heightAnchor.constraint(equalToConstant: 26)
            ]}
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        
        self.add(subview: separatorView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.6)
            ]}
    }
    
    @objc private func settingsButtonTapped(sender: UIButton) {
        self.delegate?.restaurantView(self, didClick: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DefaultPopOverViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        popoverPresentationController?.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

