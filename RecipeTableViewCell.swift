//
//  RecipeTableViewCell.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    let checkbox = CheckboxButton.init(frame: CGRect(x: 10, y: 15, width: 20, height: 20))
    let productLabel = UILabel.init(frame: CGRect(x: 40, y: 5, width: 250, height: 24))
    let priceLabel = UILabel.init(frame: CGRect(x: 40, y: 25, width: 100, height: 24))
    let eaLabel = UILabel.init(frame: CGRect(x: 280, y: 12, width: 60, height: 24)) //need to resize

    var checkboxHandler:(() -> Void)!
    var disclosureHandler:(() -> Void)!

    @IBAction func didToggleCheckboxButton(_ sender: CheckboxButton) {
        self.resignFirstResponder()
        self.checkboxHandler()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        //checkbox
        self.contentView.addSubview(checkbox)
        self.checkbox.addTarget(self, action: #selector(didToggleCheckboxButton), for: .touchUpInside)

        //product title
        self.contentView.addSubview(productLabel)

        //product price
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textColor = UIColor.gray
        self.contentView.addSubview(priceLabel)

        //ea
        eaLabel.font = UIFont.systemFont(ofSize: 16)
        eaLabel.textColor = UIColor.gray
        eaLabel.textAlignment = NSTextAlignment.right
        self.contentView.addSubview(eaLabel)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            self.disclosureHandler()
        }
    }
}
