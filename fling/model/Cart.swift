//
//  Cart.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class Cart {

    var recipes = [Recipe]()

    init() {
    }

    func add(recipe: Recipe) {
        self.recipes.append(recipe)
    }

    func remove(recipeAt: Int) {
        self.recipes.remove(at: recipeAt)
    }

    func totalPrice() -> Decimal {
        var result = Decimal.init(0)
        self.recipes.forEach { object in
            result += object.totalPrice()
        }

        return result
    }
}
