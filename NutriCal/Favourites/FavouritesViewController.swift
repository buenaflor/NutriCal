//
//  FavouritesViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 13.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ManageRestaurantCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.title = "Favourites"
        
        let chooseFavouriteRightBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(chooseFavouriteRightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = chooseFavouriteRightBarButton
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
    }
    
    @objc private func chooseFavouriteRightBarButtonTapped() {
        let alertController = UIAlertController(title: "Favourite", message: "This is my message", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Restaurants", style: .default) { (_) in
            print("hey restaurant")
            })
            
        alertController.addAction(UIAlertAction(title: "Menus", style: .default) { (_) in
            print("hey menu")
        })
        
        alertController.addAction(UIAlertAction(title: "Food", style: .default) { (_) in
            print("hey food")
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    
        self.present(alertController, animated: true, completion: nil)
    }
}

extension FavouritesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ManageRestaurantCell.self, forIndexPath: indexPath)
        
        return cell
    }
}

extension FavouritesViewController: UITableViewDelegate {
    
}
