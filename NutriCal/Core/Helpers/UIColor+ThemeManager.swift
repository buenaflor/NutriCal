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
}

// Enum declaration
let SelectedThemeKey = "SelectedTheme"

// This will let you use a theme in the app.
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
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .standardTheme
        }
    }
    
    static func applyTheme(theme: Theme) {
        // First persist the selected theme using NSUserDefaults.
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        // You get your current (selected) theme and apply the main color to the tintColor property of your application’s window.
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.secondaryColor

        UINavigationBar.appearance().barTintColor = theme.mainColor
        UINavigationBar.appearance().barStyle = theme.barStyle
        UINavigationBar.appearance().backgroundColor = theme.backgroundColor
//        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "backArrow")
//        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "backArrowMaskFixed")
        
        UITabBar.appearance().barTintColor = theme.mainColor
        UITabBar.appearance().barStyle = theme.barStyle
        UITabBar.appearance().backgroundImage = theme.tabBarBackgroundImage
        
//        let tabIndicator = UIImage(named: "tabBarSelectionIndicator")?.withRenderingMode(.alwaysTemplate)
//        let tabResizableIndicator = tabIndicator?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 2.0, bottom: 0, right: 2.0))
//        UITabBar.appearance().selectionIndicatorImage = tabResizableIndicator
        
//        let controlBackground = UIImage(named: "controlBackground")?.withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//        let controlSelectedBackground = UIImage(named: "controlSelectedBackground")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3))
//
//        UISegmentedControl.appearance().setBackgroundImage(controlBackground, for: .normal, barMetrics: .default)
//        UISegmentedControl.appearance().setBackgroundImage(controlSelectedBackground, for: .selected, barMetrics: .default)
//
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .normal)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .disabled)
//        UIStepper.appearance().setBackgroundImage(controlBackground, for: .highlighted)
//        UIStepper.appearance().setDecrementImage(UIImage(named: "fewerPaws"), for: .normal)
//        UIStepper.appearance().setIncrementImage(UIImage(named: "morePaws"), for: .normal)
        
//        UISlider.appearance().setThumbImage(UIImage(named: "sliderThumb"), for: .normal)
//        UISlider.appearance().setMaximumTrackImage(UIImage(named: "maximumTrack")?
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0.0, bottom: 0, right: 6.0)), for: .normal)
//        UISlider.appearance().setMinimumTrackImage(UIImage(named: "minimumTrack")?
//            .withRenderingMode(.alwaysTemplate)
//            .resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 6.0, bottom: 0, right: 0)), for: .normal)
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
        
        self.updateColors()
    }
}
