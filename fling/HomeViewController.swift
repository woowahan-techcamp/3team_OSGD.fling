//
//  HomeViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let network = Network()

    @IBOutlet var homeView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(HomeViewController.dismissKeyboard))
        homeView.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func dismissKeyboard() {
        homeView.endEditing(true)
    }
}
