//
//  ProductCollectionViewCell.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/24/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import IBAnimatable
import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: AnimatableImageView!

    @IBOutlet weak var beastcoinWithValue: CoinWithValueXibView!
    
    @IBOutlet weak var ovalLabel: AnimatableLabel!
    @IBOutlet weak var productLabel: AnimatableLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        let onButtonTap = UITapGestureRecognizer(target: self, action: #selector(ProductCollectionViewCell.onAddToCart)),
//        onLabelTap = UITapGestureRecognizer(target: self, action: #selector(ProductCollectionViewCell.onAddToCart)),
//        onCoinTap = UITapGestureRecognizer(target: self, action: #selector(ProductCollectionViewCell.onAddToCart))
//        ovalLabel.isUserInteractionEnabled = true
//        ovalLabel.addGestureRecognizer(onButtonTap)
//        productLabel.isUserInteractionEnabled = true
//        productLabel.addGestureRecognizer(onLabelTap)
//        beastcoinWithValue.isUserInteractionEnabled = true
//        beastcoinWithValue.addGestureRecognizer(onCoinTap)

        ovalLabel.isUserInteractionEnabled = false
        productLabel.isUserInteractionEnabled = false
        beastcoinWithValue.isUserInteractionEnabled = false

    }
    
//    @objc func onAddToCart(sender:UITapGestureRecognizer) {
//        self.imageView.animate(.pop(repeatCount: 1))
//    }

}
