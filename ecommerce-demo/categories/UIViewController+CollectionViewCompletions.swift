//
//  UIViewController+CollectionViewCompletions.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 12/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

enum UIViewControllerCollectionViewKey {
    static let numberOfItems = "collectionViewItems"
    static let cellForIndexPath = "tableViewCell"
    static let indexPathSelected = "indexPathSelected"
}

extension UIViewController : UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = triggerReturnBlock(named: UIViewControllerCollectionViewKey.numberOfItems, resultType: Int.self) else {
            return 0
        }
        return items
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = triggerReturnBlockWithArg(named: UIViewControllerCollectionViewKey.cellForIndexPath, arg: indexPath, resultType: UICollectionViewCell.self) else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}

extension UIViewController : UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerResultBlock(named: UIViewControllerCollectionViewKey.indexPathSelected, result: indexPath)
    }
}
