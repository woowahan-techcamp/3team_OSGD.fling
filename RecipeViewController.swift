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
    var recipe = Recipe.init()
    var products = [Product]()

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubTitleLabel: UILabel!
    @IBOutlet weak var recipeExcept: UILabel!

    @IBOutlet weak var productTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        productTable.tableFooterView = UIView()

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(drawRecipeDetail),
                                               name: Notification.Name.init(rawValue: "flingRecipeDetail"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeProductList),
                                               name: NSNotification.Name.init(rawValue: "flingProductList"), object: nil)

        network.getRecipeWith(url: searchUrl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func drawRecipeDetail(notification: Notification) {
        guard let data = notification.userInfo?["data"] as? Recipe else {
            return
        }
        recipe = data

        recipeImage.af_setImage(withURL: URL(string: recipe.image)!)
        recipeTitleLabel.text = recipe.title
        recipeSubTitleLabel.text = recipe.title.appending("sub")    //temp
    }

    func makeProductList(notification: Notification) {
        guard let data = notification.userInfo?["data"] as? [[String: Any]] else {
            return
        }
        data.forEach { object in
            products.append(Product.init(data: object)!)
        }

        productTable.reloadData()
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
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeTableViewCell else {
                    return RecipeTableViewCell()
        }

        if products.count > 0 {
            cell.textLabel?.text = products[indexPath.row].getName()

            let price = String(describing: products[indexPath.row].getPrice())
            cell.detailTextLabel?.text = price
        }

        return cell
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        self.performSegue(withIdentifier: "RecipeToProduct", sender: products[indexPath.row].getId())
    }
}
