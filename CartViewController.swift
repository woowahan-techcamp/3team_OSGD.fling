//
//  CartViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {

    var cart = Cart()
    let headerIdentifier = "CartCellHeader"

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        cart = appDelegate.cart

        let nib = UINib(nibName: headerIdentifier, bundle: nil)
        cartTableView.register(nib, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        cartTableView.estimatedSectionHeaderHeight = 60
        self.automaticallyAdjustsScrollViewInsets = false

        totalPriceLabel.text = "100,000 원"  //temp
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return cart.recipes.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.recipes[section].products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as? CartTableViewCell else {
                return CartTableViewCell()
        }

        cell.textLabel?.text = cart.recipes[indexPath.section].products[indexPath.row].product.getName()

        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //swiftlint:disable line_length
        guard let header =
            cartTableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as? CartTableViewHeader else {
                return CartTableViewHeader()
        }

//        guard let header = cartTableView.tableHeaderView as? CartTableViewHeader else {
//            return CartTableViewHeader()
//        }

        let title = cart.recipes[section].title
        header.titleLabel.text = title

        cartTableView.tableHeaderView = header
//        cartTableView.tableHeaderView?.addSubview(header)

        return header
    }
}
