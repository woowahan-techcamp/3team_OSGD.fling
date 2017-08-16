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
    typealias ListProduct = [(product: Product, number: Int, on: Bool)]
    public private(set) var products: ListProduct

    init() {
        self.rid = 0
        self.title = ""
        self.subtitle = ""
        self.url = ""
        self.image = ""
        self.writer = ""
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

        self.rid = id
        self.title = title
        self.subtitle = subtitle
        self.url = url
        self.image = image
        self.writer = writer
        self.products = []
    }

    func indexOf(product: Product) -> Int {
        var result = -1
        for (index, object) in products.enumerated() where object.product == product {
            result = index
        }
        return result
    }

    func add(product: Product) {
        let index = indexOf(product: product)

        if index == -1 {    //추가(생성)
            products.append((product: product, number: 1, on: true))
        } else {
            products[index].number += 1
        }
    }

    func totalPrice() -> String {
        var total = Decimal()
        products.forEach { object in
            let ea = Decimal.init(object.number)
            total += (object.product.getPrice() * ea)
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
        }
    }
}
