//
//  SettingsViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 13.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

struct Setting {
    let sectionTitle: SettingType
    let settings: [SettingType]
}

enum SettingType: String {
    case general = "General"
    case reset = "Reset"
    case showVegan = "Show Vegan Food"
    case resetFavourite = "Reset Favourites"
    case appTutorial = "App Tutorial"
}

class SettingsViewController: UIViewController {
    
    let settings = [
        Setting(sectionTitle: SettingType.general, settings: [SettingType.showVegan, SettingType.appTutorial]),
        Setting(sectionTitle: SettingType.reset, settings: [SettingType.resetFavourite])
        ]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        return tableView
    }()
    
    private lazy var toggleSwitch: UISwitch = {
        let toggleSwitch = UISwitch()
        toggleSwitch.addTarget(self, action: #selector(toggleSwitchChanged(sender:)), for: .valueChanged)
        return toggleSwitch
    }()
    
    private var toggleIsOn: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.view.fillToSuperview(tableView)
    }
    
    @objc private func toggleSwitchChanged(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: Constant.DefaultKey.showVegan)
    }
}

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settings[section].sectionTitle.rawValue
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].settings.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        let setting = settings[indexPath.section].settings[indexPath.row]
        
        if setting == SettingType.showVegan {
            cell.accessoryView = self.toggleSwitch
        }
        
        cell.textLabel?.text = setting.rawValue
        
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let setting = settings[indexPath.section].settings[indexPath.row]
        
        switch setting {
        case SettingType.resetFavourite:
            print("")
        default:
            break
        }
    }
}
