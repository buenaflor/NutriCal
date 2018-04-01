//
//  Restaurant.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct Restaurant {
    let name: String
    let address: String
    let city: String
    
    var dictionary: [String: Any]  {
        return [
            "name": name,
            "city": city,
            "address": address,
        ]
    }
}

struct Menu {
    let title: String
    let lowerPriceRange: Double
    let higherPiceRange: Double
    
    var dictionary: [String: Any]  {
        return [
            "title": title,
            "lowerPriceRange": lowerPriceRange,
            "higherPriceRange": higherPiceRange,
        ]
    }
}

struct Food {
    let isVegan: Bool
    let ingredients: [String]
    let kCal: Int
    let price: Double
    
    var dictionary: [String: Any]  {
        return [
            "isVegan": isVegan,
            "ingredients": ingredients,
            "kCal": kCal,
            "price": price
        ]
    }
}

extension Restaurant: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let name = dictionary["name"] as? String,
            let address = dictionary["city"] as? String,
            let city = dictionary["address"] as? String
            else { return nil }
        
        self.init(name: name, address: address, city: city)
    }
}

extension Menu: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
        let title = dictionary["title"] as? String,
        let lowerPriceRange = dictionary["lowerPriceRange"] as? Double,
        let higherPriceRange = dictionary["higherPriceRange"] as? Double
        else { return nil }
        
        self.init(title: title, lowerPriceRange: lowerPriceRange, higherPiceRange: higherPriceRange)
    }
}

extension Food: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let isVegan = dictionary["isVegan"] as? Bool,
            let ingredients = dictionary["ingredients"] as? [String],
            let kCal = dictionary["kCal"] as? Int,
            let price = dictionary["price"] as? Double
        else { return nil }
        
        self.init(isVegan: isVegan, ingredients: ingredients, kCal: kCal, price: price)
    }
    
    
}
