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
    let foods: [Food]
}

struct InternalRestaurant {
    let restaurant: Restaurant
    let internalMenu: [InternalMenu]
}

