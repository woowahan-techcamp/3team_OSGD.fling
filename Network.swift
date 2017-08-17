//
//  Network.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation
import Alamofire

class Network {

    private let mainUrl = "http://52.78.41.124/recipes/"
    private let productUrl = "http://52.78.41.124/get_products/"
    private let sampleRecipe = Notification.Name.init(rawValue: "sampleRecipe")
    private let flingRecipe = Notification.Name.init(rawValue: "flingRecipe")
    private let failFlingRecipe = Notification.Name.init(rawValue: "FailFlingRecipe")

    func getFlingRecipe() {
        Alamofire.request(mainUrl).responseJSON { response in
            var recipes = [Recipe]()

            if let savedData = response.result.value as? [[String: Any]] {
                savedData.forEach({ object in
                    guard let recipe = Recipe.init(data: object) else {
                        return
                    }
                    recipes.append(recipe)
                })
            }
            NotificationCenter.default.post(name: self.sampleRecipe,
                                            object: self, userInfo: ["data": recipes])
        }
    }

    func getRecipeWith(url: String) {
        let parameters: Parameters = ["url": url]
        // All three of these calls are equivalent
        Alamofire.request(mainUrl, method: .post, parameters: parameters).responseJSON { response in
            if let recipeData = response.result.value as? [String: Any] {
                let recipe = Recipe.init(data: recipeData)
                let productUrl = self.productUrl.appending((recipe?.rid.description)!)
                Alamofire.request(productUrl).responseJSON(completionHandler: { response in
                    if let products = response.result.value as? [[String: Any]] {
                        products.forEach({ object in
                            recipe?.add(product: Product.init(data: object)!)
                        })
                        NotificationCenter.default.post(name: self.flingRecipe,
                                                        object: self, userInfo: ["data": recipe ?? ""])
                    }
                })
            } else {
                NotificationCenter.default.post(name: self.failFlingRecipe,
                                                object: self, userInfo: [:])
            }
        }
    }
    
    func getRecipeWith(recipe_id: Int) {
        let url = mainUrl.appending(recipe_id.description)
        Alamofire.request(url).responseJSON { response in
            if let recipeData = response.result.value as? [String: Any] {
                let recipe = Recipe.init(data: recipeData)
                Alamofire.request(self.productUrl).responseJSON(completionHandler: { response in
                    if let products = response.result.value as? [[String: Any]] {
                        products.forEach({ object in
                            recipe?.add(product: Product.init(data: object)!)
                        })
                        NotificationCenter.default.post(name: self.flingRecipe,
                                                        object: self, userInfo: ["data": recipe ?? ""])
                    }
                })
            } else {
                NotificationCenter.default.post(name: self.failFlingRecipe,
                                                object: self, userInfo: [:])
            }
        }

    }
}
