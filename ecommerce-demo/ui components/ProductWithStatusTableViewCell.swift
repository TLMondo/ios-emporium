//
//  ProductWithStatusTableViewCell.swift
//  ecommerce-demo
//
//  Created by Tealium User on 10/25/18.
//  Copyright © 2018 Tealium. All rights reserved.
//

import UIKit

class ProductWithStatusTableViewCell: UITableViewCell {

    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
