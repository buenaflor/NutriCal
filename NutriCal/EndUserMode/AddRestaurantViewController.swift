//
//  AddRestaurantViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 03.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import CoreLocation

class AddRestaurantsViewController: UIViewController {
    
    private let validateAddressButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(validateAddressButtonTapped(sender:)), for: .touchUpInside)
        button.setTitle("Validate Address", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let addRestarauntButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addRestaurantButtonTapped(sender:)), for: .touchUpInside)
        button.setTitle("Add Restaurant", for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        return button
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        return textField
    }()
    
    private lazy var streetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Street"
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        return textField
    }()
    
    private lazy var postalCodeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "PostalCode"
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        return textField
    }()
    
    private lazy var cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "City"
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: streetTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: postalCodeTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: streetTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: cityTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: postalCodeTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: addRestarauntButton) { (v, p) in [
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.widthAnchor.constraint(equalToConstant: 140),
            v.heightAnchor.constraint(equalToConstant: 50),
            v.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10)
            ]}
        
        self.view.add(subview: validateAddressButton) { (v, p) in [
            v.trailingAnchor.constraint(equalTo: addRestarauntButton.leadingAnchor, constant: -20),
            v.widthAnchor.constraint(equalToConstant: 140),
            v.heightAnchor.constraint(equalToConstant: 50),
            v.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10)
            ]}
    }
    
    @objc private func addRestaurantButtonTapped(sender: UIButton) {
        print("hey")
    }

    @objc private func validateAddressButtonTapped(sender: UIButton) {
        
        guard
            let street = streetTextField.text,
            let postalCode = postalCodeTextField.text,
            let city = cityTextField.text
            else { return }
        
        let address = "\(street), \(postalCode) \(city)"
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("not location found")
                    return
            }
            
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
        }
    }
}

extension AddRestaurantsViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.addRestarauntButton.isEnabled = false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
