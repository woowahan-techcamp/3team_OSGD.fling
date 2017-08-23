//
//  ProductFilter.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 23..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class ProductFilter {

    func filterProduct(recipe: Recipe, fridge: Refrigerator) {
        var indexs = [Int]()
        fridge.materials.forEach { material in
            for index in 0..<recipe.products.count where (material.mid == recipe.products[index].product.mid) {
                indexs.append(index)
            }
        }

        for index in indexs.sorted().reversed() {
            recipe.remove(productAt: index)
        }
    }
}
