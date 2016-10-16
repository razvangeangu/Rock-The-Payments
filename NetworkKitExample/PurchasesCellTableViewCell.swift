//
//  PurchasesCellTableViewCell.swift
//  NetworkKit
//
//  Created by Pietro Calzini on 15/10/2016.
//  Copyright © 2016 alextelek. All rights reserved.
//

import UIKit

class PurchasesCellTableViewCell: UITableViewCell {
    @IBOutlet var merchantLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        priceLabel.layer.borderColor = UIColor.red.cgColor
        priceLabel.textColor = UIColor(red: 255/255, green: 123/255, blue: 139/255, alpha: 1)
//        priceLabel.textColor = UIColor(red: 136/255, green: 255/255, blue: 120/255, alpha: 1)
        priceLabel.layer.borderColor = UIColor(red: 255/255, green: 123/255, blue: 139/255, alpha: 1).cgColor
        
        priceLabel.layer.borderWidth = 1.0
        priceLabel.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
