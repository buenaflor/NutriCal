//
//  File.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RestaurantEndUserDetailViewController: BaseRestaurantDetailViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.register(UICollectionViewCell.self)
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.delegate = self
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
        
        self.view.layoutIfNeeded()
        self.imagePickerButton.layer.cornerRadius = self.imagePickerButton.frame.size.height / 2
    }
}

extension RestaurantEndUserDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(UICollectionViewCell.self, forIndexPath: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}

extension RestaurantEndUserDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("sup")
    }
}

extension RestaurantEndUserDetailViewController: BaseRestaurantDetailViewControllerDelegate {
    func baseRestaurantDetailViewController(_ baseRestaurantDetailViewController: BaseRestaurantDetailViewController, didSet restaurant: RestaurantIdentifier, menus: [Menu]) {
        self.collectionView.reloadData()
    }
}
