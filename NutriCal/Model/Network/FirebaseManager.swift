//
//  FirebaseManager.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

import Firebase

class FirebaseManager {
    let db = Firestore.firestore()
    
    func fetchRole(completion: @escaping (_ isRestaurantOwner: Bool) -> Void) {
        let ref = db.collection("roles")
        .whereField("role", isEqualTo: "restaurant")
        
        ref.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    if Auth.auth().currentUser?.uid == document.documentID {
                        completion(true)
                        return
                    }
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
    
    func fetchRestaurant() {
        fetchRole { (isRestaurantOwner) in
            if !isRestaurantOwner {
                print("Error - Access Denied: cannot fetch restaurants")
            }
            else {
                
            }
        }
    }
}
