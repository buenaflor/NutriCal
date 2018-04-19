//
//  CollectionDataSource.swift
//  NutriCal
//
//  Created by Giancarlo on 18.04.18.
//  Copyright © 2018 Giancarlo. All rights reserved.
//

import UIKit

open class CollectionViewDataSource<Provider: CollectionDataProvider, Cell: UICollectionViewCell>:
    NSObject,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
where Cell: ConfigurableView, Provider.T == Cell.T {
    
    // MARK: - Private Properties
    let provider: Provider
    let collectionView: UICollectionView
    
    // MARK: - Lifecycle
    init(collectionView: UICollectionView, provider: Provider) {
        self.collectionView = collectionView
        self.provider = provider
        super.init()
        setUp()
    }
    
    func setUp() {
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return provider.numberOfSections()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return provider.numberOfItems(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.defaultReuseIdentifier, for: indexPath) as? Cell
            else {
            return UICollectionViewCell()
        }
        let item = provider.item(at: indexPath)
        if let item = item {
            cell.configure(item, at: indexPath)
        }
        return cell
    }
    
    public typealias CollectionItemSelectionHandlerType = (IndexPath) -> Void
    public var collectionItemSelectionHandler: CollectionItemSelectionHandlerType?
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionItemSelectionHandler?(indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView(frame: .zero)
    }
}

//Wir machen im master branch weiter

