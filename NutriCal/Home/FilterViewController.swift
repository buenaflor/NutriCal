//
//  FilterViewController.swift
//  NutriCal
//
//  Created by Giancarlo on 18.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit
import RangeSeekSlider

class FilterSelectorButton: UIControl {
    
    var onTap: (() -> ())?
    
    lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byTruncatingTail
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
        return label
    }()
    
    lazy var imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "down").withRenderingMode(.alwaysTemplate)
        imageView.contentMode = .center
        imageView.tintColor = self.textColor
        return imageView
    }()
    
    var textColor = UIColor.StandardMode.LightBackground {
        didSet {
            self.titleLabel.textColor = textColor
        }
    }
    
    var title: String {
        return "My Filter"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addTarget(self, action: #selector(filterSelectorTapped), for: .touchUpInside)
        
        add(subview: titleLabel) { (titleLabel, view) -> ([NSLayoutConstraint]) in return [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]}
        
        add(subview: imageView) { (imageView, view) -> ([NSLayoutConstraint]) in
            let trailing = imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
            trailing.priority = UILayoutPriority.defaultHigh //navigationbar can break this
            
            return [ trailing,
                     imageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
                     imageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 15)]
        }
        
        self.titleLabel.text = title
    }
    
    @objc private func filterSelectorTapped() {
        onTap?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol FilterViewControllerDelegate: class {
    func filterViewController(_ filterViewController: FilterViewController, didApply filterItems: [FilterItem])
//    func filterViewController(_ filterViewController: FilterViewController, changesApplied)
}

struct FilterItem {
    var option: FilterOption
    var selectedMinValue: Int
    var selectedMaxvalue: Int
}

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    weak var delegate: FilterViewControllerDelegate?
    
    let filterOptions = FilterOption.all
    var filterItems = [FilterItem]()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(FilterCell.self)
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Filter"
        
        
        
        let leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "exit"), style: .plain, target: self, action: #selector(leftBarButtonItemTapped))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        let rightBarButtonItem = UIBarButtonItem(title: "Apply", style: .plain, target: self, action: #selector(rightBarButtonItemTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.fillToSuperview(tableView)
    }
    
    @objc private func leftBarButtonItemTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func rightBarButtonItemTapped() {
        for (i, _) in filterOptions.enumerated() {
            let indexPath = IndexPath(row: i, section: 0)
            
            guard
                let cell = tableView.cellForRow(at: indexPath) as? FilterCell,
                let filterOption = cell.filterOption
                else { return }
            
            filterItems.append(FilterItem(option: filterOption, selectedMinValue: cell.volumeSlider.roundedSelectedMinValue, selectedMaxvalue: cell.volumeSlider.roundedSelectedMaxValue))
        }
        
        delegate?.filterViewController(self, didApply: filterItems)
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredContentSize: CGSize {
        get {
            return view.frame.size
        } set (newValue) {
            view.frame.size.width = newValue.width
            view.frame.size.height = newValue.height
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(FilterCell.self, forIndexPath: indexPath)

        cell.filterOption = filterOptions[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension FilterViewController: FilterCellDelegate {
    func filterCell(_ filterCell: FilterCell, didChange slider: RangeSeekSlider, filterOption: FilterOption) {
//        self.delegate?.filterViewController(self, didChange: slider, filterOption: filterOption)
    }
}
