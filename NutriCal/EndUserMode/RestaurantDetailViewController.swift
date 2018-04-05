//
//  RestaurantDetailViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner

class RestaurantDetailViewController: BaseImagePickerViewController {
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            
            SwiftSpinner.show("Loading Data")
            
            guard let restaurantIdentifier = restaurantIdentifier else { return }
            guard let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
            
            self.firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier, completion: { (internalMenus, hasMenu) in
                if hasMenu {
                    guard let internalMenus = internalMenus else { return }
                    self.menus = internalMenus
                    self.setupCountLabelText(for: self.menuCountLabel, count: self.menus.count, searchString: "Menus")
                    self.tableView.reloadData()
                    SwiftSpinner.hide()
                }
                else {
                    SwiftSpinner.hide()
                }
            })
            
            
            self.imagePickerButton.sd_setImage(with: imgURL, for: .normal)
            self.setupCountLabelText(for: reviewsCountLabel, count: 0, searchString: "Reviews")
            self.setupCountLabelText(for: menuCountLabel, count: self.menus.count, searchString: "Menus")
            self.ratingLabel.text = "Avg. Rating: 4.3"
            
            self.nameLabel.text = restaurantIdentifier.restaurant.name
            
            let street = restaurantIdentifier.restaurant.street
            let postalCode = restaurantIdentifier.restaurant.postalCode
            let city = restaurantIdentifier.restaurant.city
            self.addressLabel.text = "\(street), \(postalCode) \(city)"
        }
    }
    
    let firebaseManager = FirebaseManager()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private let menuCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let reviewsCountLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .lightGray
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 22.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 19.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let addMenuButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(addMenuButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addMenuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 20.0)
        label.numberOfLines = 1
        label.text = "Add Menu"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    private var menus = [InternalMenu]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.imagePickerButton.addTarget(self, action: #selector(imagePickerButtonTapped), for: .touchUpInside)
        
        self.configureConstraints()
    }
    
    private func setupCountLabelText(for label: UILabel, count: Int, searchString: String) {
        let labelString = "\(count)\n\(searchString)"
        
        let wholeRange = (labelString as NSString).range(of: labelString)
        let range = (labelString as NSString).range(of: searchString)
        
        let attributedText = NSMutableAttributedString.init(string: labelString)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.lightGray, range: range)
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 22), range: wholeRange)
        label.attributedText = attributedText
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: imagePickerButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.26),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.26)
            ]}
        
        self.view.add(subview: menuCountLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 35),
            v.leadingAnchor.constraint(equalTo: imagePickerButton.trailingAnchor, constant: 40),
            ]}
        
        self.view.add(subview: reviewsCountLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 35),
            v.leadingAnchor.constraint(equalTo: menuCountLabel.trailingAnchor, constant: 45),
            ]}

        self.view.add(subview: stackView) { (v, p) in [
            v.topAnchor.constraint(equalTo: menuCountLabel.bottomAnchor, constant: 15),
            v.widthAnchor.constraint(equalToConstant: 100),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 20)
            ]}
        
        self.view.add(subview: ratingLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: menuCountLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: imagePickerButton.trailingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: stackView.leadingAnchor)
            ]}
        
        self.view.add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        self.view.add(subview: addressLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25)
            ]}
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.StandardMode.TabBarColor
        
        self.view.add(subview: separatorLine) { (v, p) in [
            v.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
        
        self.view.add(subview: addMenuButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.widthAnchor.constraint(equalToConstant: 45),
            v.heightAnchor.constraint(equalToConstant: 45)
            ]}
        
        self.view.add(subview: addMenuLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 32),
            v.leadingAnchor.constraint(equalTo: addMenuButton.trailingAnchor, constant: 15)
            ]}
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: addMenuLabel.bottomAnchor, constant: 35),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
        
        self.addStackViewItems()
        
        self.view.layoutIfNeeded()
        self.imagePickerButton.layer.cornerRadius = self.imagePickerButton.frame.size.height / 2
    }
    
    private func addStackViewItems() {
        stackView.backgroundColor = UIColor.blue
        let a = UIImageView()
        a.image = #imageLiteral(resourceName: "star-full").withRenderingMode(.alwaysTemplate)
        a.tintColor = #colorLiteral(red: 1, green: 0.955950182, blue: 0.2057999463, alpha: 1)
        a.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let b = UIImageView()
        b.image = #imageLiteral(resourceName: "star-full").withRenderingMode(.alwaysTemplate)
        b.tintColor = #colorLiteral(red: 1, green: 0.955950182, blue: 0.2057999463, alpha: 1)
        b.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let c = UIImageView()
        c.image = #imageLiteral(resourceName: "star-full").withRenderingMode(.alwaysTemplate)
        c.tintColor = #colorLiteral(red: 1, green: 0.955950182, blue: 0.2057999463, alpha: 1)
        c.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let d = UIImageView()
        d.image = #imageLiteral(resourceName: "star-full").withRenderingMode(.alwaysTemplate)
        d.tintColor = #colorLiteral(red: 1, green: 0.955950182, blue: 0.2057999463, alpha: 1)
        d.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        let e = UIImageView()
        e.image = #imageLiteral(resourceName: "star-full").withRenderingMode(.alwaysTemplate)
        e.tintColor = #colorLiteral(red: 1, green: 0.955950182, blue: 0.2057999463, alpha: 1)
        e.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        stackView.addArrangedSubview(a)
        stackView.addArrangedSubview(b)
        stackView.addArrangedSubview(c)
        stackView.addArrangedSubview(d)
        stackView.addArrangedSubview(e)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
    }
    
    @objc private func imagePickerButtonTapped() {
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc private func addMenuButtonTapped() {
        
        guard let restaurantIdentifier = restaurantIdentifier else { return }
        
        let addRestaurantMenuViewController = AddRestaurantMenuViewController()
        addRestaurantMenuViewController.delegate = self
        addRestaurantMenuViewController.restaurantIdentifier = restaurantIdentifier
        
        self.navigationController?.pushViewController(addRestaurantMenuViewController, animated: true)
    }
}

extension RestaurantDetailViewController: AddRestaurantMenuViewControllerDelegate {
    
    func addRestaurantMenuViewController(_ addRestaurantMenuViewController: AddRestaurantMenuViewController, didReceive menu: InternalMenu) {
        self.menus.append(menu)
        self.tableView.reloadData()
    }
}

extension RestaurantDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = menus[indexPath.row].menu.title
        
        return cell
    }
}

extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
