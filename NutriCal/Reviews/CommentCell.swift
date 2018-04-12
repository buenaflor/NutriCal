//
//  CommentCell.swift
//  NutriCal
//
//  Created by Giancarlo on 12.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol CommentCellDelegate: class {
    func commentCell(_ commentCell: CommentCell, didChange comment: String)
}

class CommentCell: UICollectionViewCell {
    
    weak var delegate: CommentCellDelegate?
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 23)
        label.text = "Write a short review"
        return label
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "Tell us what you think"
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor.StandardMode.LightBackground
        textView.delegate = self
        textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: textView.frame.size.height))
        return textView
    }()
    
    let separatorLine: UIView = {
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor.orange
        return separatorLine
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = UIColor.StandardMode.LightBackground
        
        self.configureConstraints()
    }
    
    private func configureConstraints() {
        
        self.add(subview: descriptionLabel) { (v, p) in [
            v.topAnchor.constraint(equalTo: p.topAnchor, constant: 75),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40)
            ]}
        
        self.add(subview: textView) { (v, p) in [
            v.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.heightAnchor.constraint(equalToConstant: 50)
            ]}
        
        
        self.add(subview: separatorLine) { (v, p) in [
            v.topAnchor.constraint(equalTo: textView.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 40),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -40),
            v.heightAnchor.constraint(equalToConstant: 0.5)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {

        let size = CGSize(width: frame.width, height: .infinity)
        let estimatedSize = self.textView.sizeThatFits(size)
        
        self.textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
        
        self.delegate?.commentCell(self, didChange: textView.text)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
    
}
