//
//  Recipe.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Recipe {

    let rid: Int
    let title: String
    let subtitle: String
    let url: String
    let image: String
    let writer: String
    let serving: String
    let original: String
    let missed: String
    typealias ListProduct = [(product: Product, number: Int, on: Bool)]
    public private(set) var products: ListProduct

    private let priceModified = Notification.Name.init(rawValue: "PriceModified")

    init() {
        self.rid = 0
        self.title = ""
        self.subtitle = ""
        self.url = ""
        self.image = ""
        self.writer = ""
        self.serving = ""
        self.original = ""
        self.missed = ""
        self.products = ListProduct()
    }

    init?(data: [String:Any]) {
        guard let id = data["id"]! as? Int,
            let title = data["title"]! as? String,
            let subtitle = data["subtitle"]! as? String,
            let url = data["url"]! as? String,
            let image = data["image"]! as? String,
            let writer = data["writer"]! as? String else {
                return nil
        }

        var serving = ""
        if data["serving"] != nil {
            guard let text = data["serving"]! as? String else {
                return nil
            }
            serving = text
        }

        var missed = ""
        if data["missed_material"] != nil {
            guard let text = data["missed_material"]! as? String else {
                return nil
            }
            missed = text
        }

        var original = ""
        if data["recipe_material"] != nil {
            guard let text = data["recipe_material"]! as? String else {
                return nil
            }
            original = text
        }

        self.rid = id
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.image = image
        self.writer = writer
        self.serving = serving
        self.original = original
        self.missed = missed
        self.products = []
    }

    func indexOf(product: Product) -> Int {
        var result = -1
        for (index, object) in products.enumerated() where object.product == product {
            result = index
        }
        return result
    }

    func add(product: Product, number: Int) {
        let index = indexOf(product: product)

        if index == -1 {    //추가(생성)
            products.append((product: product, number: number, on: true))
        } else {
            products[index].number = number
        }
    }

    func totalPrice() -> String {
        var total = Decimal()
        products.forEach { object in
            if object.on == true {
                let ea = Decimal.init(object.number)
                total += (object.product.getPrice() * ea)
            }
        }
        let head = "총액 : "
        let tail = " 원"
        let price = total.description
        return head.appending(price).appending(tail)
    }

    func toggleCheck(product: Product) {
        let index = indexOf(product: product)

        if index >= 0 {
            products[index].on = !products[index].on
            NotificationCenter.default.post(name: self.priceModified, object: self, userInfo: [:])
        }
    }
}
