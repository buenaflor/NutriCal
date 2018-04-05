//
//  AddIngredientsViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 05.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol AddIngredientsViewControllerDelegate: class {
    func addIngredientsViewController(_ addIngredientsViewController: AddIngredientsViewController, didReceive ingredients: [String])
}

class AddIngredientsViewController: UIViewController {
    
    weak var delegate: AddIngredientsViewControllerDelegate?
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ingredient Name"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.addSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private let addIngredientButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setImage(#imageLiteral(resourceName: "add").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        button.addTarget(self, action: #selector(addIngredientButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var ingredients = [String]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.setupNavigationItem()
        self.configureConstraints()
    }
    
    private func setupNavigationItem() {
    
        let dismissLeftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(dismissLeftBarButtonItemTapped))
        self.navigationItem.leftBarButtonItem = dismissLeftBarButtonItem
        
        let confirmRightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "checkmark"), style: .plain, target: self, action: #selector(confirmRightBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = confirmRightBarButtonItem
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: addIngredientButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -35),
            v.widthAnchor.constraint(equalToConstant: 45),
            v.heightAnchor.constraint(equalToConstant: 45)
            ]}
        
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: addIngredientButton.leadingAnchor, constant: -10),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}

    }
    
    @objc private func dismissLeftBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func addIngredientButtonTapped() {
        guard let ingredient = titleTextField.text else { return }
        self.ingredients.append(ingredient)
        self.titleTextField.text = ""
        self.tableView.reloadData()
    }
    
    @objc private func confirmRightBarButtonItemTapped() {
        self.delegate?.addIngredientsViewController(self, didReceive: self.ingredients)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddIngredientsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = ingredients[indexPath.row]
        
        return cell
    }
}

extension AddIngredientsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension AddIngredientsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
