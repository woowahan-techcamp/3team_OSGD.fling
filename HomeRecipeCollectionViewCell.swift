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
        self.sampleRecipeImage.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        sampleRecipeImage.addGestureRecognizer(tapRecognizer)
    }

    @IBOutlet weak var sampleRecipeImage: UIImageView!
    @IBOutlet weak var sampleRecipeLabel: UILabel!
}
