//
//  CartViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit
import AlamofireImage

class CartViewController: UIViewController {

    var cart = Cart()

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        cart = appDelegate.cart

        updateTotalPrice()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateTotalPrice() {
        var total = Decimal()

        cart.recipes.forEach { object in
            total += object.totalPrice()
        }

        totalPriceLabel.text = total.addPriceTag()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return cart.recipes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.recipes[section].products.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var returnCell = UITableViewCell()

        if indexPath.row != 0 {
            //swiftlint:disable line_length
            guard let cell =
                cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartTableViewCell else {
                    return CartTableViewCell()
            }

            cell.productLabel.text = cart.recipes[indexPath.section].products[indexPath.row - 1].product.getName()

            returnCell = cell
        } else {
            //swiftlint:disable line_length
            guard let cell =
                cartTableView.dequeueReusableCell(withIdentifier: "cartHeader", for: indexPath) as? CartTableViewHeader else {
                    return CartTableViewHeader()
            }

            cell.titleLabel.text = cart.recipes[indexPath.section].title
            cell.recipeImage.af_setImage(withURL: URL.init(string: cart.recipes[indexPath.section].image)!)

            returnCell = cell
        }

        return returnCell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 50

        if indexPath.row != 0 {
            height = 30
        }

        return CGFloat(height)
    }
}
