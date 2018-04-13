//
//  SideMenuViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SideMenu
import Firebase
import SwiftSpinner

enum SideMenuType: String {
    case login = "Login"
    case filter = "Filter"
    case manageRestaurant = "Manage Restaurant"
    case signout = "Sign Out"
    case settings = "Settings"
    case favourites = "Favourites"
    case none
}

enum FilterOption {
    case price
    case kCal
    case protein
    case carbs
    case fats
    case location
    case rating
    case cuisine
}

struct SideMenuHeader {
    let name: String
}

struct SideMenuOption {
    let type: SideMenuType
    let image: UIImage
}

protocol SideMenuHeaderViewDelegate: class {
    func sideMenuHeaderView(_ sideMenuHeaderView: UIView, didClick button: UIButton)
}

class SideMenuHeaderView: UIView {
    
    weak var delegate: SideMenuHeaderViewDelegate?
    
    internal let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    internal let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(backButtonTapped(sender:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.StandardMode.SideMenuHeaderView
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.add(subview: self.nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        self.add(subview: backButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -10),
            v.widthAnchor.constraint(equalToConstant: 100),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 10),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
    }
    
    @objc private func backButtonTapped(sender: UIButton) {
        self.delegate?.sideMenuHeaderView(self, didClick: sender)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol SideMenuViewControllerDelegate: class {
    func sideMenuViewController(_ sideMenuViewController: SideMenuViewController, didChange slider: UISlider, filterOption: FilterOption)
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    let firebaseManager = FirebaseManager()
    
    var filterOption: FilterOption?
    
    private lazy var sideMenuHeaderView: SideMenuHeaderView = {
        let view = SideMenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.25))
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.alwaysBounceVertical = false
        tableView.register(SideMenuCell.self)
        tableView.register(FilterCell.self)
        sideMenuHeaderView.delegate = self
        sideMenuHeaderView.backButton.isHidden = true
        tableView.tableHeaderView = sideMenuHeaderView
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private var sideMenuOptions = [SideMenuOption]()
    private var filteredSideMenuOptions = [SideMenuOption]()
    private var filterOptions = [FilterOption.carbs, FilterOption.fats, FilterOption.kCal, FilterOption.location, FilterOption.price, FilterOption.protein, FilterOption.rating]
    private var currentOption: SideMenuType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.populateSideMenu()
        self.refreshTableView()
    }
    
    private func populateSideMenu() {
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.login, image: #imageLiteral(resourceName: "login").withRenderingMode(.alwaysTemplate)))
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.manageRestaurant, image: #imageLiteral(resourceName: "manage").withRenderingMode(.alwaysTemplate)))
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.filter, image: #imageLiteral(resourceName: "slider").withRenderingMode(.alwaysTemplate)))
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.favourites, image: #imageLiteral(resourceName: "heart").withRenderingMode(.alwaysTemplate)))
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.settings, image: #imageLiteral(resourceName: "settings").withRenderingMode(.alwaysTemplate)))
        self.sideMenuOptions.append(SideMenuOption(type: SideMenuType.signout, image: #imageLiteral(resourceName: "signout").withRenderingMode(.alwaysTemplate)))
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
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
    
    @objc private func submitButtonTapped() {
        let loginRestaurantViewController = LoginRestaurantViewController()
        let navController = UINavigationController(rootViewController: loginRestaurantViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    func refreshTableView() {
        
        self.firebaseManager.fetchRole { (isRestaurantOwner) in
            print("Is restaurant logged in: \(isRestaurantOwner)")
            
            if !isRestaurantOwner {
                self.filteredSideMenuOptions = self.sideMenuOptions.filter({
                    $0.type != SideMenuType.manageRestaurant
                })
            }
            else {
                self.filteredSideMenuOptions = self.sideMenuOptions
            }
            
            if Auth.auth().currentUser?.email == nil {
                self.filteredSideMenuOptions = self.filteredSideMenuOptions.filter({
                    $0.type != SideMenuType.signout
                })
                self.sideMenuHeaderView.nameLabel.text = "Login to access more features"
                print("email is nil")

            }
            else {
                self.filteredSideMenuOptions = self.filteredSideMenuOptions.filter({
                    $0.type != SideMenuType.login
                })
                self.sideMenuHeaderView.nameLabel.text = "Welcome, \(Auth.auth().currentUser?.email ?? "Name not available")"
                print("user is logged in")
            }
            
            self.tableView.reloadData()
        }
    }
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentOption == .filter {
            return self.filterOptions.count
        }
        else {
            return self.filteredSideMenuOptions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentOption == .filter {
            let cell = tableView.dequeueReusableCell(FilterCell.self, forIndexPath: indexPath)
            
            cell.filterOption = filterOptions[indexPath.row]
            cell.delegate = self
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(SideMenuCell.self, forIndexPath: indexPath)
            
            cell.customTextLabel.text = filteredSideMenuOptions[indexPath.row].type.rawValue
            cell.customImageView.image = filteredSideMenuOptions[indexPath.row].image
            
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.08
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentOption != .filter {
            switch filteredSideMenuOptions[indexPath.row].type {
                
            case SideMenuType.login:
                let loginViewController = LoginViewController()
                loginViewController.delegate = self
                self.navigationController?.pushViewController(loginViewController, animated: true)
                
            case SideMenuType.filter:
                self.currentOption = .filter
                sideMenuHeaderView.backButton.isHidden = false
                tableView.reloadData()
                
            case SideMenuType.manageRestaurant:
                let manageRestaurantsViewController = ManageRestaurantsViewController()
                let navController = UINavigationController(rootViewController: manageRestaurantsViewController)
                self.present(navController, animated: true, completion: nil)
                
            case SideMenuType.signout:
                let alertController = UIAlertController(title: "Log Out", message: "You are about to log out. Are you sure?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Log Out", style: .default, handler: { _ in
                    try! Auth.auth().signOut()
                    self.refreshTableView()
                    self.dismiss(animated: true, completion: nil)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
                
            case SideMenuType.settings:
                let settingsViewController = SettingsViewController()
                self.navigationController?.pushViewController(settingsViewController, animated: true)
                
            case SideMenuType.favourites:
                let favouritesViewController = FavouritesViewController()
                self.navigationController?.pushViewController(favouritesViewController, animated: true)
                
            default:
                break;
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SideMenuViewController: FilterCellDelegate {
    func filterCell(_ filterCell: FilterCell, didChange slider: UISlider, filterOption: FilterOption) {
        self.delegate?.sideMenuViewController(self, didChange: slider, filterOption: filterOption)
    }
}

extension SideMenuViewController: SideMenuHeaderViewDelegate {
    func sideMenuHeaderView(_ sideMenuHeaderView: UIView, didClick button: UIButton) {
        self.currentOption = .none
        self.sideMenuHeaderView.backButton.isHidden = true
        self.tableView.reloadData()
    }
}

extension SideMenuViewController: LoginViewControllerDelegate {
    func loginViewControllerLoggedIn(_ loginViewController: LoginViewController) {
        
        self.refreshTableView()
        
        // getting event click from signing in, update UI
        print("logged in bruh")
    }
    
    
}
