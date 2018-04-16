//
//  OnBoardingViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 16.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.register(OnBoardingCell.self)
        return cv
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
        self.view.fillToSuperview(collectionView)
    }
    
    @objc private func exitLeftBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension OnBoardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(OnBoardingCell.self, forIndexPath: indexPath)
        
        cell.backgroundColor = .red
        
        return cell
    }
}

extension OnBoardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
}
