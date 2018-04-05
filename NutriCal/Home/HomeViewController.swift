//
//  HomeViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SideMenu
import SwiftSpinner

class HomeViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(RestaurantMenuCell.self)
        collectionView.register(DealOfTheMonthView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "id")
        collectionView.backgroundColor = UIColor(red:0.95, green:0.92, blue:0.89, alpha:1.0)
        return collectionView
    }()
    
    private let dealOfTheMonthView = DealOfTheMonthView()
    
    private var internalRestaurants = [InternalRestaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading Restaurants")
        let firebaseManager = FirebaseManager()
        
        firebaseManager.fetchRestaurant { (restaurantIdentifiers) in
            restaurantIdentifiers.forEach({ restaurantIdentifier in

                firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier, completion: { (internalMenus, hasMenu) in
                    
                    print(restaurantIdentifier.restaurant.name)
                    if hasMenu {
                        
                        guard let internalMenus = internalMenus else { return }
                        
                        let internalRestaurant = InternalRestaurant(restaurant: restaurantIdentifier.restaurant, internalMenu: internalMenus)
                        self.internalRestaurants.append(internalRestaurant)
                        
                        self.collectionView.reloadData()
                        SwiftSpinner.hide()
                    
                    }
                    else {
                        print(restaurantIdentifier.restaurant.name, "has no food yet")
                    }
                })
            })
        }
    
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("appeared")
    }
    
    private func createSideMenu() {
        let leftSideMenuViewController = SideMenuViewController()
        leftSideMenuViewController.delegate = self
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: leftSideMenuViewController)
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController

        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor(red:0.87, green:0.84, blue:0.81, alpha:1.0)

        self.createNavigationItems()
        self.createSideMenu()
        self.configureConstraints()
    }
    
    private func createNavigationItems() {
        let leftMenuNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "burger-menu"), style: .plain, target: self, action: #selector(leftMenuNavigationItemTapped))
        navigationItem.leftBarButtonItem = leftMenuNavigationItem
    }
    
    private func configureConstraints() {
    
        
        self.view.add(subview: self.collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    @objc private func leftMenuNavigationItemTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "id", for: indexPath)
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.internalRestaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RestaurantMenuCell.self, forIndexPath: indexPath)
        
        cell.dataSource = self.internalRestaurants[indexPath.row].restaurant
        cell.delegate = self

        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurantViewController = RestaurantViewController()
        self.navigationController?.pushViewController(restaurantViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.6)
    }
}

extension HomeViewController: RestaurantMenuCellDelegate {
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: SideMenuViewControllerDelegate {
    func sideMenuViewController(_ sideMenuViewController: SideMenuViewController, didChange slider: UISlider, filterOption: FilterOption) {
        print(Int(slider.value * 10))
        self.collectionView.reloadData()
    }
}




