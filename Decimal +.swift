//
//  String +.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 21..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

extension Decimal {
    mutating func addPriceTag() -> String {
        let price = NSNumber.init(value: (self as NSDecimalNumber).doubleValue)
        let result = NumberFormatter.localizedString(from: price, number: NumberFormatter.Style.decimal)
        return "총액 : ".appending(result.appending(" 원"))
    }

    mutating func addPriceTagWithoutTotal() -> String {
        let price = NSNumber.init(value: (self as NSDecimalNumber).doubleValue)
        let result = NumberFormatter.localizedString(from: price, number: NumberFormatter.Style.decimal)
        return result.appending(" 원")
    }

    mutating func addUnitTag(unit: String) -> String {
        let price = NSNumber.init(value: (self as NSDecimalNumber).doubleValue)
        let result = NumberFormatter.localizedString(from: price, number: NumberFormatter.Style.decimal)
        return result.appending(unit)
    }
}
