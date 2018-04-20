//
//  ThemesViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 16.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {
    
    var themes = Theme.all
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        
        let exitLeftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(exitLeftBarButtonItemTapped))
        self.navigationItem.leftBarButtonItem = exitLeftBarButtonItem
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.fillToSuperview(tableView)
    }
    
    @objc private func exitLeftBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ThemesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        if themes[indexPath.row] == ThemeManager.currentTheme() {
            cell.accessoryType = .checkmark
        }
        
        cell.textLabel?.text = themes[indexPath.row].title
        
        return cell
    }
}

extension ThemesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        ThemeManager.applyTheme(theme: themes[indexPath.row])
        self.dismiss(animated: true, completion: nil)
    }
}
