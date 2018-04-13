//
//  LoginViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 12.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate: class {
    func loginViewControllerLoggedIn(_ loginViewController: LoginViewController)
}

class LoginViewController: UIViewController {
    
    weak var delegate: LoginViewControllerDelegate?
    
    private let restaurantButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login as Restaurant", for: .normal)
        button.backgroundColor = UIColor.StandardMode.HomeBackground
        button.addTarget(self, action: #selector(restaurantButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let userButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login as User", for: .normal)
        button.backgroundColor = UIColor.StandardMode.HomeBackground
        button.addTarget(self, action: #selector(userButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.view.add(subview: restaurantButton) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: 40),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        self.view.add(subview: userButton) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor, constant: -40),
            v.widthAnchor.constraint(equalTo: p.widthAnchor, multiplier: 0.7),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
    }
    
    @objc private func restaurantButtonTapped() {
        let loginRestaurantViewController = LoginRestaurantViewController()
        loginRestaurantViewController.customDelegate = self
        let navController = UINavigationController(rootViewController: loginRestaurantViewController)
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc private func userButtonTapped() {
        let loginEndUserViewController = LoginEndUserViewController()
        loginEndUserViewController.customDelegate = self
        let navController = UINavigationController(rootViewController: loginEndUserViewController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension LoginViewController: LoginBaseViewControllerDelegate {
    func loginBaseViewController(_ loginBaseViewController: LoginBaseViewController, didClickSubmit button: UIButton, with controllerType: LoginTypes, _ usernameText: String, _ passwordText: String) {
        self.delegate?.loginViewControllerLoggedIn(self)
    }
    
    
}

