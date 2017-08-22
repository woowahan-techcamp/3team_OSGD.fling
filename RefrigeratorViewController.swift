//
//  RefrigeratorViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class RefrigeratorViewController: UIViewController {

    var fridge = Refrigerator()
    var data = Material()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension RefrigeratorViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fridge.materials.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable line_length
        guard let cell =
            tableView.dequeueReusableCell(withIdentifier: "fridgeCell", for: indexPath) as? RefrigeratorTableViewCell else {
            return RefrigeratorTableViewCell()
        }

        cell.textLabel?.text = fridge.materials[indexPath.row].name

        return cell
    }
}
