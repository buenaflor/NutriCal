//
//  SignUpRestaurantViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

class SignUpRestaurantViewController: LoginBaseViewController, LoginControllerType {

    var roleType: Role {
        return Role.restaurant
    }
    
    var loginType: LoginTypes {
        return LoginTypes.signUp
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Register as Restaurant Owner"
        
        self.navigationController?.navigationBar.backItem?.title = "Custom Title"
        
        self.delegate = self
    }
    
    private func addRoleToDatabase(email: String, userId: String, role: String) {
        let db = Firestore.firestore()
        let batch = db.batch()
        
        let roles = db.collection("roles").document(userId)
        let user = User(email: email, role: role)
        
        let restaurants = db.collection("restaurantOwner").document(userId)
                                .collection("restaurants").document()
        
        let restaurant = Restaurant(name: "MeinR", street: "Langobardenstraße 176", postalCode: 1220, city: "Wien")
        
        batch.setData(user.dictionary, forDocument: roles)
        batch.setData(restaurant.dictionary, forDocument: restaurants)
        
        batch.commit() { err in
            if let err = err {
                print("Error writing batch \(err)")
            } else {
                print("Batch write to 'roles' succeeded.")
            }
        }
    }
}

extension SignUpRestaurantViewController: LoginBaseViewControllerDelegate {
    func loginBaseViewController(_ loginBaseViewController: LoginBaseViewController, didClickSubmit button: UIButton, with controllerType: LoginTypes, _ usernameText: String, _ passwordText: String) {
        if controllerType == LoginTypes.signUp {
            // Create Users with Firebase
            
            if usernameText == "" || passwordText == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
            }
            else {
                Auth.auth().createUser(withEmail: usernameText, password: passwordText, completion: { (user, error) in
                    if error == nil {
                        guard let email = user?.email, let uid = user?.uid else { return }
                        self.addRoleToDatabase(email: email, userId: uid, role: Role.restaurant.rawValue)
                        
                        let alertController = UIAlertController(title: "Success", message: "Successfully Signed Up!", preferredStyle: .alert)
  
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: { action in
                            self.navigationController?.popViewController(animated: true)
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
