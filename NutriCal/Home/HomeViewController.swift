//
//  HomeViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 29.03.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import SideMenu
import SwiftSpinner
import KUIPopOver
import RangeSeekSlider

enum FoodType {
    case chinese, thai, american, german
}

extension FoodType: SelectionItem {
    var text: String {
        switch self {
        case .american:
            return "American"
        case .chinese:
            return "Chinese"
        case .german:
            return "German"
        case .thai:
            return "Thai"
        }
    }
    
    static let all: [FoodType] = [ .american, .chinese, .german, .thai ]
}

class HomeViewController: UIViewController, LoadingController {
    
    var foodType: FoodType = .american {
        didSet {
            print("hello american")
        }
    }
    
    func loadData(force: Bool) {
        print("loading in home")
    }
    
    private var isFiltered = false
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.register(RestaurantMenuCell.self)
        collectionView.register(DealOfTheMonthView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "id")
        collectionView.backgroundColor = UIColor(red:0.95, green:0.92, blue:0.89, alpha:1.0)
        return collectionView
    }()
    
    private let dealOfTheMonthView = DealOfTheMonthView()
    
    private var internalRestaurants = [InternalRestaurant]()
    
    private var restaurantIdentifiers = [RestaurantIdentifier]()
    private lazy var filteredRestaurantIdentifiers = restaurantIdentifiers
    
    private var menus = [InternalMenu]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SwiftSpinner.show("Loading Restaurants")
        
        let firebaseManager = FirebaseManager()
        
        firebaseManager.fetchEndUserRestaurant { (restaurantIdentifiers) in
            restaurantIdentifiers.forEach({
                if $0.restaurant.confirmation == "APPROVED" {
                    self.restaurantIdentifiers.append($0)
                }
                else {
                    SwiftSpinner.hide()
                }
            })
            self.collectionView.reloadData()
        }
        
        self.setupView()
    }
    
    private func createSideMenu() {
        let leftSideMenuViewController = SideMenuViewController()
        leftSideMenuViewController.delegate = self
        
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: leftSideMenuViewController)
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = max(round(min((UIScreen.main.bounds.width), (UIScreen.main.bounds.height)) * 0.80), 240)
    }
    
    private func setupView() {
        self.view.backgroundColor = UIColor.StandardMode.HomeBackground
        self.createNavigationItems()
        self.createSideMenu()
        self.configureConstraints()
    }
    
    private func createNavigationItems() {
        let filterSelectorButton = FilterSelectorButton()
        filterSelectorButton.onTap = { [weak self] in
            let filterViewController = FilterViewController()
            filterViewController.preferredContentSize = CGSize(width: 300, height: 300)
            filterViewController.delegate = self
            let navController = UINavigationController(rootViewController: filterViewController)

            navController.modalPresentationStyle = .popover
            let popController = navController.popoverPresentationController
            popController?.permittedArrowDirections = .any
            popController?.delegate = self
            popController?.sourceRect = filterSelectorButton.bounds
            popController?.sourceView = filterSelectorButton
            self?.present(navController, animated: true, completion: nil)
        }
        
        navigationItem.titleView = filterSelectorButton
        
        let rightMenuNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(rightMenuNavigationItemTapped(sender:)))
        navigationItem.rightBarButtonItem = rightMenuNavigationItem
        
        let leftMenuNavigationItem = UIBarButtonItem(image: #imageLiteral(resourceName: "burger-menu"), style: .plain, target: self, action: #selector(leftMenuNavigationItemTapped))
        navigationItem.leftBarButtonItem = leftMenuNavigationItem
    }
    
    private func configureConstraints() {
        
        
        self.view.add(subview: self.collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.safeAreaLayoutGuide.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    @objc private func leftMenuNavigationItemTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc private func rightMenuNavigationItemTapped(sender: UIBarButtonItem) {
        let selectionViewController: SelectionViewController<FoodType> = SelectionViewController(items: FoodType.all)
        selectionViewController.preferredContentSize = CGSize(width: 180, height: 0)
        selectionViewController.selectedItem = foodType
        selectionViewController.didSelect = { [weak self] item in
            self?.dismiss(animated: true, completion: nil)
            self?.foodTypeSelected(item: item)
            return true
        }
        
        let popoverPresentationController = selectionViewController.popoverPresentationController
        popoverPresentationController?.delegate = self
        popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.up
        popoverPresentationController?.barButtonItem = sender
    
        present(selectionViewController, animated: true, completion: nil)
    }
    
    private func foodTypeSelected(item: FoodType) {
        self.foodType = item
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "id", for: indexPath)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.restaurantIdentifiers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(RestaurantMenuCell.self, forIndexPath: indexPath)
        
        cell.dataSource = self.restaurantIdentifiers[indexPath.row]
        cell.configure(data: self.restaurantIdentifiers[indexPath.row])
        cell.delegate = self
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let restaurantEndUserDetailViewController = RestaurantEndUserDetailViewController()
        restaurantEndUserDetailViewController.model = restaurantIdentifiers[indexPath.row]
        restaurantEndUserDetailViewController.configureWithModel(self.restaurantIdentifiers[indexPath.row])
        self.navigationController?.pushViewController(restaurantEndUserDetailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height * 0.6)
    }
}

