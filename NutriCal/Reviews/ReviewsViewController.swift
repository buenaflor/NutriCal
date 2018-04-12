//
//  ReviewsViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 10.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import FirebaseAuth
import SDWebImage
import Cosmos

enum ReviewCellType {
    case rating
    case comment
}

protocol ReviewHeaderViewDelegate: class {
    func reviewHeaderView(_ reviewHeaderView: UIView, didFinishLoading review: Review)
}

class ReviewHeaderView: UIView {
    
    var dataSource: Any? {
        didSet {
            guard let restaurantIdentifier = dataSource as? RestaurantIdentifier, let imageURL = URL(string: restaurantIdentifier.restaurant.imageFilePath) else { return }
            
            self.logoImageView.sd_setImage(with: imageURL)
        }
    }
    
    weak var delegate: ReviewHeaderViewDelegate?
    
    let reviewCellTypes = [ReviewCellType.rating, ReviewCellType.comment]
    
    let firebaseManager = FirebaseManager()
    
    var selectedRating: Int?
    var comment: String?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(CommentCell.self)
        cv.register(RatingCell.self)
        cv.isPagingEnabled = true
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.StandardMode.LightBackground
        return cv
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = reviewCellTypes.count
        pc.currentPageIndicatorTintColor = UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1)
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    private let headerFillContainerView = UIView()
    private let headerContainerView = UIView()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        self.add(subview: headerFillContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.2)
            ]}
        
        self.add(subview: headerContainerView) { (v, p) in [
            v.topAnchor.constraint(equalTo: headerFillContainerView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor)
            ]}

        self.headerContainerView.add(subview: collectionView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.8)
            ]}

        self.headerContainerView.add(subview: pageControl) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        headerContainerView.backgroundColor = UIColor.StandardMode.LightBackground
        
        self.headerContainerView.add(subview: logoImageView) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.topAnchor.constraint(equalTo: headerContainerView.topAnchor, constant: -35),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.35),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.35)
            ]}

        self.headerContainerView.add(subview: submitButton) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -10),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -15),
            v.widthAnchor.constraint(equalToConstant: 60),
            v.heightAnchor.constraint(equalToConstant: 40)
            ]}
        
        // ??
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.size.height / 2
    }
    
    @objc private func submitButtonTapped() {
        let firebaseManager = FirebaseManager()
        
        if pageControl.currentPage == 0 {
            pageControl.currentPage += 1
            let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            collectionView.isScrollEnabled = true
            self.submitButton.setTitle("Finish", for: .normal)
        }
        else {
            
            let date = Date()
            let formatter = Formatters.dateFormatter
            
            formatter.dateFormat = "dd.MM.yyyy"
            let dateString = formatter.string(from: date)
            
            guard
                let restaurantIdentifier = dataSource as? RestaurantIdentifier,
                let currentUserEmail = Auth.auth().currentUser?.email,
                let comment = self.comment,
                let rating = self.selectedRating
                else { return }
            
            let review = Review(username: currentUserEmail, rating: rating, comment: comment, date: dateString)
            
            firebaseManager.upload(review: review, restaurantIdentifier: restaurantIdentifier) {
                
                // delegate
                self.delegate?.reviewHeaderView(self, didFinishLoading: review)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReviewHeaderView: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let pageNumber = Int(targetContentOffset.pointee.x / frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == 1 {
            self.submitButton.setTitle("Finish", for: .normal)
        }
        else {
            self.submitButton.setTitle("Submit", for: .normal)
        }
    }
}

extension ReviewHeaderView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewCellTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let restaurantIdentifier = dataSource as? RestaurantIdentifier else { return UICollectionViewCell() }
        
        switch reviewCellTypes[indexPath.row] {
        case ReviewCellType.comment:
            let cell = collectionView.dequeueReusableCell(CommentCell.self, forIndexPath: indexPath)
            cell.delegate = self
            return cell
        case ReviewCellType.rating:
            let cell = collectionView.dequeueReusableCell(RatingCell.self, forIndexPath: indexPath)
            cell.dataSource = restaurantIdentifier
            cell.delegate = self
            return cell
        }
    }
}

extension ReviewHeaderView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
extension ReviewHeaderView: RatingCellDelegate {
    func ratingCell(_ ratingCell: RatingCell, didSelect rating: Int) {
        self.selectedRating = rating
        self.submitButton.isEnabled = true
        self.submitButton.setTitleColor(.orange, for: .normal)
    }
}

extension ReviewHeaderView: CommentCellDelegate {
    func commentCell(_ commentCell: CommentCell, didChange comment: String) {
        self.comment = comment
        print(comment)
    }
}


// ReviewController

class ReviewsViewController: UIViewController {
    
    var restaurantIdentifier: RestaurantIdentifier? {
        didSet {
            guard let restaurantIdentifier = restaurantIdentifier else { return }
        
            let tableViewHeader = ReviewHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 300))
            tableViewHeader.delegate = self
            tableViewHeader.dataSource = restaurantIdentifier
            
            tableView.tableHeaderView = tableViewHeader
            
            firebaseManager.fetchReviews(from: restaurantIdentifier) { (reviews) in
                self.reviews = reviews
                self.tableView.reloadData()
            }
        }
    }
    
    let firebaseManager = FirebaseManager()
    
    var reviews = [Review]()

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(TableViewCommentCell.self)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
    
        self.view.add(subview: tableView) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.safeAreaLayoutGuide.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor),
            v.bottomAnchor.constraint(equalTo: p.safeAreaLayoutGuide.bottomAnchor)
            ]}
    }
}

extension ReviewsViewController: ReviewHeaderViewDelegate {
    func reviewHeaderView(_ reviewHeaderView: UIView, didFinishLoading review: Review) {
        let alertController = UIAlertController(title: "Success", message: "Added Review", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            self.reviews.append(review)
            self.tableView.reloadData()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ReviewsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(TableViewCommentCell.self, forIndexPath: indexPath)
        
        cell.dataSource = reviews[indexPath.row]
        
        return cell
    }
}

extension ReviewsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("")
    }
}

