//
//  AddMenuViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import RangeSeekSlider

protocol AddRestaurantMenuViewControllerDelegate: class {
    func addRestaurantMenuViewController(_ addRestaurantMenuViewController: AddRestaurantMenuViewController, didReceive menu: InternalMenu)
}

class AddRestaurantMenuViewController: UIViewController {
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            guard let restaurantIdentifier = restaurantIdentifier else { return }
            guard let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
  
        }
    }
    
    weak var delegate: AddRestaurantMenuViewControllerDelegate?
    
    private let rangeLabel: UILabel = {
        let label = UILabel()
        label.text = "Choose a price range for your menu. Note: food should not exceed or be below price range"
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let foodLabel: UILabel = {
        let label = UILabel()
        label.text = "Your food list for this menu:"
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let rangeSlider: RangeSeekSlider = {
        let rangeSlider = RangeSeekSlider()
        rangeSlider.minValue = 0
        rangeSlider.maxValue = 30
        rangeSlider.lineHeight = 3
        rangeSlider.tintColor = .lightGray
        rangeSlider.step = 1
        rangeSlider.handleColor = UIColor.StandardMode.TabBarColor
        rangeSlider.colorBetweenHandles = UIColor.StandardMode.TabBarColor
        return rangeSlider
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Restaurant Name"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.addSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private let addFoodButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(addFoodButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()

    private var foods = [Food]()
    
    let firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        let confirmRightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkmark"), style: .plain, target: self, action: #selector(confirmRightBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = confirmRightBarButtonItem
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: rangeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 40),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
        self.view.add(subview: rangeSlider) { (v, p) in [
            v.topAnchor.constraint(equalTo: rangeLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 35),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.heightAnchor.constraint(equalToConstant: 65)
            ]}
        
        self.view.add(subview: foodLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: rangeSlider.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -20)
            ]}
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: foodLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor, constant: -10)
            ]}
        
        self.view.add(subview: addFoodButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: tableView.topAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.widthAnchor.constraint(equalToConstant: 45),
            v.heightAnchor.constraint(equalToConstant: 45)
            ]}
    }
    
    @objc private func addFoodButtonTapped() {
        let addMenuFoodViewController = AddMenuFoodViewController()
        addMenuFoodViewController.delegate = self
        self.navigationController?.pushViewController(addMenuFoodViewController, animated: true)
    }
    
    @objc private func confirmRightBarButtonItemTapped() {
        
        guard let title = titleTextField.text, let restaurantIdentifier = restaurantIdentifier else {
            print("Error")
            return
        }
//        let menu = Menu(title: title, lowerPriceRange: Double(self.rangeSlider.selectedMinValue), higherPiceRange: Double(self.rangeSlider.selectedMaxValue))
//        let internalMenu = InternalMenu(menu: menu, foods: self.foods)
//        
        let food = Food(name: "Lasagna", isVegan: false, ingredients: ["Tomato", "Potato", "Cheese"], kCal: 600, price: 12.99, imageLink: "")
        let food2 = Food(name: "Spaghetti", isVegan: false, ingredients: ["Ketchup", "Pasta", "Cheese"], kCal: 312, price: 5.99, imageLink: "")
        let foods = [food, food2]

        let menu = Menu(title: "Italian", lowerPriceRange: 3.9, higherPiceRange: 8.0)
        let internalMenu = InternalMenu(menu: menu, foods: foods)
        
        self.delegate?.addRestaurantMenuViewController(self, didReceive: internalMenu)
        self.firebaseManager.addMenuToRestaurant(internalMenu: internalMenu, restaurantIdentifier: restaurantIdentifier, completion: { })
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddRestaurantMenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.foods[indexPath.row].name
        
        return cell
    }
}

extension AddRestaurantMenuViewController: AddMenuFoodViewControllerDelegate {
    func addMenuFoodViewController(_ addMenuFoodViewControllerDelegate: AddMenuFoodViewController, didReceive food: Food, image: UIImage) {
        self.foods.append(food)
        self.tableView.reloadData()
    }
}

extension AddRestaurantMenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}

extension AddRestaurantMenuViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
