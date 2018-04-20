//
//  AddRestaurantViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 03.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import CoreLocation

import SwiftSpinner

protocol AddRestaurantsViewControllerDelegate: class {
    func addRestaurantsViewController(_ addRestaurantsViewController: AddRestaurantsViewController, didAdd restaurantName: String)
}

class AddRestaurantsViewController: UIViewController {
    
    weak var delegate: AddRestaurantsViewControllerDelegate?
    
    private var imageFilePath: String?
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        return imagePicker
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Futura", size: 16.0)
        label.text = "You are about to add a new Restaurant. Before you can add a restaurant, you have to validate the address, so we can correctly place it in the user's map. After adding your restaurant, it is going to be reviewed for security reasons."
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let validateAddressButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(validateAddressButtonTapped(sender:)), for: .touchUpInside)
        button.setTitle("Validate Address", for: .normal)
        button.backgroundColor = .lightGray
        return button
    }()
    
    private let addRestaurantButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(addRestaurantButtonTapped(sender:)), for: .touchUpInside)
        button.setTitle("Add Restaurant", for: .normal)
        button.backgroundColor = UIColor.StandardMode.NotEnabled
        button.isEnabled = false
        return button
    }()
    
    private lazy var titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Restaurant Name"
        textField.delegate = self
        textField.backgroundColor = .white
        textField.customizeSeparatorLine(color: UIColor.StandardMode.TabBarColor)
        return textField
    }()
    
    private lazy var streetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Street"
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        return textField
    }()
    
    private lazy var cuisineTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Cuisine/Genre"
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
    
    private let channelImagePickerButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "camera").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.StandardMode.TabBarColor
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleChooseChannelImage), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        // Dummy Data
        self.titleTextField.text = "My Restaurant"
        self.streetTextField.text = "Langobardenstraße 176"
        self.postalCodeTextField.text = "1220"
        self.cityTextField.text = "Wien"

        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: descriptionLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 24),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -24)
            ]}
        
        self.view.add(subview: channelImagePickerButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            v.widthAnchor.constraint(equalToConstant: 70),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 24),
            v.heightAnchor.constraint(equalToConstant: 70)
            ]}
        
        self.view.add(subview: titleTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: channelImagePickerButton.trailingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: cuisineTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        self.view.add(subview: streetTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: cuisineTextField.bottomAnchor, constant: 30),
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

        self.view.add(subview: addRestaurantButton) { (v, p) in [
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.widthAnchor.constraint(equalToConstant: 140),
            v.heightAnchor.constraint(equalToConstant: 50),
            v.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10)
            ]}

        self.view.add(subview: validateAddressButton) { (v, p) in [
            v.trailingAnchor.constraint(equalTo: addRestaurantButton.leadingAnchor, constant: -20),
            v.widthAnchor.constraint(equalToConstant: 140),
            v.heightAnchor.constraint(equalToConstant: 50),
            v.topAnchor.constraint(equalTo: cityTextField.bottomAnchor, constant: 10)
            ]}
        
        self.view.layoutIfNeeded()
        self.channelImagePickerButton.layer.cornerRadius = channelImagePickerButton.frame.height / 2
    }
    
    @objc private func addRestaurantButtonTapped(sender: UIButton) {
        
        guard
            let name = titleTextField.text,
            let street = streetTextField.text,
            let postalCode = postalCodeTextField.text,
            let city = cityTextField.text,
            let cuisine = cuisineTextField.text,
            let imgFilePathString = imageFilePath
            else { return }
        
        SwiftSpinner.show("Adding Restaurant: \(name)")
        
        let manager = FirebaseManager()
        manager.addRestaurantToCurrentUser(with: name, street: street, postalCode: postalCode, city: city, filePath: imgFilePathString, cuisine: cuisine, completion: {
            
            SwiftSpinner.hide()
            
            self.navigationController?.popViewController(animated: true)
            self.delegate?.addRestaurantsViewController(self, didAdd: name)
        })
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
                    let alertController = UIAlertController(title: "Error", message: "Your address is not valid.", preferredStyle: .alert)
                    
                    alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                    
                    
                    self.present(alertController, animated: true, completion: nil)
                    return
            }
            
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            
            let alertController = UIAlertController(title: "Valid", message: "Your address is valid. You can now add your restaurant.", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                self.addRestaurantButton.backgroundColor = .lightGray
                self.addRestaurantButton.isEnabled = true
            }))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func handleChooseChannelImage() {
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension AddRestaurantsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else { return }
        channelImagePickerButton.setImage(pickedImage, for: .normal)
        
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            
            imageFilePath = localPath
        }
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddRestaurantsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.addRestaurantButton.backgroundColor = UIColor.StandardMode.NotEnabled
        self.addRestaurantButton.isEnabled = false
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
