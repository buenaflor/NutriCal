//
//  RatingCell.swift
//  NutriCal
//
//  Created by Giancarlo on 12.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Cosmos

protocol RatingCellDelegate: class {
    func ratingCell(_ ratingCell: RatingCell, didSelect rating: Int)
}

class RatingCell: UICollectionViewCell {
    
    var dataSource: Any? {
        didSet {
            guard let restaurantIdentifier = dataSource as? RestaurantIdentifier else { return }
            
            self.rateLabel.text = "Rate \(restaurantIdentifier.restaurant.name)"
            self.descriptionLabel.text = "Reviews are public and editable. Past edits are visible to the developer unless you delete your review altogether."
        }
    }
    
    weak var delegate: RatingCellDelegate?
    
    private let rateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 23)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 17)
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 21)
        return label
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.rating = 0
        view.settings.starSize = 30
        view.settings.emptyBorderColor = .darkGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.StandardMode.LightBackground
        
        self.cosmosView.didTouchCosmos = { _ in
            self.cosmosViewTapped()
            self.delegate?.ratingCell(self, didSelect: Int(self.cosmosView.rating))
        }
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: rateLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 75),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
        self.add(subview: cosmosView) { (v, p) in [
            v.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 10),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        self.add(subview: descriptionLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: cosmosView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 50),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func cosmosViewTapped() {
        
        self.descriptionLabel.removeFromSuperview()
        
        self.add(subview: ratingLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 50),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -50)
            ]}
        
        switch cosmosView.rating {
        case 1:
            self.ratingLabel.text = "Hated it"
        case 2:
            self.ratingLabel.text = "Did not like it very much"
        case 3:
            self.ratingLabel.text = "It was okay"
        case 4:
            self.ratingLabel.text = "I liked it"
        case 5:
            self.ratingLabel.text = "It was very good"
        default:
            print("hey")
        }
    }
    
}
