//
//  File.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class RestaurantEndUserDetailViewController: BaseRestaurantDetailViewController {
    
    private var internalMenus = [InternalMenu]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RestaurantEnduserDetailFoodCell.self)
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
        
        self.delegate = self
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.separatorLine.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
        
        self.view.layoutIfNeeded()
        self.imagePickerButton.layer.cornerRadius = self.imagePickerButton.frame.size.height / 2
    }
}

extension RestaurantEndUserDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.internalMenus.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return internalMenus[section].foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RestaurantEnduserDetailFoodCell.self, forIndexPath: indexPath)
        
        cell.dataSource = self.internalMenus[indexPath.section].foods[indexPath.row]
        
        return cell
    }

}

extension RestaurantEndUserDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return internalMenus[section].menu.title
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.StandardMode.HomeBackground
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
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
