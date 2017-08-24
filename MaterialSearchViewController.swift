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

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTable: UITableView!
    @IBAction func doneButton(_ sender: Any) {
        if searchTable.indexPathForSelectedRow != nil {
            let index = searchTable.indexPathForSelectedRow!.row
            let selected = self.searchList.result[index]
            let material = Material.init(mid: selected.id, name: selected.name)
            self.performSegue(withIdentifier: "unwindToRefrigerator", sender: material)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(drawSearchList),
                                               name: searchMaterial, object: nil)
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

        cell.materialLabel.text = self.searchList.result[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
}
