//
//  CRVHomeMidHeader.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CRVHomeMidHeader: UICollectionReusableView {
    var seasonLabel: UILabel
    
    override init(frame: CGRect) {
        seasonLabel = UILabel()
        
        super.init(frame: frame)
        
        seasonLabel.text = "여름엔 플링"
        seasonLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightUltraLight)
        seasonLabel.textAlignment = NSTextAlignment.center
        seasonLabel.frame = CGRect.init(x:0, y: 50, width: self.frame.width, height: 18)
        
        self.addSubview(seasonLabel)
        
        self.backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
