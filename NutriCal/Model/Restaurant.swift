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

struct RestaurantIdentifier {
    let restaurant: Restaurant
    let documentIdentifier: String
}

struct Restaurant {
    let name: String
    let street: String
    let postalCode: String
    let city: String
    let confirmation: String
    let imageFilePath: String

    var dictionary: [String: Any]  {
        return [
            "name": name,
            "city": city,
            "street": street,
            "postalCode": postalCode,
            "confirmation": confirmation,
            "imageFilePath": imageFilePath
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
            let street = dictionary["street"] as? String,
            let postalCode = dictionary["postalCode"] as? String,
            let city = dictionary["city"] as? String,
            let confirmation = dictionary["confirmation"] as? String,
            let imageFilePath = dictionary["imageFilePath"] as? String
            else { return nil }
        
        self.init(name: name, street: street, postalCode: postalCode, city: city, confirmation: confirmation, imageFilePath: imageFilePath)
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
