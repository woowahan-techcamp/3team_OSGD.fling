//
//  NSAttributedString +.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let boldString = NSMutableAttributedString(string:"\(text)",
            attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize:17)])
        self.append(boldString)
        return self
    }

    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName: UIColor.gray])
        self.append(normal)
        return self
    }
}
