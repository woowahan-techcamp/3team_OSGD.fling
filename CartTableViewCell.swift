//
//  CartTableViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var productLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productLabel.textColor = UIColor.gray
        productLabel.font = UIFont.systemFont(ofSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
