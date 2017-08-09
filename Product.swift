//
//  Product.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Product {

    private let pid: String
    private let name: String
    private let price: Decimal
    private let weight: String

    init(pid: String, name: String, price: Decimal, weight: String) {
        self.pid = pid
        self.name = name
        self.price = price
        self.weight = weight
    }

    init?(data: [String:Any]) {
        guard let id = data["id"]! as? String,
            let name = data["name"]! as? String,
            let price = data["price"]! as? Decimal,
            let weight = data["weight"]! as? String else {
                return nil
        }

        self.pid = id
        self.name = name
        self.price = price
        self.weight = weight
    }

    func getId() -> String {
        return self.pid
    }

    func getPrice() -> Decimal {
        return self.price
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.getId() == rhs.getId()
    }
}
