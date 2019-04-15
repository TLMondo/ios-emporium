//
//  CatalogViewController.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class CatalogViewController: DemoViewController {

    @IBOutlet var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup cells
        let nib = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        
        // Setup Cell spacing
        let screenWidth = self.collectionView.bounds.size.width
        let columns : CGFloat = 2.0
        let cellInsetMargin : CGFloat = 5.0
        let cellWidth = screenWidth/columns - cellInsetMargin
        let cellHeigth = cellWidth * 1.3
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: cellWidth, height: cellHeigth)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
    }
    
//    func refreshContent(dataSource: ProductCollectionDataSource?) {
//        guard let newDataSource = dataSource else {
//            return
//        }
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView?.dataSource = newDataSource
//            self?.collectionView?.reloadData()
//        }
//    }



}

//extension CatalogViewController : UICollectionViewDelegate {
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        triggerResultBlock(named: "select", result: indexPath)
//    }
//
//}
