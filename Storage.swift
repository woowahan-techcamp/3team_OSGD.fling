//
//  Storage.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Storage {

    init() {
    }

    func saveCart(cart: Cart) {
        var result = [[String: Any]]()
        cart.recipes.forEach { (recipe) in
            let products = recipe.products.map({["number": $0.number, "id": $0.product.pid,
                                                 "bundle": $0.product.bundle.description,
                                                 "image": $0.product.image.description,
                                                 "name": $0.product.name.description,
                                                 "price": $0.product.price.description,
                                                 "weight": $0.product.weight.description,
                                                 "material_id": $0.product.mid]})
            let recipe = ["id": recipe.rid, "image": recipe.image.description, "missed": recipe.missed.description,
                          "original": recipe.original.description, "serving": recipe.serving.description,
                          "subtitle": recipe.subtitle.description, "title": recipe.title.description,
                          "url": recipe.url.description, "writer": recipe.writer.description,
                          "products": products] as [String : Any]
            result.append(recipe)
        }
        UserDefaults.standard.set(result, forKey: "myCart")
    }

    func loadCart() -> Cart {
        let cart = Cart.init()
        if let loadedCart = UserDefaults.standard.array(forKey: "myCart") as? [[String: Any]] {
            for item in loadedCart {
                if let recipe = Recipe.init(data: item) {
                    guard let productsData = item["products"] as? [[String: Any]] else { return cart }
                    productsData.forEach({ (productData) in
                        guard let number = productData["number"] as? Int else { return }
                        if let product = Product.init(data: productData) {
                            recipe.add(product: product, number: number)
                        }
                    })
                    cart.add(recipe: recipe)
                }
            }
        }
        return cart
    }
}
