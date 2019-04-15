//
//  WalletLogic.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/2/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

func walletLogic(_ walletVC: inout WalletViewController,
                 contentManager: inout ContentManager) {

    walletVC.onViewWillAppear { [weak walletVC] in
        walletVC?.tableView?.backgroundView = walletVC?.activityIndicatorView
        walletVC?.activityIndicatorView.startAnimating()
    }
    walletVC.onViewDidAppear { [weak walletVC] in
        walletVC?.triggerEmptyBlock(named: "refresh")
    }
    walletVC.onResultBlock(named: "refreshProducts",
                           result: ContentManager.self,
                           block: { [weak walletVC] (newContentManager) in
        walletVC?.triggerEmptyBlock(named: "refresh")

    })
    walletVC.onResultBlock(named: "refreshTransactions",
                           result: ContentManager.self,
                           block: { [weak walletVC] (newContentManager) in
        walletVC?.triggerEmptyBlock(named: "refresh")
    })
    walletVC.onEmptyBlock(named: "refresh") { [weak walletVC, weak contentManager] in
        DispatchQueue.main.async {
            walletVC?.tableView?.endRefreshing()
            walletVC?.beastcoinWithValue.valueLabel.text = "\(contentManager?.availableBeastcoins() ?? 0)"
            walletVC?.tableView?.reloadData()
        }
    }
    walletVC.onResultBlock(named: "refreshBadge",
                           result: ContentManager.self) { [weak walletVC] (contentManager) in
            DispatchQueue.main.async{
                let n = contentManager.availableBeastcoins()
                if n > 0 {
                    walletVC?.tabBarItem.badgeValue = "\(n)"
                } else {
                    walletVC?.tabBarItem.badgeValue = nil
                }
            }
    }
    walletVC.onReturnBlock(named: UIViewControllerTableViewKey.numberOfRows,
                           resultType: Int.self,
                           block: { [contentManager]() -> Int in
            return contentManager.transactions.withStatusBetween(.purchased, .delivered).count
    })
    walletVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                  argType: IndexPath.self,
                                  resultType: UITableViewCell.self) { [weak walletVC, weak contentManager] (indexPath) -> UITableViewCell in
            
    
            guard let cell = walletVC?.tableView?.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? ProductWithBeastcoinTableViewCell else {
                return UITableViewCell()
            }
                                    
            guard let transaction = contentManager?.transactions.withStatusBetween(.purchased, .delivered).sortedByTimestamp()[indexPath.row] else {
                // This should never happen. Should we just force init with conferences?
                return UITableViewCell()
            }
    
            guard let pid = transaction.product_id,
                let product = contentManager?.products.productFor(id: pid) else {
                Log.error(WalletViewControllerError.noMatchingProductFound)
                return UITableViewCell()
            }
    
            cell.titleLabel?.text = product.name
    
            if let imageUrl = product.image_url,
                let url = URL(string: imageUrl) {
                let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
                cell.iconImageView?.kf.setImage(with: resource)
            } else {
                let image = UIImage(named: "dv_icon.png")
                cell.iconImageView?.image = image
            }
    
            if let value = product.value {
                cell.coin.valueLabel.text = "\(value)"
            }

            walletVC?.activityIndicatorView.stopAnimating()
            return cell

    }
    
    
}
