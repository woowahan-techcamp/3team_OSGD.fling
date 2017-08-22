//
//  CartTableViewHeader.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CartTableViewHeader: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        recipeImage.frame = CGRect(x: 8, y: 0, width: 44, height: 44)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

//    override func draw(_ rect: CGRect) {
//        titleLabel.textColor = UIColor.gray //temp
//    }
}
