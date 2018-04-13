//
//  LoginEndUserViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 01.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

class LoginEndUserViewController: LoginBaseViewController, LoginControllerType {
    
    var roleType: Role {
        return Role.endUser
    }
    
    var loginType: LoginTypes {
        return LoginTypes.login
    }
    
    weak var customDelegate: LoginBaseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Login"
        
        self.setupRegisterTextView()
        
        let leftExitBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(leftExitBarButtonItemTapped))
        self.navigationItem.leftBarButtonItem = leftExitBarButtonItem
        
        self.delegate = self
    }
    
    private func setupRegisterTextView() {
        let registerString = "Register"
        let labelString = "You own a certified restaurant? Register now!"
        
        let wholeRange = (labelString as NSString).range(of: labelString)
        let range = (labelString as NSString).range(of: registerString)
        
        let attributedText = NSMutableAttributedString.init(string: labelString)
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.StandardMode.TabBarColor , range: range)
        attributedText.addAttribute(NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 18), range: wholeRange)
        registerTextView.attributedText = attributedText
    }
    
    @objc private func leftExitBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension LoginEndUserViewController: LoginBaseViewControllerDelegate {
    
    func loginBaseViewController(_ loginBaseViewController: LoginBaseViewController, didClickSubmit button: UIButton, with controllerType: LoginTypes, _ usernameText: String, _ passwordText: String) {
        if controllerType == LoginTypes.login {
            
            if usernameText == "" || passwordText == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
            else {
                Auth.auth().signIn(withEmail: usernameText, password: passwordText, completion: { (user, error) in
                    if error == nil {
                        let alertController = UIAlertController(title: "Success", message: "Successfully Logged In!", preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                        self.customDelegate?.loginBaseViewController(loginBaseViewController, didClickSubmit: button, with: controllerType, usernameText, passwordText)
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                    else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
        else {
            print("Error, Wrong Type")
        }
    }
    
    
}

