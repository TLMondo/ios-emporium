//
//  ProductTableViewCell.swift
//  ecommerce-demo
//
//  Created by Tealium User on 7/26/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class ProductTableViewCell: MGSwipeTableCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var unitsField: UITextField!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var beastcoinWithValue: CoinWithValueXibView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
