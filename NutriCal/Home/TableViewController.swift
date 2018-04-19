//
//  TableViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 18.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Foundation
import UIKit

protocol SelectionItem: Equatable {
    var text: String { get }
}

class SelectionViewController<SI: SelectionItem>: UITableViewController {
    var didSelect: ((SI) -> (Bool))?
    
    let items: [SI]
    var selectedItem: SI?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    init(items: [SI], selected: SI?=nil) {
        self.items = items
        self.selectedItem = selected
        
        super.init(style: .plain)
        
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        modalPresentationStyle = .popover
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        
        if didSelect?(item) == true {
            selectedItem = item
        }
        else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        let item = items[indexPath.row]
        
        cell.textLabel?.text = item.text

        if let selectedItem = selectedItem, item == selectedItem {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredContentSize: CGSize {
        get {
            return tableView.contentSize
        } set (newValue) {
            tableView.contentSize.width = newValue.width
        }
    }
}

