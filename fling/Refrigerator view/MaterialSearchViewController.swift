//
//  MaterialSearchViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class MaterialSearchViewController: UIViewController, UISearchBarDelegate {

    let searchMaterial = Notification.Name.init("searchMaterial")
    var searchList = SearchList.init()
    let network = Network.init()
    var keyword = ""
    let keywordHighlight = KeywordHighlight()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(drawSearchList),
                                               name: searchMaterial, object: nil)

        self.searchTable.separatorInset.right = 15
    }

    func drawSearchList(noti: Notification) {
        if let data = noti.userInfo?["data"] as? SearchList {
            self.searchList = data
            self.searchTable.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count != 0 {
            keyword = searchText
            self.network.searchMaterialsWith(keyword: searchText)
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "unwindToRefrigerator" {
            guard let secondViewController = segue.destination as? RefrigeratorViewController else {
                return
            }
            guard let material = sender as? Material else {
                return
            }
            secondViewController.data = material
        }
    }
}

extension MaterialSearchViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchList.result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable line_length
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "materialCell", for: indexPath) as? MaterialSearchTableViewCell
        else {
            return MaterialSearchTableViewCell()
        }

        let result = self.searchList.result[indexPath.row].name
        cell.materialLabel.attributedText = keywordHighlight.addBold(keyword: keyword, text: result)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = self.searchList.result[indexPath.row]
        let material = Material.init(mid: selected.id, name: selected.name)
        self.performSegue(withIdentifier: "unwindToRefrigerator", sender: material)
        self.view.endEditing(true)
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}
