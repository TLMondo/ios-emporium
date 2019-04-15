//
//  CoinWithValue.swift
//  ecommerce-demo
//
//  Created by Tealium User on 10/24/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

@IBDesignable
class CoinWithValueView: UIView {

    @IBOutlet weak var bgImageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
}
