//
//  UIKit.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import MapKit

//// - MARK: ReusableView
//
//public protocol ReusableView: class {
//    static var defaultReuseIdentifier: String { get }
//}
//
//public extension ReusableView where Self: UIView {
//    public static var defaultReuseIdentifier: String {
//        return NSStringFromClass(self)
//    }
//}
//
//extension UITableViewCell: ReusableView { }
//extension UITableViewHeaderFooterView: ReusableView { }
//
//public extension UITableView {
//    func register<T: UITableViewCell>(_ cellClass: T.Type) {
//        register(cellClass, forCellReuseIdentifier: cellClass.defaultReuseIdentifier)
//    }
//    
//    func register<T: UITableViewHeaderFooterView>(_ aClass: T.Type) {
//        register(aClass, forHeaderFooterViewReuseIdentifier: aClass.defaultReuseIdentifier)
//    }
//    
//    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
//        return dequeueReusableCell(T.self, forIndexPath: indexPath)
//    }
//    
//    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
//        register(type)
//        
//        guard let cell = dequeueReusableCell(withIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(type.defaultReuseIdentifier)")
//        }
//        
//        return cell
//    }
//    
//    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
//        return dequeueReusableHeaderFooterView(T.self)
//    }
//    
//    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_ type: T.Type) -> T {
//        register(type)
//        
//        guard let view = dequeueReusableHeaderFooterView(withIdentifier: type.defaultReuseIdentifier) as? T else {
//            fatalError("Could not dequeue cell with identifier: \(type.defaultReuseIdentifier)")
//        }
//        
//        return view
//    }
//}


// - MARK: UICollectionView

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}
extension UICollectionViewCell: ReusableView { }
extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_: T.Type){
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        register(type)

        guard let cell = dequeueReusableCell(withReuseIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.defaultReuseIdentifier)")
        }

        return cell
    }
}

extension UITableViewCell: ReusableView { }
extension UITableView {
    
    func register<T: UITableViewCell>(_: T.Type){
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T {
        register(type)
        guard let cell = dequeueReusableCell(withIdentifier: type.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(type.defaultReuseIdentifier)")
        }
        
        return cell
    }
}


// - MARK: UIView

extension UIView {
    public func add(subview: UIView, createConstraints: (_ view: UIView, _ parent: UIView) -> ([NSLayoutConstraint])) {
        addSubview(subview)
        
        subview.activate(constraints: createConstraints(subview, self))
    }
    
    public func remove(subviews: [UIView]) {
        subviews.forEach({
            $0.removeFromSuperview()
        })
    }
    
    public func activate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
    }
    
    public func deactivate(constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.deactivate(constraints)
    }

    public func fillToSuperview(_ subview: UIView) {
        self.add(subview: subview) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }

    
    public func addSeparatorLine(color: UIColor) {
        let view = UIView()
        view.backgroundColor = color
        
//        self.add(subview: view) { (view, parent) in [
//            view.heightAnchor.constraint(equalToConstant: 0.5),
//            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            view.topAnchor.constraint(equalTo: self.bottomAnchor)
//            ]}
        
        self.add(subview: view) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
    
    }
}

// - MARK: UISearchBar

extension UISearchBar {
    
    private func getViewElement<T>(type: T.Type) -> T? {
        
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
    
    func getSearchBarTextField() -> UITextField? {
        
        return getViewElement(type: UITextField.self)
    }
    
    func setTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.textColor = color
        }
    }
    
    func setTextFieldColor(color: UIColor) {
        
        if let textField = getViewElement(type: UITextField.self) {
            switch searchBarStyle {
            case .minimal:
                textField.layer.backgroundColor = color.cgColor
                textField.layer.cornerRadius = 6
                
            case .prominent, .default:
                textField.backgroundColor = color
            }
        }
    }
    
    func setPlaceholderTextColor(color: UIColor) {
        
        if let textField = getSearchBarTextField() {
            textField.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor: color])
        }
    }
}

