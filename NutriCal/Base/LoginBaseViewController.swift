//
//  LoginBaseViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

enum LoginTypes {
    case login
    case signUp
}

protocol LoginBaseViewControllerDelegate: class {
    func loginBaseViewController(_ loginBaseViewController: LoginBaseViewController, didClickSubmit button: UIButton, with controllerType: LoginTypes, _ usernameText: String, _ passwordText: String)
}

protocol LoginControllerType {
    var roleType: Role { get }
    var loginType: LoginTypes { get }
}

// ToDo: Correctly inherit from a superclass?

class LoginBaseViewController: UIViewController {
    
    weak var delegate: LoginBaseViewControllerDelegate?
    var type: LoginTypes!
    var role: Role!
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.StandardMode.TabBarColor, for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped(sender:)), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.StandardMode.TabBarColor.cgColor
        return button
    }()
    
    private let brandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.sizeToFit()
        imageView.image = #imageLiteral(resourceName: "brandimage")
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Username"
        return label
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = "Password"
        return label
    }()
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        textField.tintColor = .white
        textField.placeholder = "Username"
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.backgroundColor = UIColor.StandardMode.TabBarColor
        textField.tintColor = .white
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        return textField
    }()
    
    private let topContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    internal var registerTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureConstraints()
        
        if let controller = self as? LoginControllerType {
            switch controller.loginType {
            case LoginTypes.login:
                self.submitButton.setTitle("Login", for: .normal)
                self.type = LoginTypes.login
                self.addSignUpComponents()
                
            case LoginTypes.signUp:
                self.submitButton.setTitle("Register", for: .normal)
                self.type = LoginTypes.signUp
            }
        }
    }
    
    private func addSignUpComponents() {
        self.view.add(subview: self.registerTextView) { (v, p) in [
            v.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            ]}
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapResponse(sender:)))
        tapGesture.numberOfTapsRequired = 1
        registerTextView.addGestureRecognizer(tapGesture)
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: self.topContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.2)
            ]}
        
        self.topContainerView.add(subview: brandImageView) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: 30)
            ]}
        
        self.view.add(subview: userNameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        self.view.add(subview: userNameTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        
        self.view.add(subview: passwordLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 50),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        self.view.add(subview: passwordTextField) { (v, p) in [
            v.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 10),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}

        self.view.add(subview: self.submitButton) { (v, p) in [
            v.topAnchor.constraint(equalTo: self.passwordTextField.bottomAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
    }
    
    @objc private func submitButtonTapped(sender: UIButton) {
        guard let usernameText = userNameTextField.text, let passwordText = passwordTextField.text else { return }
        self.delegate?.loginBaseViewController(self, didClickSubmit: sender, with: self.type, usernameText, passwordText)
    }
    
    @objc private func tapResponse(sender: UITapGestureRecognizer) {
        
        let location: CGPoint = sender.location(in: registerTextView)
        let position: CGPoint = CGPoint(x: location.x, y: location.y)
        
        guard let tapPosition: UITextPosition = registerTextView.closestPosition(to: position),
            let textRange: UITextRange = registerTextView.tokenizer.rangeEnclosingPosition(tapPosition, with: .word, inDirection: 1),
            let tappedWord: String = registerTextView.text(in: textRange)
            else { return }
        
        if tappedWord == "Register" {
            self.registerTapClicked()
        }
    }
    
    private func registerTapClicked() {
        if let controller = self as? LoginControllerType {
            switch controller.roleType {
            case Role.restaurant:
                let signUpRestaurantViewController = SignUpRestaurantViewController()
                self.navigationController?.pushViewController(signUpRestaurantViewController, animated: true)
            case Role.endUser:
                let signEndUserViewController = SignUpEndUserViewController()
                self.navigationController?.pushViewController(signEndUserViewController, animated: true)
            }
        }
    }
}

extension LoginBaseViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}
