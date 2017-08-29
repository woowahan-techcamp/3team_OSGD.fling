//
//  KeywordHighlight.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class KeywordHighlight {
    func addBold(keyword: String, text: String) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let replace = "*"
        var tempText = text.replace(target: keyword, withString: replace)

        for character in tempText.characters {
            if character.description == "*" {
                result.bold(keyword)
            } else {
                result.normal(character.description)
            }
        }
        return result
    }
}
