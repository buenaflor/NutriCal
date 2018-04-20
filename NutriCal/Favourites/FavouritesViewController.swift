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
        
        firebaseManager.fetchFavourites2 { (restaurantIDs) in
            print(restaurantIDs)
            firebaseManager.fetchRestaurantsWith(restaurantIDs: restaurantIDs, completion: { (restaurantIdentifiers) in
                print(restaurantIdentifiers)
                self.restaurantIdentifiers = restaurantIdentifiers
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
        }
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.title = "Favourites"
        
        let chooseFavouriteRightBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseFavouriteRightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = chooseFavouriteRightBarButton
        
        self.navigationItem.leftBarButtonItem = editButtonItem
        
        self.configureConstraints()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        let myTest = RealmTest()
        myTest.read()
        
        
        tableView.setEditing(editing, animated: animated)
        refreshTableView(animated: animated)
    }
    
    func refreshTableView(animated: Bool) {
        self.tableView.reloadSections(IndexSet(integer: 0), with: animated ? .automatic : .none)
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
            self.currentType = BaseType.restaurant
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        })
        
        alertController.addAction(UIAlertAction(title: "Menus", style: .default) { (_) in
            self.currentType = BaseType.menu
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        })
        
        alertController.addAction(UIAlertAction(title: "Food", style: .default) { (_) in
            self.currentType = BaseType.food
            self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentType {
        case .restaurant:
            return self.restaurantIdentifiers.count
        case .menu:
            return 10
        case .food:
            return 30
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch currentType {
        case .restaurant:
            let cell = tableView.dequeueReusableCell(ManageRestaurantCell.self, forIndexPath: indexPath)
            cell.dataSource = self.restaurantIdentifiers[indexPath.row]
            return cell
        case .menu:
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
            cell.textLabel?.text = "he"
            return cell
        case .food:
            let cell = tableView.dequeueReusableCell(RestaurantEndUserDetailFoodCell.self, forIndexPath: indexPath)
            cell.priceButton.row = indexPath.row
            cell.priceButton.section = indexPath.section
            cell.dataSource = Food(name: "My Food", description: "Best Food", isVegan: true, ingredients: ["Salad", "Tomato"], kCal: 300, price: 8.99, imageLink: "")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch currentType {
        case .restaurant:
            return 150
        case .menu:
            return 70
        case .food:
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let firebaseManager = FirebaseManager()
            firebaseManager.deleteFavourite(documentIdentifier: self.restaurantIdentifiers[indexPath.row].documentIdentifier) {
                self.restaurantIdentifiers.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension FavouritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch self.currentType {
        case BaseType.restaurant:
            let restaurantEndUserDetailViewController = RestaurantEndUserDetailViewController()
            restaurantEndUserDetailViewController.configureWithModel(self.restaurantIdentifiers[indexPath.row])
            self.navigationController?.pushViewController(restaurantEndUserDetailViewController, animated: true)
        default:
            break
        }
    }
}