extension HomeViewController: RestaurantMenuCellDelegate {
    
    func restaurantMenuCell(_ restaurantMenuCell: RestaurantMenuCell, didClick button: UIButton) {
        let popOverViewController = DefaultPopOverViewController()
        popOverViewController.preferredContentSize = CGSize(width: 180, height: 180)
        popOverViewController.popoverPresentationController?.sourceView = button
        
        let customView = CustomPopOverView(settings: [PopOverSettings.favourite, PopOverSettings.share], frame: CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: CGSize(width: 180, height: 180)))
        let indexPath = self.collectionView.indexPath(for: restaurantMenuCell)
        
        customView.delegate = self
        customView.indexPath = indexPath
        popOverViewController.view.addSubview(customView)
        popOverViewController.popoverPresentationController?.sourceRect = button.bounds
        present(popOverViewController, animated: true, completion: nil)

        
    }
    
    func pushViewController(_ viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension HomeViewController: CustomPopOverViewDelegate {
    func customPopOverView(_ customPopOverView: CustomPopOverView, didSelectRowAt indexPath: IndexPath, cvIndexPath: IndexPath, title: String, message: String) {
        
        let firebaseManager = FirebaseManager()
        
        let restaurantIdentifier = self.restaurantIdentifiers[cvIndexPath.row]
        dismiss(animated: true, completion: nil)

        firebaseManager.addToFavourite(restaurantIdentifier: restaurantIdentifier) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
extension Notification.Name {
    static let filterMenu = Notification.Name(
        rawValue: "filterMenu")
}

extension HomeViewController: SideMenuViewControllerDelegate, FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController: FilterViewController, didApply filterItems: [FilterItem]) {
        
        filterItems.forEach { (item) in
            print(item.option, item.selectedMaxvalue, item.selectedMinValue)
        }
        
        NotificationCenter.default.post(name: .filterMenu, object: filterItems)
    }

    func sideMenuViewController(_ sideMenuViewController: SideMenuViewController, didChange slider: RangeSeekSlider, filterOption: FilterOption) {
        // Throw away?
    }
}

enum PopOverSettings: String {
    case favourite = "Add To Favourite"
    case share = "Share"
}

protocol CustomPopOverViewDelegate: class {
    func customPopOverView(_ customPopOverView: CustomPopOverView, didSelectRowAt indexPath: IndexPath, cvIndexPath: IndexPath, title: String, message: String)
}

class CustomPopOverView: UIView, KUIPopOverUsable {
    
    weak var delegate: CustomPopOverViewDelegate?
    
    var arrowDirection: UIPopoverArrowDirection {
        return .right
    }
    
    var indexPath: IndexPath?

    private var settings = [PopOverSettings]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    convenience init(settings: [PopOverSettings], frame: CGRect) {
        self.init()
        
        self.settings = settings
        self.frame = frame
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupView() {
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomPopOverView: UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(UITableViewCell.self, forIndexPath: indexPath)
        
        cell.textLabel?.text = self.settings[indexPath.row].rawValue
        
        return cell
    }
}

extension CustomPopOverView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch settings[indexPath.row] {
        case PopOverSettings.favourite:
            guard let cvIndexPath = self.indexPath else { return }
            self.delegate?.customPopOverView(self, didSelectRowAt: indexPath, cvIndexPath: cvIndexPath, title: "Success", message: "Added to Favourite")
        default:
            break;
        }

    }
}



