//
//  Product.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Product {

    private let id: String
    private let name: String
    private let price: Decimal
    private let weight: String

    init() {
    }

    func getId() -> String {
        return self.id
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
