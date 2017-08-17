//
//  SearchList.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 17..
//  Copyright © 2017년 osgd. All rights reserved.
//

import Foundation

class SearchList {
    typealias SearchResult = (id: Int, name: String)
    public private(set) var result = [SearchResult]()

    init() {
        self.result = []
    }
    
    init(data: [[String:Any]]) {
        data.forEach { object in
            guard let searchId = object["id"]! as? Int,
                let name = object["name"]! as? String else {
                    return
            }
            self.result.append((id: searchId, name: name))
        }
    }
}
