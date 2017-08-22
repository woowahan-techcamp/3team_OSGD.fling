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

    var cart = Cart()
    let network = Network.init()
    let myStoragy = Storage()
    var searchUrl = ""
    var searchRecipe = Recipe.init()
    var editedProduct = (product: Product(), number: 0, on: true)

    private let priceModified = Notification.Name.init(rawValue: "PriceModified")

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubTitleLabel: UILabel!
    @IBOutlet weak var recipeServeLabel: UILabel!
    @IBOutlet weak var recipeMissed: UILabel!

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var productTable: UITableView!

    @IBAction func unwindToRecipe(segue: UIStoryboardSegue) {
        searchRecipe.add(product: editedProduct.product, number: editedProduct.number)
        self.productTable.reloadData()
        self.updatePrice()
    }

    @IBOutlet weak var cartButton: UIButton!
    @IBAction func cartButtonTouched(_ sender: Any) {
        cart.add(recipe: self.searchRecipe)
        myStoragy.saveCart(cart: cart)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(updatePrice), name: self.priceModified, object: nil)

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        cart = appDelegate.cart

        productTable.tableFooterView = UIView()

        drawRecipeDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func drawRecipeDetail() {
        if searchRecipe.image != "" {
            recipeImage.af_setImage(withURL: URL(string: searchRecipe.image)!)
        } else {
            //대체 이미지를 띄우던가
        }

        recipeTitleLabel.text = searchRecipe.title
        recipeSubTitleLabel.text = searchRecipe.subtitle
        recipeServeLabel.text = searchRecipe.serving
        recipeMissed.text = searchRecipe.missed//.appending("은(는) 찾지 못했어요.")

        self.updatePrice()
    }

    func updatePrice() {
        var price = searchRecipe.totalPrice()
        totalPriceLabel.text = price.addPriceTag()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "RecipeToProduct" {
            guard let secondViewController = segue.destination as? ProductViewController else {
                return
            }
            guard let product = sender as? (product: Product, number: Int, on: Bool) else {
                return
            }
            secondViewController.data = product
        }
    }

    // prohibit from being selected  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectionIndexPath = self.productTable.indexPathForSelectedRow {
            self.productTable.deselectRow(at: selectionIndexPath, animated: animated)
        }
    }

}

extension RecipeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchRecipe.products.count+1   //add row
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let count = self.searchRecipe.products.count

        var identifier = "recipeAddCell"

        if row < count {
            identifier = "recipeCell"
        }

        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? RecipeTableViewCell else {
                return RecipeTableViewCell()
        }

        if row < count {
            let productCell = searchRecipe.products[indexPath.row]

            cell.checkboxHandler = { () -> Void in
                self.searchRecipe.toggleCheck(product: productCell.product)
            }

            cell.checkbox.on = productCell.on
            cell.productLabel.text = productCell.product.name
            let price = productCell.product.price * Decimal.init(productCell.product.getBundleTuple(input: "").number)
            cell.priceLabel.text = String(describing: price).appending(" 원")
            let unit = " ".appending(productCell.product.getBundleTuple(input: "").unit)
            cell.eaLabel.text = productCell.number.description.appending(unit)

            cell.disclosureHandler = { () -> Void in
                if self.searchRecipe.products[indexPath.row].on {
                    self.performSegue(withIdentifier: "RecipeToProduct", sender: productCell)
                }
            }
        } else {
            cell.checkbox.isHidden = true

            let addButton = UIImageView.init(frame: CGRect(x: 10, y: 15, width: 20, height: 20))
            addButton.image = UIImage.init(named: "logo.png")
            cell.addSubview(addButton)

            cell.productLabel.text = "추가하기"

            cell.disclosureHandler = { () -> Void in
                self.performSegue(withIdentifier: "RecipeToSearchProduct", sender: nil)
            }
        }
        return cell
    }

}
