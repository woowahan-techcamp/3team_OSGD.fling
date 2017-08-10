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


    var products = [Product]()

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitleLabel: UILabel!
    @IBOutlet weak var recipeSubTitleLabel: UILabel!
    @IBOutlet weak var recipeExcept: UILabel!

    @IBOutlet weak var productTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //temp
        let temp = [
            ["id": 11, "material_id": 1, "name": "삼원농산 영양듬뿍 잡곡 귀리", "price": "5700", "weight": "5kg", "bundle": "1개", "image": "t5a.coupangcdn.comthumbnailsremote292x292eximageproductimagevendoritem201604193000580651036da747-80bb-40d8-9285-0f78f3dcaf50.jpg"],
            ["id": 22, "material_id": 2, "name": "순수담 귀리볶음가루", "price": "10000", "weight": "1kg", "bundle": "1개", "image": "t1c.coupangcdn.comthumbnailsremote292x292eximageretailimages20160422182aab0317e-1cee-422b-bd46-9661393d3e17.JPG"],
            ["id": 33, "material_id": 3, "name": "오뚜기 옛날 구수한 누룽지", "price": "14900", "weight": "3kg", "bundle": "1개", "image": "t2a.coupangcdn.comthumbnailsremote292x292eximageproductimagevendoritem201605173011864835d34b6acd-6756-4838-bee5-1094f3843f46.jpg"]
        ]
        products.append(Product(data: temp[0])!)
        products.append(Product(data: temp[1])!)
        products.append(Product(data: temp[2])!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
            as! RecipeTableViewCell

        cell.textLabel?.text = products[indexPath.row].getName() as? String

        let price = String(describing: products[indexPath.row].getPrice())
        cell.detailTextLabel?.text = price

        return cell
    }
}
