//
//  InternalRestaurant.swift
//  NutriCal
//
//  Created by Giancarlo on 05.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

struct InternalMenu {
    let menu: Menu
    var foods: [Food]
}

struct InternalRestaurant {
    let restaurant: RestaurantIdentifier
    var internalMenu: [InternalMenu]
}

