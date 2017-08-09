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

    let url = "http://52.78.41.124/recipes"

    func getFlingRecipe() {
        Alamofire.request(url).responseJSON { response in
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
}
