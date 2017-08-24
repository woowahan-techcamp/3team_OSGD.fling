//
//  CRVHomeTopHeader.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

class CRVHomeTopHeader: UICollectionReusableView {
    var headerImage: UIImageView
    var headerFilter: UIImageView
    var keywordInput: UITextField
    var searchButton: UIButton
    var line: UIView
    
    let screenWidth = UIScreen.main.bounds.width
    
    override init(frame: CGRect) {
        
        keywordInput = UITextField()
        headerImage = UIImageView()
        headerFilter = UIImageView()
        searchButton = UIButton(type: .custom)
        line = UIView()
        
        super.init(frame: frame)
        
        headerImage.image = UIImage.init(named: "main_image.png")
        headerImage.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 200)
        headerImage.layer.masksToBounds = true
        
        headerFilter.frame = CGRect.init(x:0, y:0, width: self.frame.width, height: headerImage.frame.height)
        headerFilter.backgroundColor = UIColor.black
        headerFilter.alpha = 0.6
        
        let xPadding = CGFloat(30)
        let heightForInput = CGFloat(13)
        let widthForInput = headerImage.frame.width - 2 * xPadding
        let yPadding = headerImage.frame.height/2
        keywordInput.frame = CGRect.init(x: xPadding, y: yPadding, width: widthForInput, height: heightForInput)
        keywordInput.textColor = UIColor.white
        keywordInput.placeholder = "레시피를 장바구니에 담아드립니다."
        keywordInput.setValue(UIColor.white, forKeyPath: "_placeholderLabel.textColor")
        keywordInput.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightUltraLight)
        
        let xForSearchButton = xPadding + widthForInput
        let yForSearchButton = yPadding
        searchButton.setImage(UIImage(named: "search_icon1x.png" ), for: .normal)
        searchButton.frame = CGRect.init(x: xForSearchButton - 10, y: yForSearchButton - 5, width: 22, height: 22)
        
        line.backgroundColor = UIColor.white
        
        
        self.addSubview(headerImage)
        self.addSubview(headerFilter)
        self.addSubview(keywordInput)
        self.addSubview(searchButton)


        self.backgroundColor = .white
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
