//
//  RestaurantDetailViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SwiftSpinner

class RestaurantOwnerDetailViewController: BaseRestaurantDetailViewController {
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.delegate = self
        
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
        self.view.add(subview: separatorLine) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.addressLabel.bottomAnchor, constant: 20),
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
        
        self.view.layoutIfNeeded()
        self.imagePickerButton.layer.cornerRadius = self.imagePickerButton.frame.size.height / 2
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

extension RestaurantOwnerDetailViewController: BaseRestaurantDetailViewControllerDelegate {
    func baseRestaurantDetailViewController(_ baseRestaurantDetailViewController: BaseRestaurantDetailViewController, didSet restaurant: RestaurantIdentifier, menus: [Menu]) {
        print(menus.count)
        self.tableView.reloadData()
    }
}

extension RestaurantOwnerDetailViewController: AddRestaurantMenuViewControllerDelegate {
    
    func addRestaurantMenuViewController(_ addRestaurantMenuViewController: AddRestaurantMenuViewController, didReceive menu: Menu) {
        self.menus.append(menu)
        self.tableView.reloadData()
    }
}

extension RestaurantOwnerDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.menus[indexPath.row].title
        
        return cell
    }
}

extension RestaurantOwnerDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
