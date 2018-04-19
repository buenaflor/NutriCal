//
//  TestTableViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 19.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

enum ServiceResponse<T> {
    case success(T)
    case failure(Error)
}

enum ApiPath: CustomStringConvertible {
    case books
    case categories
    case booksForCategory(String)
    
    var description: String {
        switch self {
        case .books:
            return "books/allBooks"
        case .categories:
            return "books/categories"
        case .booksForCategory(let categoryId):
            return "books/categories/\(categoryId)"
        }
    }
}


class MyModelCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
