//
//  Review.swift
//  NutriCal
//
//  Created by Giancarlo on 11.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation

struct Review {
    let username: String
    let rating: Int
    let comment: String
    let date: String
    
    var dictionary: [String: Any]  {
        return [
            "username": username,
            "rating": rating,
            "comment": comment,
            "date": date
        ]
    }
}

struct ReviewIdentifier {
    let review: Review
    let documentIdentifier: String
}

extension Review: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let username = dictionary["username"] as? String,
            let rating = dictionary["rating"] as? Int,
            let comment = dictionary["comment"] as? String,
            let date = dictionary["date"] as? String
        else { return nil }
        
        self.init(username: username, rating: rating, comment: comment, date: date)
    }
}
