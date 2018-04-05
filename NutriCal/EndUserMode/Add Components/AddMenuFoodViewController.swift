//
//  AddMenuFoodViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 04.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol AddMenuFoodViewControllerDelegate: class {
    func addMenuFoodViewController(_ addMenuFoodViewControllerDelegate: AddMenuFoodViewController, didReceive food: Food, image: UIImage)
}

class AddMenuFoodViewController: BaseImagePickerViewController {
    
    weak var delegate: AddMenuFoodViewControllerDelegate?
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.addSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private lazy var priceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Price"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.addSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private lazy var kCalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Total kCal"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.addSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private let addIngredientsButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .gray
        button.addTarget(self, action: #selector(addIngredientsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let addMenuLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 1
        label.text = "Add Ingredients"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    private var ingredients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.setupImagePickerButton()
        self.setupNavigationItem()
        self.configureConstraints()
    }
    
    private func setupNavigationItem() {
        let confirmRightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkmark"), style: .plain, target: self, action: #selector(confirmRightBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = confirmRightBarButtonItem
    }
    
    private func setupImagePickerButton() {
        self.imagePickerButton.backgroundColor = .white
        self.imagePickerButton.addTarget(self, action: #selector(imagePickerButtonTapped), for: .touchUpInside)
        self.imagePickerButton.setTitle("Choose Image for Food", for: .normal)
        self.imagePickerButton.setTitleColor(.gray, for: .normal)
        self.imagePickerButton.layer.borderWidth = 1
        self.imagePickerButton.layer.borderColor = UIColor.lightGray.cgColor
        self.imagePickerButton.imageView?.contentMode = .scaleAspectFill
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: imagePickerButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.2)
            ]}
        
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: priceTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: kCalTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: priceTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: addIngredientsButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: kCalTextField.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.widthAnchor.constraint(equalToConstant: 37),
            v.heightAnchor.constraint(equalToConstant: 37)
            ]}
        
        self.view.add(subview: addMenuLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: kCalTextField.bottomAnchor, constant: 32),
            v.leadingAnchor.constraint(equalTo: addIngredientsButton.trailingAnchor, constant: 15)
            ]}

        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: addMenuLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
        
    }
    
    @objc private func addIngredientsButtonTapped() {
        let addIngredientsViewController = AddIngredientsViewController()
        addIngredientsViewController.delegate = self
        let navController = UINavigationController(rootViewController: addIngredientsViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func confirmRightBarButtonItemTapped() {
        
        guard let kCal = Int(kCalTextField.text!), let price = Double(priceTextField.text!), let name = titleTextField.text, let imageFilePath = self.imageFilePath, let image = imagePickerButton.imageView?.image else { return }
        
        let food = Food(name: name, isVegan: true, ingredients: self.ingredients, kCal: kCal, price: price, imageLink: imageFilePath)
        self.delegate?.addMenuFoodViewController(self, didReceive: food, image: image)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @objc private func imagePickerButtonTapped() {
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
}

extension AddMenuFoodViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell
    }
}

extension AddMenuFoodViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddMenuFoodViewController: AddIngredientsViewControllerDelegate {
    func addIngredientsViewController(_ addIngredientsViewController: AddIngredientsViewController, didReceive ingredients: [String]) {
        self.ingredients = ingredients
        self.tableView.reloadData()
    }
}

extension AddMenuFoodViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
