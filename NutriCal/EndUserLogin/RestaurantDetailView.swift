//
//  RestaurantDetailView.swift
//  NutriCal
//
//  Created by Giancarlo on 20.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import MapKit
import Cosmos


enum DetailSectionItem {
    case menu, reviews, info
    
    var text: String {
        switch self {
        case .menu:
            return "Menu"
        case .reviews:
            return "Reviews"
        case .info:
            return "Info"
        }
    }
    
    static let all: [DetailSectionItem] = [ .menu, .reviews, .info ]
}

protocol RestaurantDetailViewDelegate: class {
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickReviews button: UIButton)
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickMenu button: UIButton)
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickInfo button: UIButton)
}

class RestaurantDetailView: UIView, Configurable {
    
    weak var delegate: RestaurantDetailViewDelegate?
    
    private let detailSectionItems = DetailSectionItem.all
    
    var model: RestaurantIdentifier?
    
    func configureWithModel(_: RestaurantIdentifier) {
        guard let restaurantIdentifier = model else { return }
        
        let firebaseManager = FirebaseManager()
        firebaseManager.calculateAverageRating(from: restaurantIdentifier) { (rating) in
            self.nameLabel.text = restaurantIdentifier.restaurant.name
            self.cosmosView.rating = rating
        }
        
        firebaseManager.fetchFavourites2 { (documentIDs) in
            documentIDs.forEach({ (id) in
                if id == restaurantIdentifier.documentIdentifier {
                    self.favouriteButton.tintColor = .red
                }
            })
        }
    }
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.numberOfLines = 0
        lbl.lineBreakMode = .byWordWrapping
        lbl.font = UIFont(name: "Avenir", size: 17)
        lbl.text = "Nutritional facts attached to each food are merely estimated values and do not guarantee 100% correctness. If you have any further questions feel free to contact us or the restaurant"
        return lbl
    }()
    
    private let reviewsButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle("Reviews", for: .normal)
        btn.addTarget(self, action: #selector(reviewsButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()

    private let infoButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle("Info", for: .normal)
        btn.addTarget(self, action: #selector(infoButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()

    private let menuButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.gray, for: .normal)
        btn.setTitle("Menu", for: .normal)
        btn.addTarget(self, action: #selector(menuButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
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
        btn.addTarget(self, action: #selector(favouriteButtonTapped(sender:)), for: .touchUpInside)
        return btn
    }()
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 19),
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
        
        let new = UIView()
        new.backgroundColor = .white
    
        add(subview: new) { (v, p) in [
            v.topAnchor.constraint(equalTo: favouriteButton.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        new.add(subview: menuButton) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.33)
            ]}
        
        new.add(subview: reviewsButton) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: menuButton.trailingAnchor),
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.33)
            ]}
        
        new.add(subview: infoButton) { (v, p) in [
            v.leadingAnchor.constraint(equalTo: reviewsButton.trailingAnchor),
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.33)
            ]}
    
        let separator = UIView()
        separator.backgroundColor = .lightGray
        
        add(subview: separator) { (v, p) in [
            v.topAnchor.constraint(equalTo: new.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
        
        addSeparatorLine(to: menuButton)
        
        add(subview: descriptionLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 32),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -32),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -15)
            ]}
    }
    
    func addSeparatorLine(to view: UIView) {
        view.add(subview: separatorView) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 4)
            ]}
    }
    
    func removeSeparatorLine(view: UIView) {
        view.remove(subviews: [separatorView])
    }
    
    @objc private func favouriteButtonTapped(sender: UIButton) {
        guard let restaurantIdentifier = model else { return }
        let firebaseManager = FirebaseManager()
        if sender.tintColor == .red {
            firebaseManager.deleteFavourite(documentIdentifier: restaurantIdentifier.documentIdentifier) {
                sender.tintColor = .gray
            }
        }
        else {
            firebaseManager.addToFavourite(restaurantIdentifier: restaurantIdentifier) {
                sender.tintColor = .red
            }
        }
    }
    
    @objc private func reviewsButtonTapped(sender: UIButton) {
        addSeparatorLine(to: sender)
        delegate?.restaurantDetailView(self, didClickReviews: sender)
    }
    
    @objc private func infoButtonTapped(sender: UIButton) {
        addSeparatorLine(to: sender)
        delegate?.restaurantDetailView(self, didClickInfo: sender)
    }
    
    @objc private func menuButtonTapped(sender: UIButton) {
        addSeparatorLine(to: sender)
        delegate?.restaurantDetailView(self, didClickMenu: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
