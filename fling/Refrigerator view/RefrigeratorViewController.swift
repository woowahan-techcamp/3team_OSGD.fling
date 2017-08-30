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
        self.noneView.isHidden = true
        self.message.isHidden = true
        self.tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        fridge = appDelegate.fridge
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset.right = 15
        
        if fridge.materials.count == 0 {
            drawEmpty()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    let noneView = UIImageView()
    let message = UILabel.init()

    func drawEmpty() {
        let none = UIImage.init(named: "none.png")
        noneView.image = none
        noneView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 140)
        noneView.center.x = self.view.center.x
        noneView.center.y = self.view.center.y - 50
        self.view.addSubview(noneView)
        
        message.font = UIFont.systemFont(ofSize: 14)
        message.text = "담긴 재료가 없습니다."
        message.textAlignment = .center
        message.frame = CGRect.init(x: 0, y: 0, width: 300, height: 30)
        message.center.x = self.view.center.x
        message.center.y = self.view.center.y + 60
        self.view.addSubview(message)
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
            
            if fridge.materials.count == 0 {
                drawEmpty()
            }
        }
    }
}
