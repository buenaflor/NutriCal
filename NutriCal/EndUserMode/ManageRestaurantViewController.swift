//
//  AddRestaurantViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ManageRestaurantsViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.title = "Your Restaurants"
         
        let addRestaurantBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(addRestaurantBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = addRestaurantBarButtonItem
        
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
        self.navigationController?.pushViewController(addRestaurantsViewController, animated: true)
    }
}

extension ManageRestaurantsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        return cell
    }
}

extension ManageRestaurantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}
