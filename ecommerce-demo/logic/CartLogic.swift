//
//  CartLogic.swift
//  ecommerce-demo
//
//  Created by Tealium User on 8/31/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit
import Kingfisher

func cartLogic(cartVC: inout CartViewController,
               contentManager: inout ContentManager,
               newSelections: @escaping ([ProductSelection])->()) {
    
    cartVC.onViewWillAppear { [weak cartVC] in
        cartVC?.tableView?.backgroundView = cartVC?.activityIndicatorView
        cartVC?.noContentLabel?.text = "cart_empty".localized()
        cartVC?.triggerEmptyBlock(named: "updateUI")
    }
    cartVC.onEmptyBlock(named: "checkout", { [weak cartVC, weak contentManager] in
        TrackingManager.shared.trackEvent(title: "checkout", data: nil)
        contentManager?.checkout(success:{
            cartVC?.displayAlert(title: "checkout_title".localized(),
                                 message: "checkout_message".localized())
            NotificationCenter.default.post(name: .RequestTransactions, object: nil)
        }, failure: { (error) in
            cartVC?.displayAlert(title: "checkout_title_problem", message: nil)
        })

    })
    cartVC.onEmptyBlock(named: "updateUI", { [weak cartVC, weak contentManager] in
        
        DispatchQueue.main.async {
            cartVC?.tableView?.endRefreshing()
            let checkout = cartVC?.checkoutButton
            let noContent = cartVC?.noContentLabel
            if let subtotal = contentManager?.inCartBeastcoins() {
                let uSubtotal = abs(subtotal)
                cartVC?.subtotalCoinWithValue.valueLabel.text = "\(uSubtotal)"
            }
            cartVC?.totalCoinWithValue.valueLabel.text = "\(contentManager?.possibleBeastcoins() ?? 0)"
            
            // Possibly due to weak ref to cartVC, the below tableView setup does not persist when
            // done in the viewController's viewDidLoad function directly or via .onViewDidAppear extension
            // Possibly overwritten later somewhere
            let nib = UINib(nibName: "ProductWithBeastcoinTableViewCell", bundle: nil)
            cartVC?.tableView?.register(nib, forCellReuseIdentifier: "cellIdentifier")
            cartVC?.tableView?.delegate = cartVC
            cartVC?.tableView?.dataSource = cartVC
            cartVC?.tableView?.reloadData()
            cartVC?.activityIndicatorView.stopAnimating()
            // Badge Icon
            if let n = contentManager?.transactions.withStatus(.incart).count,
                n > 0 {
                cartVC?.tabBarItem.badgeValue = "\(n)"
                checkout?.enable()
                noContent?.hide()
            } else {
                cartVC?.tabBarItem.badgeValue = nil
                checkout?.disable()
                noContent?.enable()
            }
        }
    })
    cartVC.onResultBlock(named: "refreshBadge",
                         result: ContentManager.self) { [weak cartVC] (contentManager) in
        DispatchQueue.main.async{
            let n = contentManager.transactions.withStatus(.incart).count
            if n > 0 {
                cartVC?.tabBarItem.badgeValue = "\(n)"
            } else {
                cartVC?.tabBarItem.badgeValue = nil
            }
        }
    }
    cartVC.onResultBlock(named: "refreshTransactions",
                         result: ContentManager.self,
                         block: { [weak cartVC] (newContentManager) in
        let incartTransactions = newContentManager.transactions.withStatus(.incart)
        DispatchQueue.main.async { [weak cartVC] in
            if incartTransactions.count == 0 {
                cartVC?.tabBarItem.badgeValue = nil
                return
            }
            cartVC?.tabBarItem.badgeValue = String(incartTransactions.count)
        }
        cartVC?.triggerEmptyBlock(named: "updateUI")
    })
    cartVC.onReturnBlock(named: UIViewControllerTableViewKey.numberOfRows,
                         resultType: Int.self) { [weak contentManager] () -> Int in
        return contentManager?.transactions.withStatus(.incart).count ?? 0
    }
    
    cartVC.onReturnBlockWithArg(named: UIViewControllerTableViewKey.cellForIndexPath,
                                  argType: IndexPath.self,
                                  resultType: UITableViewCell.self) { [weak cartVC, weak contentManager] (indexPath) -> UITableViewCell in
                                    
        guard let cell = cartVC?.tableView?.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as? ProductWithBeastcoinTableViewCell else {
            return UITableViewCell()
        }
        
        guard let transaction = contentManager?.transactions.withStatus(.incart).sortedByTimestamp()[indexPath.row] else {
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
            cell.coin.valueLabel.text = "\(abs(value))"
        }
                                    
        let deleteButton : MGSwipeButton = MGSwipeButton(title: "Delete", backgroundColor: .red) {
            [weak contentManager](sender: MGSwipeTableCell!) -> Bool in
            if let pid = transaction.product_id {
                TrackingManager.shared.trackEvent(title: "removed_from_cart", data: ["product_id":pid])
            }
            contentManager?.triggerResultBlock(named: "deleteTransaction", result: transaction)
            return true
        }
        cell.rightButtons = [deleteButton]

        return cell
    
    }
}
