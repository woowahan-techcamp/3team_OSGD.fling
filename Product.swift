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
    private var bundle: String
    private let image: String
    
    init() {
        self.pid = 0
        self.mid = 0
        self.name = ""
        self.price = 0
        self.weight = ""
        self.bundle = ""
        self.image = ""
    }
    
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
        
        var mid = 0
        if data["material_id"] != nil {
            guard let material_id = data["material_id"]! as? Int else {
                return nil
            }
            mid = material_id
        }
        
        let decimalPrice = NSDecimalNumber.init(string: price.replacingOccurrences(of: ",", with: ""))
        
        self.pid = pid
        self.mid = mid
        self.name = name
        self.price = decimalPrice as Decimal
        self.weight = weight
        self.bundle = bundle
        self.image = image
    }
    
    func setBundle(input: String) {
        self.bundle = input
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
        if self.image.contains("http://") {
            return self.image
        } else {
            return "http://" + self.image
        }
    }
    
    func getBundleTuple(input: String) -> (number: Int, unit: String) {
        var bundle = input
        var number = ""
        var unit = ""
        
        if input == "" {
            bundle = self.bundle
        }
        
        for character in bundle.characters {
            if Int.init(character.description) != nil {
                number.append(character)
            } else if character.description == " " {
                //pass
            } else {
                unit.append(character)
            }
        }
        
        guard let converted = Int.init(number) else {
            return (number: 1, unit: "개")
        }
        
        if unit == "" {
            unit = "개"
        }
        
        return (number: converted, unit: unit)
    }
    
    func getBundleString(input: String) -> String {
        var bundle = input
        var number = ""
        var unit = ""
        
        if input == "" {
            bundle = self.bundle
        }
        
        for character in bundle.characters {
            if Int.init(character.description) != nil {
                number.append(character)
            } else if character.description == " " {
                //pass
            } else {
                unit.append(character)
            }
        }
        
        guard let converted = Int.init(number) else {
            return "1 개"
        }
        
        if unit == "" {
            unit = "개"
        }
        
        return converted.description.appending(" ").appending(unit)
    }
}

extension Product: Equatable {
    static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.getId() == rhs.getId()
    }
}
