//
//  ProductSearchViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class ProductSearchViewController: UIViewController, UISearchBarDelegate {

    let searchProduct = Notification.Name.init("searchProduct")
    let getProduct = Notification.Name.init("getProduct")
    var searchList = SearchList.init()
    let network = Network.init()
    let keywordHighlight = KeywordHighlight()
    var keyword = ""

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self

        NotificationCenter.default.addObserver(self, selector: #selector(drawSearchList),
                                               name: searchProduct, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(searchToProduct),
                                               name: getProduct, object: nil)

        self.searchTable.separatorInset.right = 15
    }

    func drawSearchList(noti: Notification) {
        if let data = noti.userInfo?["data"] as? SearchList {
            self.searchList = data
            self.searchTable.reloadData()}
    }

    func searchToProduct(noti: Notification) {
        if let data = noti.userInfo?["data"] as? Product {
            self.performSegue(withIdentifier: "ProductSearchToProduct", sender: data)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count != 0 {
            keyword = searchText
            self.network.searchProductsWith(keyword: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let searchText = searchBar.text
//        if searchText != nil && searchText?.characters.count != 0 {
//            self.network.searchProductsWith(keyword: searchText!)
//        }
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "ProductSearchToProduct" {
            guard let secondViewController = segue.destination as? ProductViewController else {
                return
            }
            guard let product = sender as? Product else {
                return
            }
            secondViewController.data = (product: product, number: 1, on: true)
        }
    }
}

extension ProductSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as? ProductSearchTableViewCell else {
                return ProductSearchTableViewCell()
        }

        let result = self.searchList.result[indexPath.row].name
        cell.productLabel.attributedText = keywordHighlight.addBold(keyword: keyword, text: result)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.network.getProductWith(productId: self.searchList.result[indexPath.row].id)
        self.view.endEditing(true)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}