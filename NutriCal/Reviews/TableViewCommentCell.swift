//
//  TableViewCommentCell.swift
//  NutriCal
//
//  Created by Giancarlo on 12.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

import Cosmos

class TableViewCommentCell: UITableViewCell {
    
    var dataSource: Any? {
        didSet {
            guard let review = dataSource as? Review else { return }
            
            self.nameLabel.text = review.username
            self.dateLabel.text = review.date
            self.cosmosView.rating = Double(review.rating)
            self.commentLabel.text = review.comment
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont(name: "Avenir", size: 23)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.font = UIFont(name: "Avenir", size: 18)
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont(name: "Avenir", size: 21)
        return label
    }()
    
    private let cosmosView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .precise
        view.settings.starSize = 15
        view.isUserInteractionEnabled = false
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style , reuseIdentifier: reuseIdentifier)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .white
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: nameLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        self.add(subview: cosmosView) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20)
            ]}
        
        self.add(subview: dateLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 9),
            v.leadingAnchor.constraint(equalTo: cosmosView.trailingAnchor, constant: 20)
            ]}
        
        self.add(subview: commentLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 20),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -15),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor, constant: -20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
