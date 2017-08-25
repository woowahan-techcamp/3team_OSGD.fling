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
    var storage = Storage()
    var data = Material()

    @IBOutlet weak var tableView: UITableView!

    @IBAction func unwindToRefrigerator(segue: UIStoryboardSegue) {
        if !self.fridge.materials.contains { $0.mid == data.mid } {
            fridge.add(material: data)
        }
        storage.saveFridge(fridge: fridge)
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        fridge = appDelegate.fridge
        self.tableView.tableFooterView = UIView()
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

        cell.materialLabel.text = fridge.materials[indexPath.row].name

        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            fridge.remove(materialAt: indexPath.row)
            storage.saveFridge(fridge: fridge)
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
