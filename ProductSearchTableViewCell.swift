//
//  ProductSearchTableViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class ProductSearchTableViewCell: UITableViewCell {

    let productLabel = UILabel.init(frame: CGRect(x: 30, y: 10, width: 300, height: 24))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //product title
        self.contentView.addSubview(productLabel)
        // Configure the view for the selected state
    }

}
