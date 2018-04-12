//
//  RestaurantEndUserDetailSearchViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RestaurantEndUserDetailSearchViewController: UIViewController {
    
    var internalMenus = [InternalMenu]()
    
    private var filteredFoods = [Food]()
    
    private var isSearching = false
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RestaurantEndUserDetailFoodCell.self)
        tableView.backgroundColor = UIColor.StandardMode.HomeBackground
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        let exitLeftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(exitLeftBarButtonItemTapped))
        self.navigationItem.leftBarButtonItem = exitLeftBarButtonItem
        
        self.navigationItem.searchController = searchController
        self.searchController.isActive = true
        
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
    
    @objc private func exitLeftBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension RestaurantEndUserDetailSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let foods = self.internalMenus.flatMap({ $0.foods })
        return self.isSearching ? self.filteredFoods.count : foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RestaurantEndUserDetailFoodCell.self, forIndexPath: indexPath)
    
        cell.priceButton.row = indexPath.row
        cell.priceButton.section = indexPath.section
        
        let foods = self.internalMenus.flatMap({ $0.foods })
        
        cell.dataSource = self.isSearching ? self.filteredFoods[indexPath.row] : foods[indexPath.row]
        
        return cell
    }
}

extension RestaurantEndUserDetailSearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}


extension RestaurantEndUserDetailSearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
            self.tableView.reloadData()
        }
        else {
            self.isSearching = true

            self.filteredFoods = self.internalMenus
                .flatMap{$0.foods}
                .filter{$0.name.lowercased().contains(searchText.lowercased())}   
            
            self.tableView.reloadData()
        }
    }
}
