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

    let mainUrl = "http://52.78.41.124/recipes"
    let productUrl = "http://52.78.41.124/get_products/1"

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
            NotificationCenter.default.post(name: Notification.Name.init(rawValue: "flingRecipe"),
                                            object: self, userInfo: ["data": recipes])
        }
    }
    
    func getRecipeWith(url: String) {
        let parameters: Parameters = ["url": url]
        // All three of these calls are equivalent
        Alamofire.request(mainUrl, method: .post, parameters: parameters).responseJSON { response in
            if let recipeData = response.result.value as? [String: Any] {
                let recipe = Recipe.init(data: recipeData)
                Alamofire.request(self.productUrl).responseJSON(completionHandler: { response in
                    if let products = response.result.value as? [[String: Any]] {
                    print(products)
                }
            })
            }
        }
    }
}
