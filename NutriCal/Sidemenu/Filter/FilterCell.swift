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
                self.lowerFilterLabel.text = "0 Carbs"
                self.higherFilterLabel.text = "400 Carbs"
                self.setSliderValues(min: 0, max: 400)
            case FilterOption.protein:
                self.lowerFilterLabel.text = "0 Protein"
                self.higherFilterLabel.text = "100 Carbs"
                self.setSliderValues(min: 0, max: 100)
            case FilterOption.price:
                self.lowerFilterLabel.text = "0€"
                self.higherFilterLabel.text = "30€"
                self.setSliderValues(min: 0, max: 30)
            case FilterOption.kCal:
                self.lowerFilterLabel.text = "0 kCal"
                self.higherFilterLabel.text = "1000 kCal"
                self.setSliderValues(min: 0, max: 1000)
            case FilterOption.location:
                self.lowerFilterLabel.text = "Within 0km"
                self.higherFilterLabel.text = "Within 2km"
                self.setSliderValues(min: 0, max: 2)
            case FilterOption.rating:
                self.lowerFilterLabel.text = "0 Stars"
                self.higherFilterLabel.text = "5 Stars"
                self.setSliderValues(min: 0, max: 0.5)
            case FilterOption.fats:
                self.lowerFilterLabel.text = "0 Fats"
                self.higherFilterLabel.text = "100 Fats"
                self.setSliderValues(min: 0, max: 100)
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
    
    private func setSliderValues(min: Float, max: Float) {
        self.volumeSlider.minimumValue = min
        self.volumeSlider.maximumValue = max
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func volumeSliderChanged(sender: UISlider) {
        guard let filterOption = filterOption else { return }
        self.delegate?.filterCell(self, didChange: sender, filterOption: filterOption)
    }
}
