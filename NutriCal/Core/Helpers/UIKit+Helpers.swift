//
//  UIKit.swift
//  NutriCal
//
//  Created by Giancarlo on 30.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import MapKit
import RangeSeekSlider


// - MARK: UICollectionView

public protocol Configurable {
    associatedtype T
    var model: T? { get set }
    func configureWithModel(_: T)
}

public protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return NSStringFromClass(self)
    }
}

public protocol ConfigurableView: ReusableView {
    associatedtype T
    
    func configure(_ item: T, at indexPath: IndexPath)
}

public protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType)
}

// Unused
public protocol CollectionDataProvider {
    associatedtype T
    
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> T?
    
    func updateItem(at indexPath: IndexPath, value: T)
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
    
    func register<T: UITableViewCell>(_: T.Type) {
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

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
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

extension RangeSeekSlider {

    /// Rounds the selected slider min value to an Int
    var roundedSelectedMinValue: Int {
        return Int(self.selectedMinValue)
    }
    
    /// Rounds the selected slider max value to an Int
    var roundedSelectedMaxValue: Int {
        return Int(self.selectedMaxValue)
    }
}

