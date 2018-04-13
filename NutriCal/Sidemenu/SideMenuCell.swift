//
//  SideMenuCell.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {
    
    var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        return imageView
    }()
    
    var customTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let leftContainer = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: leftContainer) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor),
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.widthAnchor.constraint(equalTo: p.heightAnchor)
            ]}
        
        self.leftContainer.add(subview: customImageView) { (v, p) in [
            v.centerXAnchor.constraint(equalTo: p.centerXAnchor),
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.heightAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.5),
            v.widthAnchor.constraint(equalTo: p.heightAnchor, multiplier: 0.5)
            ]}

        self.add(subview: customTextLabel) { (v, p) in [
            v.centerYAnchor.constraint(equalTo: p.centerYAnchor),
            v.leadingAnchor.constraint(equalTo: leftContainer.trailingAnchor, constant: 20)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
