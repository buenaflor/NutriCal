//
//  AddRestaurantViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner

class ManageRestaurantsViewController: UIViewController {
    
    private let manager = FirebaseManager()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ManageRestaurantCell.self)
        tableView.tableFooterView = UIView()
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        return tableView
    }()
    
    private var restaurantIdentifiers = [RestaurantIdentifier]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        SwiftSpinner.setTitleFont(UIFont(name: "Futura", size: 22.0))
        
        self.fetchRestaurants(showLoadingIndicator: true, indicatorText: "Fetching Restaurant Data")
    }
    
    
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.title = "Your Restaurants"
        
        let addRestaurantBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addRestaurantBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = addRestaurantBarButtonItem
        
        let dismissBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(dismissBarButtonItemTapped))
        self.navigationItem.leftBarButtonItem = dismissBarButtonItem
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.view.add(subview: self.tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    @objc private func addRestaurantBarButtonItemTapped() {
        let addRestaurantsViewController = AddRestaurantsViewController()
        addRestaurantsViewController.delegate = self
        
        self.navigationController?.pushViewController(addRestaurantsViewController, animated: true)
    }
    
    @objc private func dismissBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func refreshControlAction(sender: UIRefreshControl) {
        self.fetchRestaurants(showLoadingIndicator: false, indicatorText: "")
        self.refreshControl.endRefreshing()
    }
    
    private func fetchRestaurants(showLoadingIndicator: Bool, indicatorText: String) {
        
        if showLoadingIndicator { SwiftSpinner.show(indicatorText) }
        
        self.manager.fetchRestaurant { (restaurants) in
            
            // Caching?
            for restaurantIdentifier in restaurants {
                self.restaurantIdentifiers.append(restaurantIdentifier)
            }
            
            for (index, element) in self.restaurantIdentifiers.enumerated().reversed() {
                if self.restaurantIdentifiers.filter({ $0.documentIdentifier == element.documentIdentifier }).count > 1 {
                    self.restaurantIdentifiers.remove(at: index)
                }
            }
            self.tableView.reloadData()
            if showLoadingIndicator { SwiftSpinner.hide() }
        }
    }
}

extension ManageRestaurantsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ManageRestaurantCell.self, forIndexPath: indexPath)
        
        cell.dataSource = restaurantIdentifiers[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ManageRestaurantsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 0.33) {
            cell.alpha = 1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let editRestaurantItemsViewController = EditRestaurantItemsViewController()
//        editRestaurantItemsViewController.restaurantIdentifier = restaurantIdentifiers[indexPath.row]
        
//        let addRestaurantMenuViewController = AddRestaurantMenuViewController()
//        addRestaurantMenuViewController.restaurantIdentifier = restaurantIdentifiers[indexPath.row]
        
        let restaurantDetailViewController = RestaurantDetailViewController()
        restaurantDetailViewController.restaurantIdentifier = restaurantIdentifiers[indexPath.row]
        
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ManageRestaurantsViewController: AddRestaurantsViewControllerDelegate {
    func addRestaurantsViewController(_ addRestaurantsViewController: AddRestaurantsViewController, didAdd restaurantName: String) {
        self.fetchRestaurants(showLoadingIndicator: false, indicatorText: "")
    }
}
