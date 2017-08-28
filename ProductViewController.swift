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
        bundleStepper.value = Double.init(data.number)
    }

    func productInfo() {
        let product = data.product

        productImage.af_setImage(withURL: URL(string: product.image)!)

        titleLabel.text = product.name

        var price = product.price
        priceLabel.text = price.addUnitTag(unit: " 원")

        bundleUnit = product.getBundleTuple(input: "").unit
        bundleLabel.text = data.number.description.appending(bundleUnit)
        bundleStepper.value = Double(data.number)

        calcTotalPrice()
    }

    func calcTotalPrice() {
        var result = Decimal.init(bundleStepper.value) * data.product.price
        totalPriceLabel.text = result.addPriceTag()
    }
}
