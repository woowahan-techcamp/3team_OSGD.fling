//
//  RPTableViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class RPTableViewCell: UITableViewCell {
    
    let productLabel = UILabel.init(frame: CGRect(x: 20, y: 5, width: 250, height: 24))
    let priceLabel = UILabel.init(frame: CGRect(x: 20, y: 25, width: 100, height: 24))
    let eaLabel = UILabel.init(frame: CGRect(x: 200, y: 25, width: 60, height: 24))

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        //product title
        self.contentView.addSubview(productLabel)
        productLabel.font = UIFont.systemFont(ofSize: 12)

        //product price
        priceLabel.font = UIFont.systemFont(ofSize: 10)
        priceLabel.textColor = UIColor.gray
        self.contentView.addSubview(priceLabel)

        //ea
        eaLabel.font = UIFont.systemFont(ofSize: 10)
        eaLabel.textColor = UIColor.gray
        eaLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(eaLabel)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
