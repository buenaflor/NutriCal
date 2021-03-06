//
//  Restaurant.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}

struct RestaurantIdentifier {
    let restaurant: Restaurant
    let documentIdentifier: String
}

extension RestaurantIdentifier {
    var address: String {
        let city = self.restaurant.city
        let postalCode = self.restaurant.postalCode
        let street = self.restaurant.street
        return "\(street), \(postalCode) \(city)"
    }
}

struct Restaurant {
    let name: String
    let street: String
    let postalCode: String
    let city: String
    let confirmation: String
    let imageFilePath: String
    let cuisine: String

    var dictionary: [String: Any]  {
        return [
            "name": name,
            "city": city,
            "street": street,
            "postalCode": postalCode,
            "confirmation": confirmation,
            "imageFilePath": imageFilePath,
            "cuisine": cuisine
        ]
    }
}

struct MenuIdentifier {
    let menu: Menu
    let documentIdentifier: String
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
    let name: String
    let description: String
    let isVegan: Bool
    let ingredients: [String]
    let kCal: Int
    let price: Double
    let imageLink: String
    
    var dictionary: [String: Any]  {
        return [
            "name": name,
            "isVegan": isVegan,
            "description": description,
            "ingredients": ingredients,
            "kCal": kCal,
            "price": price,
            "imageLink": imageLink
        ]
    }
}

extension Restaurant: DocumentSerializable {
    init?(dictionary: [String : Any]) {
        guard
            let name = dictionary["name"] as? String,
            let street = dictionary["street"] as? String,
            let postalCode = dictionary["postalCode"] as? String,
            let city = dictionary["city"] as? String,
            let confirmation = dictionary["confirmation"] as? String,
            let imageFilePath = dictionary["imageFilePath"] as? String,
            let cuisine = dictionary["cuisine"] as? String
            else { return nil }
        
        self.init(name: name, street: street, postalCode: postalCode, city: city, confirmation: confirmation, imageFilePath: imageFilePath, cuisine: cuisine)
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
            let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String,
            let isVegan = dictionary["isVegan"] as? Bool,
            let ingredients = dictionary["ingredients"] as? [String],
            let kCal = dictionary["kCal"] as? Int,
            let price = dictionary["price"] as? Double,
            let imageLink = dictionary["imageLink"] as? String
        else { return nil }
        
        self.init(name: name, description: description, isVegan: isVegan, ingredients: ingredients, kCal: kCal, price: price, imageLink: imageLink)
    }
    
    
}
