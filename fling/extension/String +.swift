//
//  String +.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

extension String {
    func replace(target: String, withString: String) -> String {
        //swiftlint:disable line_length
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    func modifyUrl() -> String {
        return self.replace(target: "//m.", withString: "//").replace(target: "/#/", withString: "/")
    }
}
