//
//  ProductSearchViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 16..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class ProductSearchViewController: UIViewController, UISearchBarDelegate {

    private let searchProduct = Notification.Name.init("searchProduct")
    var searchList = SearchList.init()

    let network = Network.init()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(drawSearchList),
                                               name: searchProduct, object: nil)
    }

    func drawSearchList(noti: Notification) {
        if let data = noti.userInfo?["data"] as? SearchList {
            self.searchList = data
            self.searchTable.reloadData()}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count != 0 {
            self.network.searchProductsWith(keyword: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchText \(String(describing: searchBar.text))")
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
        cell.productLabel.text = self.searchList.result[indexPath.row].name
        return cell
    }
}
