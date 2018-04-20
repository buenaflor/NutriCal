//
//  File.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import AMPopTip

class SectionHeaderView: UIView {
    
    var text: String? {
        didSet {
            guard let text = text else { return }
            self.textLabel.text = text
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.StandardMode.HomeBackground
        
        self.add(subview: textLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class RestaurantEndUserDetailViewController: UIViewController, Configurable {
    
    var model: RestaurantIdentifier?
    
    func configureWithModel(_: RestaurantIdentifier) {
        guard let restaurantIdentifier = model else { return }
        self.firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier, completion: { (menu) in
            menu.forEach { (menu) in
                self.firebaseManager.fetchFood(restaurantIdentifier: restaurantIdentifier, menu: menu) { (internalMenu) in
                    self.internalMenus.append(internalMenu)
                    self.restaurantHeaderView.model = restaurantIdentifier
                    self.restaurantHeaderView.configureWithModel(restaurantIdentifier)
                    self.tableView.tableHeaderView = self.restaurantHeaderView
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    private var internalMenus = [InternalMenu]()
    
    private var isSearching = false
    
    private let firebaseManager = FirebaseManager()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardAppears), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
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
        tableView.bounces = false
        return tableView
    }()
    
    private let restaurantHeaderView: RestaurantDetailView = {
        let view = RestaurantDetailView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        let reviewsRightBarButtonItem = UIBarButtonItem(title: "Reviews", style: .plain, target: self, action: #selector(reviewsRightBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = reviewsRightBarButtonItem
        self.navigationItem.searchController = self.searchController
        
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
    
    @objc internal func priceButtonTapped(sender: CustomButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.row, section: sender.section)) as! RestaurantEndUserDetailFoodCell
        let popTip = PopTip()
        popTip.show(text: "Some Information", direction: .left, maxWidth: 200, in: cell, from: sender.frame)
    }
    
    @objc private func keyboardAppears() -> Void {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    @objc private func reviewsRightBarButtonItemTapped() {
        let reviewsViewController = ReviewsViewController()
        reviewsViewController.restaurantIdentifier = self.model
        self.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
}

extension RestaurantEndUserDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.internalMenus.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.internalMenus[section].foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RestaurantEndUserDetailFoodCell.self, forIndexPath: indexPath)
        
        cell.restaurantEndUserDetailViewController = self
        cell.priceButton.row = indexPath.row
        cell.priceButton.section = indexPath.section
        
        cell.dataSource = self.internalMenus[indexPath.section].foods[indexPath.row]
        
        return cell
    }
}

extension RestaurantEndUserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SectionHeaderView()
        
        view.text = self.internalMenus[section].menu.title
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

extension RestaurantEndUserDetailViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        let restaurantEndUserDetailSearchViewController = RestaurantEndUserDetailSearchViewController()
        restaurantEndUserDetailSearchViewController.internalMenus = self.internalMenus
        
        let navController = UINavigationController(rootViewController: restaurantEndUserDetailSearchViewController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension RestaurantEndUserDetailViewController: BaseRestaurantDetailViewControllerDelegate {
    
    func baseRestaurantDetailViewController(_ baseRestaurantDetailViewController: BaseRestaurantDetailViewController, didSet restaurant: RestaurantIdentifier, menus: [Menu]) {
        menus.forEach { (menu) in
            self.firebaseManager.fetchFood(restaurantIdentifier: restaurant, menu: menu) { (internalMenu) in
                self.internalMenus.append(internalMenu)
                self.tableView.reloadData()
            }
        }
    }
}


