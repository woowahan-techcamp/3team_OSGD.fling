//
//  OrderViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 29..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var rabbitImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rabbit1 = UIImage.init(named: "rabbit_1.png")!
        let rabbit2 = UIImage.init(named: "rabbit_2.png")!
        
        let images = [rabbit1, rabbit2]
        
        let animated = UIImage.animatedImage(with: images, duration: 1.0)!
        
        rabbitImage.image = animated
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
