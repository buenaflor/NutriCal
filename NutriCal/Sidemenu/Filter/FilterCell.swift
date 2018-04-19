//
//  FilterCell.swift
//  NutriCal
//
//  Created by Giancarlo on 02.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RangeSeekSlider

protocol FilterCellDelegate: class {
    func filterCell(_ filterCell: FilterCell, didChange slider: RangeSeekSlider, filterOption: FilterOption)
}

class FilterCell: UITableViewCell {
    
    weak var delegate: FilterCellDelegate?
    
    var filterOption: FilterOption? {
        didSet {
            guard let filterOption = filterOption else { return }
            
            switch filterOption {
            case .carbs:
                self.setSliderValues(min: 0, max: 100, filterOption: .carbs)
            case .protein:
                self.setSliderValues(min: 0, max: 100, filterOption: .protein)
            case .price:
                self.setSliderValues(min: 0, max: 30, filterOption: .price)
            case .kCal:
                self.setSliderValues(min: 0, max: 1000, filterOption: .kCal)
            case .location:
                self.setSliderValues(min: 0, max: 2, filterOption: .location)
            case .rating:
                self.setSliderValues(min: 0, max: 5, filterOption: .rating)
            case .fats:
                self.setSliderValues(min: 0, max: 100, filterOption: .fats)
            case FilterOption.cuisine:
                print("")
            }
            
            self.volumeSlider.addTarget(self, action: #selector(volumeSliderChanged(sender:)), for: .allTouchEvents)
        }
    }
    
    let volumeSlider: RangeSeekSlider = {
        let slider = RangeSeekSlider()
        slider.hideLabels = true
        slider.tintColor = .gray
        slider.colorBetweenHandles = UIColor.StandardMode.TabBarColor
        slider.handleColor = UIColor.StandardMode.TabBarColor
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
    
    private func setSliderValues(min: CGFloat, max: CGFloat, filterOption: FilterOption) {
        self.volumeSlider.minValue = min
        self.volumeSlider.maxValue = max
        
        self.volumeSlider.selectedMaxValue = max
        self.volumeSlider.selectedMinValue = min
        
        self.lowerFilterLabel.text = "\(Int(min)) \(filterOption.text)"
        self.higherFilterLabel.text = "\(Int(max)) \(filterOption.text)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func volumeSliderChanged(sender: RangeSeekSlider) {
        guard let filterOption = filterOption else { return }
        self.delegate?.filterCell(self, didChange: sender, filterOption: filterOption)
        
        self.lowerFilterLabel.text = "\(Int(sender.selectedMinValue)) \(filterOption.text)"
        self.higherFilterLabel.text = "\(Int(sender.selectedMaxValue)) \(filterOption.text)"
    }
}
