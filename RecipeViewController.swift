//
//  RecipeViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 10..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RecipeViewController: UIViewController {

    let network = Network.init()
    var searchUrl = ""
    var searchRecipe = Recipe.init()

    private let priceModified = Notification.Name.init(rawValue: "PriceModified")

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubTitleLabel: UILabel!
    @IBOutlet weak var recipeExcept: UILabel!

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(updatePrice), name: self.priceModified, object: nil)

        productTable.tableFooterView = UIView()

        drawRecipeDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func drawRecipeDetail() {
        recipeImage.af_setImage(withURL: URL(string: searchRecipe.image)!)
        recipeTitleLabel.text = searchRecipe.title
        recipeSubTitleLabel.text = searchRecipe.subtitle
//        totalPriceLabel.text = NumberFormatter.localizedString(from: NSNumber(searchRecipe.totalPrice()), number: nil)
        self.updatePrice()
    }

    func updatePrice() {
        totalPriceLabel.text = searchRecipe.totalPrice()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "RecipeToProduct" {
            guard let secondViewController = segue.destination as? ProductViewController else {
                return
            }
            guard let pid = sender as? Int else {
                return
            }
            secondViewController.pid = pid
        }
    }
}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchRecipe.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
                    return RecipeTableViewCell()
        }

        let productCell = searchRecipe.products[indexPath.row]

        cell.checkboxHandler = { () -> Void in
            self.searchRecipe.toggleCheck(product: productCell.product)
        }

        cell.checkbox.on = productCell.on
        cell.productLabel.text = productCell.product.getName()
        cell.priceLabel.text = String(describing: productCell.product.getPrice()).appending(" 원")
        cell.eaLabel.text = productCell.number.description

        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //swiftlint:disable line_length
        self.performSegue(withIdentifier: "RecipeToProduct", sender: self.searchRecipe.products[indexPath.row].product.getId())
    }
}
