//
//  Material.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 22..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Material {
    var mid: Int
    var name: String

    init() {
        self.mid = 0
        self.name = ""
    }

    init(mid: Int, name: String) {
        self.mid = mid
        self.name = name
    }
}
