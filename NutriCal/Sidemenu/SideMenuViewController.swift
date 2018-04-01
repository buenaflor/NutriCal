//
//  SideMenuViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SideMenu

enum SideMenuOptions: String {
    case loginAsRestaurant
    case loginAsUser
    case filter
}

class SideMenuHeaderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FilterCell: UITableViewCell {
    
    var viewController: UIViewController? {
        didSet {
            print("helloe")
            guard let vc = viewController as? SideMenuViewController else { return }
//            button.addTarget(viewController, action: #selector(vc.testing), for: .touchUpInside)
            volumeSlider.addTarget(viewController, action: #selector(vc.testing), for: .allEvents)
        }
    }
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        return slider
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Hey", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.add(subview: volumeSlider) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.8),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.heightAnchor.constraint(equalToConstant: 30)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        print("hey!")
    }
    
    @objc private func volumeSliderChanged(sender: UISlider) {
        print("changed bro")
    }
}

class SideMenuViewController: UIViewController {
    
    private lazy var sideMenuHeaderView: SideMenuHeaderView = {
        let view = SideMenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 0.25))
        view.addSeparatorLine()
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = sideMenuHeaderView
        
        return tableView
    }()
    
    private var dataSource = [SideMenuOptions.loginAsUser, SideMenuOptions.loginAsRestaurant, SideMenuOptions.filter]
    private var filters = [1, 2, 3, 4, 5]
    private var currentOption: SideMenuOptions?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton()
        button.setTitle(("Login as Restaurant"), for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.backgroundColor = .blue
        
//        self.view.add(subview: button) { (v, p) in [
//            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
//            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
//            v.widthAnchor.constraint(equalToConstant: 100),
//            v.heightAnchor.constraint(equalToConstant: 100)
//            ]}
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
        
        if currentOption == .filter {
            self.tableView.register(FilterCell.self)
        }
        else {
            self.tableView.register(UITableViewCell.self)
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
    
    @objc func testing() {
        print("hey tes")
    }
}

extension SideMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentOption == .filter {
            return self.filters.count
        }
        else {
            return self.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if currentOption == .filter {
            let cell = tableView.dequeueReusableCell(FilterCell.self, forIndexPath: indexPath)
            
            cell.viewController = self
   
            cell.backgroundColor = .red
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
            
            cell.textLabel?.text = dataSource[indexPath.row].rawValue
            cell.backgroundColor = .red
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height * 0.08
    }
}

extension SideMenuViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
        switch dataSource[indexPath.row] {
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
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
