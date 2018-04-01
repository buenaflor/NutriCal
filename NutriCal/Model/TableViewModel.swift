////
////  TableViewModel.swift
////  NutriCal
////
////  Created by Giancarlo on 30.03.18.
////  Copyright © 2018 Giancarlo. All rights reserved.
////
//
//
//import UIKit
//
//public protocol TableViewItem {
//    var cellType: UITableViewCell.Type { get }
//    var action: (() -> Void)? { get }
//    var allowsSelection: Bool { get }
//}
//
//public extension TableViewItem {
//    var allowsSelection: Bool {
//        return true
//    }
//
//    var action: (() -> Void)? {
//        return nil
//    }
//}
//
//public protocol TableViewCell {
//    var cell: UITableViewCell { get }
//    var model: TableViewItem? { set get }
//}
//
//public extension TableViewCell where Self: UITableViewCell {
//    var cell: UITableViewCell {
//        return self
//    }
//}
//
//public enum TableSectionHeaderFooterKind {
//    case header, footer
//}
//
//public protocol TableViewSection {
//    var items: [TableViewItem] { get }
//
//    var title: String? { get }
//    var subtitle: String? { get }
//
//    var headerType: UITableViewHeaderFooterView.Type? { get }
//    var footerType: UITableViewHeaderFooterView.Type? { get }
//}
//
//public extension TableViewSection {
//    var title: String? { return nil }
//    var subtitle: String? { return nil }
//
//    var headerType: UITableViewHeaderFooterView.Type? { return nil }
//    var footerType: UITableViewHeaderFooterView.Type? { return nil }
//}
//
//extension TableViewSection {
//    func viewType(for kind: TableSectionHeaderFooterKind) -> UITableViewHeaderFooterView.Type? {
//        switch kind {
//        case .header: return headerType
//        case .footer: return footerType
//        }
//    }
//}
//
//public protocol EditableTableViewSection: TableViewSection {
//    var items: [TableViewItem] { set get }
//}
//
//public protocol TableViewHeaderFooter {
//    var view: UITableViewHeaderFooterView { get }
//    var model: TableViewSection? { set get }
//}
//
//public extension TableViewHeaderFooter where Self: UITableViewHeaderFooterView {
//    var view: UITableViewHeaderFooterView {
//        return self
//    }
//}
//
//public protocol TableViewModelDelegate: class {
//    func tableViewModel(_ tableViewModel: TableViewModel, didSelect item: TableViewItem, at indexPath: IndexPath)
//    func tableViewModel(_ tableViewModel: TableViewModel, customize cell: TableViewCell)
//}
//
//public extension TableViewModelDelegate {
//    func tableViewModel(_ tableViewModel: TableViewModel, didSelect item: TableViewItem, at indexPath: IndexPath) { }
//    func tableViewModel(_ tableViewModel: TableViewModel, customize cell: TableViewCell) { }
//}
//
//public class TableViewModel: NSObject {
//    public weak var delegate: TableViewModelDelegate?
//    public var sections: [TableViewSection]
//
//    public init(delegate: TableViewModelDelegate? = nil, sections: [TableViewSection] = []) {
//        self.delegate = delegate
//        self.sections = sections
//
//        super.init()
//    }
//}
//
//public class DefaultTableViewSection: TableViewSection {
//    public var items: [TableViewItem]
//    public var title: String?
//    public var subtitle: String?
//
//    public var headerType: UITableViewHeaderFooterView.Type?
//    public var footerType: UITableViewHeaderFooterView.Type?
//
//    public init(items: [TableViewItem], title: String? = nil) {
//        self.items = items
//        self.title = title
//    }
//}
//
//extension TableViewModel: UITableViewDataSource {
//    public func itemAt(_ indexPath: IndexPath) -> TableViewItem {
//        return sections[indexPath.section].items[indexPath.item]
//    }
//
//    public func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//
//    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sections[section].items.count
//    }
//
//    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let item = itemAt(indexPath)
//
//        var displayable: TableViewCell = tableView.dequeueReusableCell(item.cellType, forIndexPath: indexPath) as! TableViewCell
//        displayable.model = item
//
//        delegate?.tableViewModel(self, customize: displayable)
//
//        return displayable.cell
//    }
//
//    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = sections[section]
//
//        return section.headerType == nil ? section.title : nil
//    }
//
//    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//        let section = sections[section]
//
//        return section.footerType == nil ? section.subtitle : nil
//    }
//}
//
//extension TableViewModel: UITableViewDelegate {
//    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return view(for: .header, in: section, from: tableView)
//    }
//
//    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return view(for: .footer, in: section, from: tableView)
//    }
//
//    public func view(for kind: TableSectionHeaderFooterKind, in section: Int, from tableView: UITableView) -> UITableViewHeaderFooterView? {
//        let tableViewSection = sections[section]
//
//        guard let headerFooterViewType = tableViewSection.viewType(for: kind) else {
//            return nil
//        }
//
//        var displayable: TableViewHeaderFooter = tableView.dequeueReusableHeaderFooterView(headerFooterViewType) as! TableViewHeaderFooter
//        displayable.model = tableViewSection
//
//        return displayable.view
//    }
//
//    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return height(for: .header, in: section, from: tableView)
//    }
//
//    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return height(for: .footer, in: section, from: tableView)
//    }
//
//    public func height(for kind: TableSectionHeaderFooterKind, in section: Int, from tableView: UITableView) -> CGFloat {
//        let tableViewSection = sections[section]
//
//        let hasView = tableViewSection.viewType(for: kind) != nil
//
//        let hasText: Bool
//
//        switch kind {
//        case .header: hasText = tableViewSection.title != nil
//        case .footer: hasText = tableViewSection.subtitle != nil
//        }
//
//        guard hasView || hasText else {
//            //workaround UIKit bug
//            return 0
//        }
//
//        return UITableViewAutomaticDimension
//    }
//
//    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return itemAt(indexPath).allowsSelection
//    }
//
//    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if let action = itemAt(indexPath).action {
//            action()
//            return nil
//        }
//        return indexPath
//    }
//
//    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.tableViewModel(self, didSelect: itemAt(indexPath), at: indexPath)
//    }
//}
//
//
