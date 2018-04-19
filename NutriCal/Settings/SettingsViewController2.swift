//
//  SettingsViewController2.swift
//  NutriCal
//
//  Created by Giancarlo on 18.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

// MARK: - Cells

class SettingsCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.font = UIFont(name: "DINPro-Black", size: 15.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DisclosureCell: SettingsCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Protocol Structure

protocol SettingsItem {
    var cellType: SettingsCell.Type { get }
    func configure(cell: SettingsCell)
    func didSelect(vc: SettingsViewController2)
}

struct SettingsSection {
    var title: String?
    var items: [SettingsItem]
    var footer: String?
}


// MARK: - Cell Items

struct ResetFavouritesItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return SettingsCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.textLabel?.text = "Reset Favourites"
    }
    
    func didSelect(vc: SettingsViewController2) {
        let firebaseManager = FirebaseManager()
        
        let alertController = UIAlertController(title: "Delete", message: "Would you like to delete all favourites?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Delete All", style: .default, handler: { _ in
            firebaseManager.fetchFavourites2 { (restaurantIDs) in
                firebaseManager.fetchRestaurantsWith(restaurantIDs: restaurantIDs, completion: { (restaurantIdentifiers) in
                    firebaseManager.deleteFavourites(restaurantIdentifiers: restaurantIdentifiers, completion: {
                        let alertController = UIAlertController(title: "Success", message: "Successfully deleted all favourites", preferredStyle: .alert)
                        
                        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                        
                        vc.present(alertController, animated: true, completion: nil)
                    })
                })
            }
        }))
        
        vc.present(alertController, animated: true, completion: nil)
    }
}

struct TutorialItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return SettingsCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.textLabel?.text = "App Tutorial"
    }
    
    func didSelect(vc: SettingsViewController2) {
        let onBoardingViewController = OnBoardingViewController()
        let navController = UINavigationController(rootViewController: onBoardingViewController)
        vc.present(navController, animated: true, completion: nil)
    }
}

struct ThemeItem: SettingsItem {
    var cellType: SettingsCell.Type {
        return DisclosureCell.self
    }
    
    func configure(cell: SettingsCell) {
        cell.textLabel?.text = "Choose Theme"
    }
    
    func didSelect(vc: SettingsViewController2) {
        let themesViewController = ThemesViewController()
        let navController = UINavigationController(rootViewController: themesViewController)
        vc.present(navController, animated: true, completion: nil)
    }
}


// MARK: - Settings View Controller

class SettingsViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var model = [SettingsSection]()
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.fillToSuperview(tableView)
        
        updateView()
    }
    
    func updateView() {
        let generalSection = SettingsSection(title: "General", items: [ ThemeItem(), TutorialItem() ], footer: nil)
        let resetSection = SettingsSection(title: "Reset", items: [ ResetFavouritesItem() ], footer: nil)
        
        model = [ generalSection, resetSection ]
        
        for section in model {
            for item in section.items {
                tableView.register(item.cellType, forCellReuseIdentifier: item.cellType.defaultReuseIdentifier)
            }
        }
        
        tableView.reloadData()
    }
    
    func itemAt(indexPath: IndexPath) -> SettingsItem {
        return model[indexPath.section].items[indexPath.row]
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return model[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: item.cellType.defaultReuseIdentifier, for: indexPath) as! SettingsCell
        
        item.configure(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemAt(indexPath: indexPath).didSelect(vc: self)
    }
}
