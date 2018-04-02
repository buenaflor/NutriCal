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
    
    func test() {
        let ref = db.collection("roles")
        .whereField("role", isEqualTo: "restaurant")
        
        ref.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
