//
//  RecipePopUpViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit
import AlamofireImage

class RecipePopUpViewController: UIViewController {

    var recipe = Recipe.init()

    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubtitleLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!

    @IBAction func closePopUp(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0
        }) { (success:Bool) in
            self.view.removeFromSuperview()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        self.popUpView.layer.cornerRadius = 5
        self.draw()
        self.productTableView.allowsSelection = false
        self.productTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func draw() {
        if self.recipe.title != "" {
            recipeTitleLabel.text = recipe.title
            recipeSubtitleLabel.text = recipe.subtitle
            recipeImage.af_setImage(withURL: URL(string: recipe.image)!)
            var price = recipe.totalPrice()
            totalPriceLabel.text = price.addPriceTag()
        }
    }

}

extension RecipePopUpViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable line_length
        guard let cell =
            productTableView.dequeueReusableCell(withIdentifier: "popUpCell", for: indexPath) as? RPTableViewCell else {
                return RPTableViewCell()
        }
        let selectedProduct = self.recipe.products[indexPath.row]
        var price = selectedProduct.product.price
        cell.priceLabel.text = price.addPriceTag()
        cell.productLabel.text = selectedProduct.product.name
        let unit = " ".appending(selectedProduct.product.getBundleTuple(input: "").unit)
        cell.eaLabel.text = selectedProduct.number.description.appending(unit)
        return cell
    }
}
