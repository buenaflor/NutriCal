//
//  File.swift
//  NutriCal
//
//  Created by Giancarlo on 09.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import MapKit

import AMPopTip

class SectionHeaderView: UIView {
    
    var text: String? {
        didSet {
            guard let text = text else { return }
            self.textLabel.text = text
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Avenir", size: 18)
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.StandardMode.HomeBackground
        
        self.add(subview: textLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class InfoCell: UITableViewCell, Configurable {
    
    var model: RestaurantIdentifier?
    
    func configureWithModel(_: RestaurantIdentifier) {
        guard let restaurantIdentifier = model else { return }
        
        geoCodeLocation(address: restaurantIdentifier.address) { (coordinate) in
            let annotation = Annotation(coordinate: coordinate, title: restaurantIdentifier.restaurant.name, subtitle: "Burger & Drinks")
            self.mapView.addAnnotation(annotation)
            self.mapView.setCenter(coordinate, animated: true)
        }
    }
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "id")
        mapView.delegate = self
        return mapView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        add(subview: mapView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 30),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 250)
            ]}
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func geoCodeLocation(address: String, completion: @escaping (CLLocationCoordinate2D) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    print("not location found")
                    return
            }
            
            print("latitude: \(location.coordinate.latitude), longitude: \(location.coordinate.longitude)")
            completion(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
    }
}

extension InfoCell: MKMapViewDelegate {
    
}

class RestaurantEndUserDetailViewController: UIViewController, Configurable {
    
    var currentSection = DetailSectionItem.menu
    
    var model: RestaurantIdentifier?
    
    func configureWithModel(_: RestaurantIdentifier) {
        guard let restaurantIdentifier = model else { return }
        self.firebaseManager.fetchMenu(restaurantIdentifier: restaurantIdentifier, completion: { (menu) in
            menu.forEach { (menu) in
                self.firebaseManager.fetchFood(restaurantIdentifier: restaurantIdentifier, menu: menu) { (internalMenu) in
                    self.internalMenus.append(internalMenu)
                    self.restaurantHeaderView.delegate = self
                    self.restaurantHeaderView.model = restaurantIdentifier
                    self.restaurantHeaderView.configureWithModel(restaurantIdentifier)
                    self.tableView.tableHeaderView = self.restaurantHeaderView
                    self.tableView.reloadData()
                }
            }
        })
    }

    private var reviews = [Review]()
    
    private var internalMenus = [InternalMenu]()
    
    private var isSearching = false
    
    private let firebaseManager = FirebaseManager()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.delegate = self
        searchController.searchBar.backgroundColor = .white
        searchController.dimsBackgroundDuringPresentation = false
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardAppears), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RestaurantEndUserDetailFoodCell.self)
        tableView.register(TableViewCommentCell.self)
        tableView.backgroundColor = UIColor.StandardMode.HomeBackground
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 110
        tableView.bounces = true
        return tableView
    }()
    
    private let restaurantHeaderView: RestaurantDetailView = {
        let view = RestaurantDetailView(frame: CGRect(x: 0, y: 0, width: 0, height: 290))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        let reviewsRightBarButtonItem = UIBarButtonItem(title: "Reviews", style: .plain, target: self, action: #selector(reviewsRightBarButtonItemTapped))
        self.navigationItem.rightBarButtonItem = reviewsRightBarButtonItem
        self.navigationItem.searchController = self.searchController
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    @objc internal func priceButtonTapped(sender: CustomButton) {
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.row, section: sender.section)) as! RestaurantEndUserDetailFoodCell
        let popTip = PopTip()
        popTip.show(text: "Some Information", direction: .left, maxWidth: 200, in: cell, from: sender.frame)
    }
    
    @objc private func keyboardAppears() -> Void {
        self.searchController.searchBar.resignFirstResponder()
    }
    
    @objc private func reviewsRightBarButtonItemTapped() {
        let reviewsViewController = ReviewsViewController()
        reviewsViewController.restaurantIdentifier = self.model
        self.navigationController?.pushViewController(reviewsViewController, animated: true)
    }
}

