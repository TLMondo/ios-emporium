//
//  CatalogLogic.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/2/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

func catalogLogic(catalogVC: inout CatalogViewController,
                  cartVC: CartViewController,
                  contentManager: inout ContentManager) {
    
    catalogVC.onViewDidLoad { [weak catalogVC, weak contentManager] in
        guard let cVC = catalogVC else {
            return
        }

        if contentManager?.products.withValuesBetween(-100, 0).count == 0 {
            cVC.collectionView.backgroundView = cVC.activityIndicatorView
            cVC.activityIndicatorView.center = cVC.collectionView.center
            cVC.activityIndicatorView.startAnimating()
        }
    }
    catalogVC.onViewWillAppear { [weak catalogVC] in
        DispatchQueue.main.async {
            catalogVC?.collectionView.reloadData()
        }
    }

    // FIXME: This never gets called. Possible a cyclical issue with the ContentManager
    catalogVC.onResultBlock(named: "refreshProducts",
                            result: ContentManager.self,
                            block: { [weak catalogVC] (newContentManager) in
                                catalogVC?.collectionView.reloadData()
                                catalogVC?.activityIndicatorView.stopAnimating()
    })
    catalogVC.onResultBlock(named: UIViewControllerCollectionViewKey.indexPathSelected,
                            result: IndexPath.self,
                            block: { [weak contentManager, weak catalogVC](indexPath) in
            guard let product = contentManager?.products.withValuesBetween(-100, 0)[indexPath.row] else {
                return
            }
            if let cell = catalogVC?.collectionView.cellForItem(at: indexPath) as? ProductCollectionViewCell {
                cell.imageView.animate(.pop(repeatCount:1))
            }

            TrackingManager.shared.trackEvent(title: "added to cart", data: ["product": product.name ?? ""])
            contentManager?.addToCart(products: [product],
                                      sponsorId: "TEAL",
                                      success: { [weak contentManager] in
                Log.verbose("Added product to cart: \(product)")
                if let name = product.name,
                    let pid = product.id {
                    TrackingManager.shared.trackEvent(title: "added_to_cart", data: ["product_name":name,
                                                                                     "product_id":pid])
                }
                contentManager?.updateTransactions()
            }, failure: { (error) in
                Log.error(error)
            })
    })
    catalogVC.onReturnBlock(named: UIViewControllerCollectionViewKey.numberOfItems,
                           resultType: Int.self,
                           block: { [contentManager]() -> Int in
        let count = contentManager.products.withValuesBetween(-100, 0).count
        return count
    })
    catalogVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                  argType: IndexPath.self,
                                  resultType: UICollectionViewCell.self) { [weak catalogVC, weak contentManager] (indexPath) -> UICollectionViewCell in
        guard let cVC = catalogVC,
            let cm = contentManager else {
            return UICollectionViewCell()
        }
        let cell = cVC.collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductCollectionViewCell
        
        let row = indexPath.row
        let product = cm.products.withValuesBetween(-100, 0)[row]
        
        if let urlString = product.image_url,
            let url = URL(string: urlString) {
            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            cell.imageView?.kf.setImage(with: resource)
        } else {
            let image = UIImage(named: "dv_icon.png")
            cell.imageView?.image = image
        }
        if let name = product.name,
            let value = product.value {
            let buttonText = "+ \(name)"
            cell.beastcoinWithValue?.valueLabel.text = "\(abs(value))"
            //cell.button?.setTitle(buttonText, for: .normal)
            cell.productLabel.text = buttonText
        }
        cell.ovalLabel?.layer.cornerRadius = 15
        cell.ovalLabel?.clipsToBounds = true
        cell.beastcoinWithValue.clipsToBounds = true
        return cell
    }
}
