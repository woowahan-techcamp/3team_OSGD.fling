//
//  Refrigerator.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Refrigerator {
    var materials = [Material]()

    func add(material: Material) {
        self.materials.append(material)
    }

    func remove(materialAt: Int) {
        self.materials.remove(at: materialAt)
    }
}
