//
//  User.swift
//  NutriCal
//
//  Created by Giancarlo on 01.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

import FirebaseFirestore

enum Role: String {
    case endUser
    case restaurant
}

struct User {
    let email: String
    let role: String
    
    var dictionary: [String: Any]  {
        return [
            "email": email,
            "role" : role
        ]
    }
}
extension User: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let email = dictionary["email"] as? String,
            let role = dictionary["role"] as? String
            else { return nil }
        
        self.init(email: email, role: role)
    }
}

