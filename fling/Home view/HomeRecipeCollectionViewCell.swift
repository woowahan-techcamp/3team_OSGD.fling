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

    @IBAction func imageTapped(_ sender: UIImageView) {
        self.clickHandler()
    }

    override func awakeFromNib() {
        let cgSize = CGSize.init(width: 187.5, height: 227.5)
        self.frame.size = cgSize
//        self.backgroundColor = UIColor.darkGray

        self.sampleRecipeImage.frame.size = CGSize(width: 167.5, height: 167.5)
        self.sampleRecipeImage.isUserInteractionEnabled = true

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        sampleRecipeImage.addGestureRecognizer(tapRecognizer)
        sampleRecipeImage.layer.masksToBounds = true
    }

    @IBOutlet weak var sampleRecipeImage: UIImageView!
    @IBOutlet weak var sampleRecipeLabel: UILabel!
    @IBOutlet weak var sampleRecipeSubtitleLabel: UILabel!
}
