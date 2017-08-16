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
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var confirmButton: UIBarButtonItem!
    @IBAction func touchConfirmButton(_ sender: Any) {
        var edited = (product: data.product, number: 0, on: true)
        edited.number = productBundlePicker.selectedRow(inComponent: 0) + 1
        self.performSegue(withIdentifier: "unwindToRecipe", sender: edited)
    }

    let pickerData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]    //temp
    var data = (product: Product.init(), number: 0, on: false)

    override func viewDidLoad() {
        super.viewDidLoad()

        productBundlePicker.isHidden = false    //temp

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

        productBundlePicker.selectRow(data.number-1, inComponent: 0, animated: false)
    }
}

extension ProductViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].description
    }
}
