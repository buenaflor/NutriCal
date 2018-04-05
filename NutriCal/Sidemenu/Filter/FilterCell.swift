//
//  FilterCell.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

protocol FilterCellDelegate: class {
    func filterCell(_ filterCell: FilterCell, didChange slider: UISlider, filterOption: FilterOption)
}

class FilterCell: UITableViewCell {
    
    weak var delegate: FilterCellDelegate?
    
    var filterOption: FilterOption? {
        didSet {
            guard let filterOption = filterOption else { return }
            
            switch filterOption {
            case FilterOption.carbs:
                print("")
            case FilterOption.protein:
                print("")
            case FilterOption.price:
                print("")
            case FilterOption.kCal:
                print("")
            case FilterOption.location:
                print("")
            case FilterOption.rating:
                print("")
            case FilterOption.fats:
                print("")
            case FilterOption.cuisine:
                print("")
            }
            
            self.volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(sender:)), for: [.touchUpInside, .touchUpOutside])
        }
    }
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.setThumbImage(#imageLiteral(resourceName: "circle-filled").withRenderingMode(.alwaysTemplate), for: .normal)
        slider.tintColor = UIColor.StandardMode.SideMenuHeaderView
        return slider
    }()
    
    private let lowerFilterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "0 kCal"
        return label
    }()
    
    private let higherFilterLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .gray
        label.text = "1000 kCal"
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.add(subview: volumeSlider) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: p.bottomAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30),
            v.heightAnchor.constraint(equalToConstant: 30)
            ]}
        
        self.add(subview: lowerFilterLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: volumeSlider.topAnchor),
            v.leadingAnchor.constraint(equalTo: p.leadingAnchor, constant: 30)
            ]}
        
        self.add(subview: higherFilterLabel) { (v, p) in [
            v.bottomAnchor.constraint(equalTo: volumeSlider.topAnchor),
            v.trailingAnchor.constraint(equalTo: p.trailingAnchor, constant: -30)
            ]}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func volumeSliderChanged(sender: UISlider) {
        guard let filterOption = filterOption else { return }
        self.delegate?.filterCell(self, didChange: sender, filterOption: filterOption)
    }
}
