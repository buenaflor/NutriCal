//
//  FavouritesViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 13.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner

enum BaseType {
    case restaurant
    case menu
    case food
}

class FavouritesViewController: UIViewController {
    
    // default type
    private var currentType = BaseType.restaurant
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ManageRestaurantCell.self)
        return tableView
    }()
    
    private var restaurantIdentifiers = [RestaurantIdentifier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading Favourites")
        
        self.setupView()
        
        let firebaseManager = FirebaseManager()
        
        firebaseManager.fetchFavourites { (restaurantIdentifiers) in
            self.restaurantIdentifiers = restaurantIdentifiers
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.title = "Favourites"
        
        let chooseFavouriteRightBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseFavouriteRightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = chooseFavouriteRightBarButton
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    @objc private func chooseFavouriteRightBarButtonTapped() {
        let alertController = UIAlertController(title: "Favourite", message: "This is my message", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Restaurants", style: .default) { (_) in
            print("hey restaurant")
            self.currentType = BaseType.restaurant
            })
            
        alertController.addAction(UIAlertAction(title: "Menus", style: .default) { (_) in
            print("hey menu")
            self.currentType = BaseType.menu
        })
        
        alertController.addAction(UIAlertAction(title: "Food", style: .default) { (_) in
            print("hey food")
            self.currentType = BaseType.food
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.restaurantIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ManageRestaurantCell.self, forIndexPath: indexPath)
        
        cell.dataSource = self.restaurantIdentifiers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.currentType {
        case BaseType.restaurant:
            let restaurantEndUserDetailViewController = RestaurantEndUserDetailViewController()
            restaurantEndUserDetailViewController.restaurantIdentifier = self.restaurantIdentifiers[indexPath.row]
            self.navigationController?.pushViewController(restaurantEndUserDetailViewController, animated: true)
        default:
            break
        }
    }
}
