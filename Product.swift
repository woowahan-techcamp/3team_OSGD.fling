//
//  Product.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Product {

    private let pid: Int //상품 아이디
    private let mid: Int //재료 아이디(참조)
    private let name: String
    private let price: Decimal
    private let weight: String
    private let bundle: String
    private let image: String

    init(pid: Int, mid: Int, name: String, price: Decimal, weight: String, bundle: String, image: String) {
        self.pid = pid
        self.mid = mid
        self.name = name
        self.price = price
        self.weight = weight
        self.bundle = bundle
        self.image = image
    }

    init?(data: [String:Any]) {
        guard let pid = data["id"]! as? Int,
            let name = data["name"]! as? String,
            let price = data["price"]! as? String,
            let weight = data["weight"]! as? String,
            let bundle = data["bundle"]! as? String,
            let image = data["image"]! as? String else {
                return nil
        }

//        guard let mid = data["material_id"]! as? Int else {
//            return nil
//        }
        let mid = 0

        let decimalPrice = NSDecimalNumber.init(string: price)

        self.pid = pid
        self.mid = mid
        self.name = name
        self.price = decimalPrice as Decimal
        self.weight = weight
        self.bundle = bundle
        self.image = image
    }

    func getId() -> Int {
        return self.pid
    }
    func getMaterialId() -> Int {
        return self.mid
    }
    func getName() -> String {
        return self.name
    }
    func getPrice() -> Decimal {
        return self.price
    }
    func getWeight() -> String {
        return self.weight
    }
    func getBundle() -> String {
        return self.bundle
    }
    func getImage() -> String {
        return self.image
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.getId() == rhs.getId()
    }
}
