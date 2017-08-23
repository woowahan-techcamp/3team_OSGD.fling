//
//  CartTableViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubtitleLabel: UILabel!
    @IBOutlet weak var materialListLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    override func awakeFromNib() {
        recipeImage.layer.cornerRadius = CGFloat(roundf(Float(recipeImage.frame.size.width/2.0)));
        recipeImage.layer.masksToBounds = true;
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
