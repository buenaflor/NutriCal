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

enum SideMenuOptions: String {
    case loginAsRestaurant
    case loginAsUser
    case filter
    case manageRestaurant
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
}

struct SideMenuHeader {
    let name: String
}

protocol SideMenuHeaderViewDelegate: class {
    func sideMenuHeaderView(_ sideMenuHeaderView: UIView, didClick button: UIButton)
}

class SideMenuHeaderView: UIView {
    
    weak var delegate: SideMenuHeaderViewDelegate?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 20)
        if let name = Auth.auth().currentUser  {
            label.text = "Welcome, \(Auth.auth().currentUser?.email ?? "Name not available")"
        }
        else {
            label.text = "Login to access more features"
        }
        return label
    }()
    
    internal lazy var backButton: UIButton = {
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
        sideMenuHeaderView.delegate = self
        sideMenuHeaderView.backButton.isHidden = true
        tableView.tableHeaderView = sideMenuHeaderView
        return tableView
    }()
    
    private var sideMenuOptions = [SideMenuOptions.loginAsUser, SideMenuOptions.loginAsRestaurant, SideMenuOptions.filter, SideMenuOptions.manageRestaurant]
    private var filterOptions = [FilterOption.carbs, FilterOption.fats, FilterOption.kCal, FilterOption.location, FilterOption.price, FilterOption.protein, FilterOption.rating]
    private var currentOption: SideMenuOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
        
        if currentOption == .filter {
            self.tableView.register(FilterCell.self)
        }
        else {
            self.tableView.register(SideMenuCell.self)
        }
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
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentOption == .filter {
            return self.filterOptions.count
        }
        else {
            return self.sideMenuOptions.count
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
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
            
            cell.textLabel?.text = sideMenuOptions[indexPath.row].rawValue
            
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
            switch sideMenuOptions[indexPath.row] {
            case SideMenuOptions.loginAsRestaurant:
                let loginRestaurantViewController = LoginRestaurantViewController()
                let navController = UINavigationController(rootViewController: loginRestaurantViewController)
                self.present(navController, animated: true, completion: nil)
            case SideMenuOptions.loginAsUser:
                let loginEndUserViewController = LoginEndUserViewController()
                let navController = UINavigationController(rootViewController: loginEndUserViewController)
                self.present(navController, animated: true, completion: nil)
            case SideMenuOptions.filter:
                self.currentOption = .filter
                sideMenuHeaderView.backButton.isHidden = false
                tableView.reloadData()
            case SideMenuOptions.manageRestaurant:
                let manageRestaurantsViewController = ManageRestaurantsViewController()
                let navController = UINavigationController(rootViewController: manageRestaurantsViewController)
                self.present(navController, animated: true, completion: nil)
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
