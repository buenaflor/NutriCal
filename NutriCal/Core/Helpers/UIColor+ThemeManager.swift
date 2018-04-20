//
//  UIColor+ThemeManager.swift
//  NutriCal
//
//  Created by Giancarlo on 16.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

enum Theme: Int {
    
    case standardTheme, darkTheme
    
    var title: String {
        switch self {
        case .standardTheme:
            return "Standard Theme"
        case .darkTheme:
            return "Dark Theme"
        }
    }
    
    var mainColor: UIColor {
        switch self {
        case .standardTheme:
            return UIColor.StandardMode.TabBarColor
        case .darkTheme:
            return UIColor.black
        }
    }
    
    //Customizing the Navigation Bar
    var barStyle: UIBarStyle {
        switch self {
        case .standardTheme:
            return .default
        case .darkTheme:
            return .black
        }
    }
    
    var navigationBackgroundImage: UIImage? {
        return self == .standardTheme ? UIImage(named: "navBackground") : nil
    }
    
    var tabBarBackgroundImage: UIImage? {
        return self == .standardTheme ? UIImage(named: "tabBarBackground") : nil
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .standardTheme:
            return UIColor.StandardMode.HomeBackground
        case .darkTheme:
            return UIColor.brown
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .standardTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.lightGray
        }
    }
    
    var titleTextColor: UIColor {
        switch self {
        case .standardTheme:
            return UIColor.black
        case .darkTheme:
            return UIColor.blue
        }
    }
    var subtitleTextColor: UIColor {
        switch self {
        case .standardTheme:
            return UIColor.brown
        case .darkTheme:
            return UIColor.red
        }
    }
    
    static let all: [Theme] = [ .darkTheme, .standardTheme ]
}

class ThemeManager {
    
    static func updateColors() {
        if let currentview = (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController?.view {
            if let superview = currentview.superview {
                currentview.removeFromSuperview()
                superview.addSubview(currentview)
            }
        }
    }
    
    // ThemeManager
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: Constant.DefaultKey.selectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .standardTheme
        }
    }
    
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: Constant.DefaultKey.selectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        
        sharedApplication.delegate?.window??.tintColor = theme.secondaryColor

        UINavigationBar.appearance().barTintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
        
        UITabBar.appearance().barTintColor = theme.mainColor
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
        
        self.updateColors()
    }
}
