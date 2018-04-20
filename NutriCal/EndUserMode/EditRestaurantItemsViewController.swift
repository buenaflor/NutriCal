//
//  EditRestaurantItemsViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 03.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SDWebImage

class EditRestaurantItemsViewController: BaseImagePickerViewController {
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            guard let restaurantIdentifier = restaurantIdentifier else { return }
            guard let imgURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
            
//            self.restaurantImageView.sd_setImage(with: imgURL)
            self.imagePickerButton.sd_setImage(with: imgURL, for: .normal)
        }
    }

    private let changeImageLabel: UILabel = {
        let label = UILabel()
        label.text = "Change Image"
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 0
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.textColor = .lightGray
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let streetLabel: UILabel = {
        let label = UILabel()
        label.text = "Street"
        label.textColor = .lightGray
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let postalCodeLabel: UILabel = {
        let label = UILabel()
        label.text = "Postal Code"
        label.textColor = .lightGray
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 1
        return label
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.text = "City"
        label.textColor = .lightGray
        label.font = UIFont(name: "Futura", size: 18.0)
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Restaurant Name"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.customizeSeparatorLine(color: .gray)
        return textField
    }()
    
    private lazy var streetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Street"
        textField.delegate = self
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var postalCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PostalCode"
        textField.delegate = self
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City"
        textField.delegate = self
        textField.backgroundColor = .white
        return textField
    }()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    
    private let restaurantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.imagePickerButton.addTarget(self, action: #selector(imagePickerButtonTapped), for: .touchUpInside)
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: imagePickerButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 15),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.32),
            v.heightAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.32)
            ]}
        
        self.view.add(subview: changeImageLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: imagePickerButton.bottomAnchor, constant: 10),
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor)
            ]}
        
        self.view.add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: changeImageLabel.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25)
            ]}
    
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: streetLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25)
            ]}
        
        self.view.add(subview: streetTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: streetLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: postalCodeLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: streetTextField.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25)
            ]}

        self.view.add(subview: postalCodeTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: postalCodeLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: cityLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: postalCodeTextField.bottomAnchor, constant: 25),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25)
            ]}
        
        self.view.add(subview: cityTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: cityLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 25),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -25),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.addLineTo(view: titleTextField)
        self.addLineTo(view: streetTextField)
        self.addLineTo(view: postalCodeTextField)
        self.addLineTo(view: cityTextField)
        
        self.view.layoutIfNeeded()
        self.imagePickerButton.layer.cornerRadius = self.imagePickerButton.frame.size.height / 2
    }
    
    @objc private func imagePickerButtonTapped() {
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.sourceType = .photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    private func addLineTo(view: UIView) {
        let myView = UIView()
        myView.backgroundColor = UIColor.StandardMode.TabBarColor
        
        self.view.add(subview: myView) { (v, _) in [
            v.heightAnchor.constraint(equalToConstant: 0.7),
            v.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            v.topAnchor.constraint(equalTo: view.bottomAnchor)
            ]}
    }
}

extension EditRestaurantItemsViewController: UITextFieldDelegate {
    
}
