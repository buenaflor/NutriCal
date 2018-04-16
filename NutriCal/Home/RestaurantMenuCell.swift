//
//  RestaurantMenuCell.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner

protocol RestaurantMenuCellDelegate: class {
    func pushViewController(_ viewController: UIViewController)
    func restaurantMenuCell(_ restaurantMenuCell: RestaurantMenuCell, didClick button: UIButton)
}

class RestaurantMenuCell: UICollectionViewCell {
    
    var dataSource: Any? {
        didSet {
            print("sup identifier")
            guard let restaurantIdentifier = dataSource as? RestaurantIdentifier else { return }
            
            self.restaurantView.dataSource = restaurantIdentifier
            self.restaurantView.delegate = self
            
            let firebaseManager = FirebaseManager()
            firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier) { (menus) in
                self.menus = menus
                
                self.menus.forEach { (menu) in
                    firebaseManager.fetchFood(restaurantIdentifier: restaurantIdentifier, menu: menu, completion: { (internalMenu) in
                        self.internalMenus.append(internalMenu)
                        self.collectionView.reloadData()
                        
                    })
                }
            }
        }
    }
    
    private var internalMenus = [InternalMenu]()
    
    private var menus = [Menu]()
    
    weak var delegate: RestaurantMenuCellDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantMenuGalleryCell.self)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private let recommendedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 20)
        label.text = "Recommended Menu"
        label.numberOfLines = 1
        return label
    }()
    
    private let restaurantView = RestaurantView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: self.restaurantView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 12),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -12),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.4)
            ]}
        
        self.add(subview: recommendedLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.restaurantView.bottomAnchor, constant: 12),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 12)
            ]}
        
        self.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.recommendedLabel.bottomAnchor, constant: 12),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 12),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -12),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -12)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func test() {
        print("test")
    }
}

extension RestaurantMenuCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let firstMenu = self.internalMenus.first else { return 0 }
        return firstMenu.foods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RestaurantMenuGalleryCell.self, forIndexPath: indexPath)
        guard let firstMenu = self.internalMenus.first, let firstFood = firstMenu.foods.first else { return UICollectionViewCell() }
        
        cell.dataSource = firstMenu.foods[indexPath.row]
        cell.firstDataSource = firstFood
            
        return cell
    }
}

extension RestaurantMenuCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
}

extension RestaurantMenuCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let firstMenu = self.internalMenus.first else { return }
        
        let foodDetailViewController = FoodDetailViewController()
        foodDetailViewController.food = firstMenu.foods[indexPath.row]
        SwiftSpinner.show("Loading \(firstMenu.foods[indexPath.row].name)")
        
        self.delegate?.pushViewController(foodDetailViewController)
    }
}

extension RestaurantMenuCell: RestaurantViewDelegate {
    func restaurantView(_ restaurantView: UIView, didClick button: UIButton) {
        self.delegate?.restaurantMenuCell(self, didClick: button)
    }
}


