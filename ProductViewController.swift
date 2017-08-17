//
//  ProductViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 11..
//  Copyright © 2017년 osgd. All rights reserved.
//

import AlamofireImage
import UIKit

class ProductViewController: UIViewController {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var bundleStepper: UIStepper!
    @IBAction func bundleStepperChanged(_ sender: Any) {
        //개수, 가격 업데이트
    }

    @IBOutlet weak var totalPriceLabel: UILabel!

    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBAction func touchConfirmButton(_ sender: Any) {
        let edited = (product: data.product, number: Int.init(bundleStepper.value), on: true)
        self.performSegue(withIdentifier: "unwindToRecipe", sender: edited)
    }

    var data = (product: Product.init(), number: 0, on: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        productInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "unwindToRecipe" {
            guard let secondViewController = segue.destination as? RecipeViewController else {
                return
            }
            guard let product = sender as? (product: Product, number: Int, on: Bool) else {
                return
            }
            secondViewController.editedProduct = product
        }
    }

    func productInfo() {
        productImage.af_setImage(withURL: URL(string: data.product.getImage())!)

        //~계속 추가하기~
        titleLabel.text = data.product.getName()
//        descriptionLabel.text = "상품 상세 설명~~~~~~"
        bundleLabel.text = data.product.getBundle().appending(" 개")

    }

    func setBundleStepper() {
        bundleStepper.minimumValue = 1
        bundleStepper.maximumValue = 10
        bundleStepper.stepValue = 1
        bundleStepper.autorepeat = true
        bundleStepper.value = 1
    }
}
