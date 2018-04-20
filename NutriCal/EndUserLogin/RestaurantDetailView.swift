//
//  RestaurantDetailView.swift
//  NutriCal
//
//  Created by Giancarlo on 20.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import Cosmos

class RestaurantDetailView: UIView, Configurable {
    
    var model: RestaurantIdentifier?
    
    func configureWithModel(_: RestaurantIdentifier) {
        guard let restaurantIdentifier = model else { return }
        
        let firebaseManager = FirebaseManager()
        firebaseManager.calculateAverageRating(from: restaurantIdentifier) { (rating) in
            self.nameLabel.text = restaurantIdentifier.restaurant.name
            self.cosmosView.rating = rating
        }
    }
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Futura", size: 30.0)
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        return lbl
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .precise
        view.settings.starSize = 20
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let favouriteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .gray
        btn.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 23),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -15)
            ]}
        
        add(subview: cosmosView) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 23)
            ]}
        
        add(subview: favouriteButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: -5),
            v.leadingAnchor.constraint(equalTo: cosmosView.trailingAnchor, constant: 10),
            v.heightAnchor.constraint(equalToConstant: 36),
            v.widthAnchor.constraint(equalToConstant: 36)
            ]}
    }
    
    @objc private func favouriteButtonTapped() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
