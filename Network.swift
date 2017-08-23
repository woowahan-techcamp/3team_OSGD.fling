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

    private let apiUrl = "http://52.79.119.41/"
    private let mainUrl = "http://52.79.119.41/recipes/"
    private let productUrl = "http://52.79.119.41/get_products/"
    private let searchProductUrl = "http://52.79.119.41/search_product/"
    private let searchMaterialUrl = "http://52.79.119.41/search_material/"
    private let sampleRecipe = Notification.Name.init(rawValue: "sampleRecipe")
    private let flingRecipe = Notification.Name.init(rawValue: "flingRecipe")
    private let failNetwork = Notification.Name.init(rawValue: "failNetwork")
    private let searchProduct = Notification.Name.init("searchProduct")
    private let getProduct = Notification.Name.init("getProduct")
    private let searchMaterial = Notification.Name.init("searchMaterial")

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
                            recipe?.add(product: Product.init(data: object)!, number: 1)
                        })
                        NotificationCenter.default.post(name: self.flingRecipe,
                                                        object: self, userInfo: ["data": recipe ?? ""])
                    }
                })
            } else {
                NotificationCenter.default.post(name: self.failNetwork,
                                                object: self, userInfo: [:])
            }
        }
    }

    func getRecipeWith(recipeId: Int) {
        let url = mainUrl.appending(recipeId.description)
        Alamofire.request(url).responseJSON { response in
            if let recipeData = response.result.value as? [String: Any] {
                let recipe = Recipe.init(data: recipeData)
                let productUrl = self.productUrl.appending((recipe?.rid.description)!)
                Alamofire.request(productUrl).responseJSON(completionHandler: { response in
                    if let products = response.result.value as? [[String: Any]] {
                        products.forEach({ object in
                            if let product = Product.init(data: object) {
                            recipe?.add(product: product, number: 1)
                            }
                        })
                        NotificationCenter.default.post(name: self.flingRecipe,
                                                        object: self, userInfo: ["data": recipe ?? ""])
                    }
                })
            } else {
                NotificationCenter.default.post(name: self.failNetwork,
                                                object: self, userInfo: [:])
            }
        }
    }

    func searchProductsWith(keyword: String) {
        let parameters: Parameters = ["keyword": keyword]
        Alamofire.request(searchProductUrl, method: .post, parameters: parameters).responseJSON { response in
            if let data = response.result.value as? [[String: Any]] {
                let searchList = SearchList.init(data: data)
                NotificationCenter.default.post(name: self.searchProduct, object: self, userInfo: ["data": searchList])
            } else {
            }
        }
    }

    func getProductWith(productId: Int) {
        let url = apiUrl.appending("products/" + productId.description)
        Alamofire.request(url).responseJSON { response in
            if let productData = response.result.value as? [String: Any],
                let product = Product.init(data: productData) {
                NotificationCenter.default.post(name: self.getProduct, object: self, userInfo: ["data": product])
            } else {
                NotificationCenter.default.post(name: self.failNetwork,
                                                object: self, userInfo: [:])
            }
        }
    }

    func searchMaterialsWith(keyword: String) {
        let parameters: Parameters = ["keyword": keyword]
        Alamofire.request(searchMaterialUrl, method: .post, parameters: parameters).responseJSON { response in
            if let data = response.result.value as? [[String: Any]] {
                let searchList = SearchList.init(data: data)
                NotificationCenter.default.post(name: self.searchMaterial, object: self, userInfo: ["data": searchList])
            } else {
            }
        }
    }
}
