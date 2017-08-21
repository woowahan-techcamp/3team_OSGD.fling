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
        let price = self.description
        return "총액 : ".appending(price.appending(" 원"))
    }
}
