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

    //bundle label and stepper
    @IBOutlet weak var bundleLabel: UILabel!
    @IBOutlet weak var bundleStepper: UIStepper!
    @IBAction func bundleStepperChanged(_ sender: Any) {
        let value = Int.init(bundleStepper.value)
        let bundle = value.description.appending(bundleUnit)
        bundleLabel.text = data.product.getBundleString(input: bundle)

        calcTotalPrice()
    }

    @IBOutlet weak var totalPriceLabel: UILabel!

    //confirm button
    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBAction func touchConfirmButton(_ sender: Any) {
        data.product.setBundle(input: bundleLabel.text ?? "1 개")
        let edited = (product: data.product, number: Int.init(bundleStepper.value), on: true)
        self.performSegue(withIdentifier: "unwindToRecipe", sender: edited)
    }

    var data = (product: Product.init(), number: 0, on: false)
    var bundleUnit = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setBundleStepper()
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

    func setBundleStepper() {
        bundleStepper.minimumValue = 1
        bundleStepper.maximumValue = 30
        bundleStepper.stepValue = 1
        bundleStepper.autorepeat = true
        bundleStepper.value = Double.init(data.product.getBundleTuple(input: "").number)
    }

    func productInfo() {
        let product = data.product

        productImage.af_setImage(withURL: URL(string: product.getImage())!)

        titleLabel.text = product.getName()
        descriptionLabel.text = ""

        priceLabel.text = product.getPrice().description.appending(" 원")

        bundleUnit = product.getBundleTuple(input: "").unit
        bundleLabel.text = product.getBundleString(input: "")
        bundleStepper.value = Double(product.getBundleTuple(input: "").number)

        calcTotalPrice()
    }

    func calcTotalPrice() {
        let result = Decimal.init(bundleStepper.value) * data.product.getPrice()
        totalPriceLabel.text = "총 ".appending(result.description).appending(" 원")
    }
}
