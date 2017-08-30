//
//  HomeRecipeCollectionViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class HomeRecipeCollectionViewCell: UICollectionViewCell {

    var clickHandler:(() -> Void)!

    override func awakeFromNib() {
        let cgSize = CGSize.init(width: 187.5, height: 227.5)
        self.frame.size = cgSize
        self.sampleRecipeImage.frame.size = CGSize(width: 167.5, height: 167.5)
        sampleRecipeImage.layer.masksToBounds = true
    }

    @IBOutlet weak var sampleRecipeImage: UIImageView!
    @IBOutlet weak var sampleRecipeLabel: UILabel!
    @IBOutlet weak var sampleRecipeSubtitleLabel: UILabel!
}
