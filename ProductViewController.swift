//
//  ProductViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productBundlePicker: UIPickerView!

    var pid = 0

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
