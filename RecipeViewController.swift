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

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubTitleLabel: UILabel!
    @IBOutlet weak var recipeExcept: UILabel!

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
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

        let product = self.searchRecipe.products[indexPath.row].product

        //checkbox
        let positionX = 10
        let checkbox = CheckboxButton.init(frame: CGRect(x: positionX, y: 15, width: 20, height: 20))
        checkbox.on = true
        cell.contentView.addSubview(checkbox)

        //product title
        let productLabel = UILabel.init(frame: CGRect(x: 40, y: 5, width: 200, height: 24))
        productLabel.text = product.getName()
        cell.contentView.addSubview(productLabel)

        //product price
        let priceLabel = UILabel.init(frame: CGRect(x: positionX + 30, y: 25, width: 100, height: 24))
        priceLabel.text = String(describing: product.getPrice()).appending(" 원")
        priceLabel.font = UIFont.systemFont(ofSize: 12)
        priceLabel.textColor = UIColor.gray
        cell.contentView.addSubview(priceLabel)

        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        //swiftlint:disable line_length
        self.performSegue(withIdentifier: "RecipeToProduct", sender: self.searchRecipe.products[indexPath.row].product.getId())
    }
}
