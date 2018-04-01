//
//  AppDelegate.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        setupUI()
        setupFireBase()
        
        return true
    }
    
    func setupFireBase() {
        
        FirebaseApp.configure()
        
//        let db = Firestore.firestore()
//
//        let food1 = Food(isVegan: true, ingredients: ["tomatoes", "lettuce", "mushrooms"], kCal: 324, price: 3.44)
//        let food2 = Food(isVegan: false, ingredients: ["hey", "lettuce", "mushrooms"], kCal: 324, price: 3.44)
//        let menu = Menu(title: "Vegan Menu", lowerPriceRange: 6.90, higherPiceRange: 12.90)
//        let restaurant = Restaurant(name: "Burgermacher", address: "Address", city: "Vienna")
//
//        var ref: DocumentReference? = nil
//        ref = db
//            .collection("restauranttest").addDocument(data: restaurant.dictionary)
//            .collection("menu").addDocument(data: menu.dictionary)
//            .collection("food").addDocument(data: food1.dictionary) {
//            error in
//
//            if let error = error {
//                print("Error adding document. Error: \(error)")
//            }
//            else {
//                print("Successful added document with ID: \(ref!.documentID)")
//            }
//        }
        
        // Get new write batch
//        let batch = db.batch()
        
        // Set the value of 'NYC'
        
//        let restaurants = db.collection("restaurants").document()
        
//        let burgermacherRestaurant = db
//            .collection("restaurants").addDocument(data: restaurant.dictionary)
//            .collection("menu").addDocument(data: menu.dictionary)
//            .collection("food").document()
//
//        let burgermacherRestaurant2 = db
//            .collection("restaurants").document("Burgermacher")
//            .collection("menu").document("New Burger Menu")
//            .collection("food").document("Noob Tomatoe Risotto")
        
//        print(Auth.auth().currentUser?.uid)
//
//
//        batch.setData(restaurant.dictionary, forDocument: restaurants)
        
//        batch.setData(food1.dictionary, forDocument: burgermacherRestaurant)
//        batch.setData(food2.dictionary, forDocument: burgermacherRestaurant2)
        
//        batch.commit() { err in
//            if let err = err {
//                print("Error writing batch \(err)")
//            } else {
//                print("Batch write succeeded.")
//            }
//        }

    }
    
    func setupUI() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let tabBarController = TabBarController()
        window?.rootViewController = tabBarController
        
        configureAppearances()
    }
    
    func configureAppearances() {
        UINavigationBar.appearance().barTintColor = UIColor.StandardMode.TabBarColor
        UINavigationBar.appearance().tintColor = .white
        
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().barTintColor = UIColor.StandardMode.TabBarColor
    }
}

