//
//  RestaurantMenuCell.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol RestaurantMenuCellDelegate: class {
    func pushViewController(_ viewController: UIViewController)
}

class RestaurantMenuCell: UICollectionViewCell {
    
    var dataSource: Any? {
        didSet {
            guard let restaurant = dataSource as? Restaurant else { return }
            restaurantView.dataSource = restaurant
        }
    }
    
    
    
    weak var delegate: RestaurantMenuCellDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(RestaurantMenuGaleryCell.self)
        collectionView.backgroundColor = .white
        return collectionView
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
        
        
        self.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.restaurantView.bottomAnchor, constant: 12),
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
}

extension RestaurantMenuCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RestaurantMenuGaleryCell.self, forIndexPath: indexPath)
        
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
        let foodDetailViewController = FoodDetailViewController()
        self.delegate?.pushViewController(foodDetailViewController)
    }
}



