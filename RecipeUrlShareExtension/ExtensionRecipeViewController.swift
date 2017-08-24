//
//  ExtensionRecipeViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

protocol ExtensionRecipeViewControllerDelegate: class {
    func selected(deck: Deck)
}

class ExtensionRecipeViewController: UIViewController {

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.frame)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "simpleProductCell")
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    var userDecks = [Deck]()
    weak var delegate: ExtensionRecipeViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        title = "재료 선택하기"
        let done = UIBarButtonItem.init(barButtonSystemItem: .done, target: self,
                                        action: nil)        //todo
        navigationItem.rightBarButtonItem = done
        view.addSubview(tableView)
    }
}

extension ExtensionRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userDecks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleProductCell", for: indexPath)
        cell.textLabel?.text = userDecks[indexPath.row].title
        cell.backgroundColor = .clear
        cell.editingAccessoryType = .checkmark
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("row clicked", indexPath.row)
        delegate?.selected(deck: userDecks[indexPath.row])
    }
}
