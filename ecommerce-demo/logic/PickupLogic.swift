//
//  PickupLogic.swift
//  ecommerce-demo
//
//  Created by Jason Koo on 11/2/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import Foundation
import Kingfisher

func pickupLogic(pickupVC: PickupViewController,
                 contentManager: ContentManager) {
    
    pickupVC.onViewWillAppear { [weak pickupVC] in
        pickupVC?.tableView?.backgroundView = pickupVC?.activityIndicatorView
        pickupVC?.activityIndicatorView.startAnimating()
    }
    pickupVC.onResultBlock(named: "refreshTransactions",
                           result: ContentManager.self,
                           block: { [weak pickupVC] (newContentManager) in
        pickupVC?.triggerResultBlock(named: "refreshBadge", result: newContentManager)
        DispatchQueue.main.async {
                pickupVC?.tableView?.reloadData()
        }
    })
    pickupVC.onResultBlock(named: "refreshBadge",
                           result: ContentManager.self) { (contentManager) in
        let pickupTransactions = contentManager.transactions.withStatus(.ready)
        DispatchQueue.main.async { [weak pickupVC] in
            pickupVC?.tableView?.endRefreshing()
            if pickupTransactions.count == 0 {
                pickupVC?.tabBarItem.badgeValue = nil
                return
            }
            pickupVC?.tabBarItem.badgeValue = String(pickupTransactions.count)
        }
    }
    pickupVC.onReturnBlock(named: UIViewControllerTableViewKey.numberOfRows,
                           resultType: Int.self) { [weak contentManager]() -> Int in
        return contentManager?.transactions.withStatuses([.purchased,.processing, .ready, .delivered]).count ?? 0
    }
    pickupVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                  argType: IndexPath.self,
                                  resultType: UITableViewCell.self) { [weak pickupVC, weak contentManager](indexPath) -> UITableViewCell in
            guard let cell = pickupVC?.tableView?.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? ProductWithStatusTableViewCell else {
                return UITableViewCell()
            }
    
            guard let transaction = contentManager?.transactions.withStatuses([.purchased,.processing, .ready, .delivered]).sortedByTimestamp()[indexPath.row] else {
                // This should never happen. Should we just force init with conferences?
                return cell
            }
    
            guard let pid = transaction.product_id,
                let product = contentManager?.products.productFor(id: pid) else {
                    Log.error(WalletViewControllerError.noMatchingProductFound)
                    return cell
            }
    
            if let imageUrl = product.image_url,
                let url = URL(string: imageUrl) {
                let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
                cell.imageView?.kf.setImage(with: resource)
            } else {
                let image = UIImage(named: "dv_icon.png")
                cell.imageView?.image = image
            }
    
            cell.textLabel?.text = product.name
    
            let statusString = transaction.statusAsString()
            cell.statusLabel?.text = statusString
            pickupVC?.activityIndicatorView.stopAnimating()
            return cell
    }
}