// MARK: - TableView

extension RestaurantEndUserDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch currentSection {
        case .menu:
            return self.internalMenus.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentSection {
        case .info:
            return 1
        case .reviews:
            return self.reviews.count
        case .menu:
            return self.internalMenus[section].foods.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentSection {
        case .menu:
            let cell = tableView.dequeueReusableCell(RestaurantEndUserDetailFoodCell.self, forIndexPath: indexPath)
            cell.restaurantEndUserDetailViewController = self
            cell.priceButton.row = indexPath.row
            cell.priceButton.section = indexPath.section
            cell.dataSource = self.internalMenus[indexPath.section].foods[indexPath.row]
            return cell
        case .info:
            let cell = tableView.dequeueReusableCell(InfoCell.self, forIndexPath: indexPath)
            guard let restaurantIdentifier = model else { return UITableViewCell() }
            cell.model = restaurantIdentifier
            cell.configureWithModel(restaurantIdentifier)
            return cell
        case .reviews:
            let cell = tableView.dequeueReusableCell(TableViewCommentCell.self, forIndexPath: indexPath)
            cell.dataSource = reviews[indexPath.row]
            print(reviews.count)
            return cell
        }
    }
}

extension RestaurantEndUserDetailViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch currentSection {
//        case .info:
//            return self.reviews.count
//        case .reviews:
//            return self.reviews.count
//        case .menu:
//            return self.internalMenus[section].foods.count
//        }
//    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch currentSection {
        case .info:
            return UIView()
        case .reviews:
            guard let restaurantIdentifier = model else { return UIView() }
            let reviewheaderView = ReviewHeaderView()
            reviewheaderView.dataSource = restaurantIdentifier
            return reviewheaderView
        case .menu:
            let view = SectionHeaderView()
            view.text = self.internalMenus[section].menu.title
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        switch currentSection {
        case .info:
            return 50
        case .reviews:
            return 300
        case .menu:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
    }
}

extension RestaurantEndUserDetailViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        let restaurantEndUserDetailSearchViewController = RestaurantEndUserDetailSearchViewController()
        restaurantEndUserDetailSearchViewController.internalMenus = self.internalMenus
        
        let navController = UINavigationController(rootViewController: restaurantEndUserDetailSearchViewController)
        self.present(navController, animated: true, completion: nil)
    }
}

extension RestaurantEndUserDetailViewController: BaseRestaurantDetailViewControllerDelegate {
    
    func baseRestaurantDetailViewController(_ baseRestaurantDetailViewController: BaseRestaurantDetailViewController, didSet restaurant: RestaurantIdentifier, menus: [Menu]) {
        menus.forEach { (menu) in
            self.firebaseManager.fetchFood(restaurantIdentifier: restaurant, menu: menu) { (internalMenu) in
                self.internalMenus.append(internalMenu)
                self.tableView.reloadData()
            }
        }
    }
}

extension RestaurantEndUserDetailViewController: RestaurantDetailViewDelegate {
    
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickReviews button: UIButton) {
        self.currentSection = .reviews
        if self.reviews.count == 0 {
            let firebaseManager = FirebaseManager()
            guard let restaurantIdentifier = model else { return }
            firebaseManager.fetchReviews(from: restaurantIdentifier) { (reviews) in
                self.reviews = reviews
                self.tableView.reloadData()
            }
        }
        else {
            self.tableView.reloadData()
        }
    }
    
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickMenu button: UIButton) {
        self.currentSection = .menu
        self.tableView.reloadData()
    }
    
    func restaurantDetailView(_ restaurantDetailView: RestaurantDetailView, didClickInfo button: UIButton) {
        self.currentSection = .info
        self.tableView.reloadData()
    }
    
    
}


