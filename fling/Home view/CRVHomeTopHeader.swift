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
    var flingHotLabel: UILabel
    var popupOpen:(() -> Void)!
    var popupClose:(() -> Void)!
    var editingKeyword: ((String) -> Void)!
    var scrollToHeader: (() -> Void)!
    let network = Network.init()
    let screenWidth = UIScreen.main.bounds.width

    //swiftlint:disable function_body_length
    override init(frame: CGRect) {
        keywordInput = UITextField()
        headerImage = UIImageView()
        headerFilter = UIImageView()
        searchButton = UIButton(type: .custom)
        line = UIView()
        flingHotLabel = UILabel()

        super.init(frame: frame)

        makeHeaderImage()

        let xPadding = CGFloat(30)
        let heightForInput = CGFloat(20)
        let widthForInput = headerImage.frame.width - 2 * xPadding
        let yPadding = headerImage.frame.height/2
        keywordInput.frame = CGRect.init(x: xPadding, y: yPadding, width: widthForInput, height: heightForInput)
        keywordInput.textColor = UIColor.white
        keywordInput.placeholder = "레시피를 장바구니에 담아드립니다."
        keywordInput.setValue(UIColor.lightGray, forKeyPath: "_placeholderLabel.textColor")
        keywordInput.font = UIFont.systemFont(ofSize: 13, weight: UIFontWeightUltraLight)
        keywordInput.addTarget(self, action: #selector(textBoxOn(_:)), for: .editingDidBegin)
        keywordInput.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)

        let xForSearchButton = xPadding + widthForInput
        let yForSearchButton = yPadding
        searchButton.setImage(UIImage(named: "search_icon1x.png" ), for: .normal)
        searchButton.frame = CGRect.init(x: xForSearchButton - 14, y: yForSearchButton - 8, width: 22, height: 22)
        searchButton.addTarget(self, action: #selector(searchRecipe), for: .touchDown)

        let xForLine = xPadding/2
        let yForLine = yPadding + keywordInput.frame.height + 8
        let widthForLine = headerImage.frame.width - 2 * xForLine
        line.backgroundColor = UIColor.white
        line.frame = CGRect.init(x: xForLine, y: yForLine, width: widthForLine, height: 1)

        let yForFlingHot = headerImage.frame.height + 60
        let widthForFlingHot = headerImage.frame.width
        flingHotLabel.text = "플링 인기 차트"
        flingHotLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightUltraLight)
        flingHotLabel.textAlignment = NSTextAlignment.center
        flingHotLabel.frame = CGRect.init(x:0, y: yForFlingHot, width: widthForFlingHot, height: 18)

        self.addSubview(headerFilter)
        self.addSubview(keywordInput)
        self.addSubview(searchButton)
        self.addSubview(line)
        self.addSubview(flingHotLabel)

        self.backgroundColor = .white
    }

    func makeHeaderImage() {
        headerImage.image = UIImage.init(named: "main_image.png")
        headerImage.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: 200)
        headerImage.layer.masksToBounds = true
        headerFilter.frame = CGRect.init(x:0, y:0, width: self.frame.width, height: headerImage.frame.height)
        headerFilter.backgroundColor = UIColor.black
        headerFilter.alpha = 0.6
        self.addSubview(headerImage)
    }

    func searchRecipe() {
        let url = keywordInput.text!
        popupClose()
        if url.contains("haemukja.com/recipes/") {
            network.getRecipeWith(url: url.modifyUrl())
        } else {
            NotificationCenter.default.post(name: network.failNetwork, object: nil)
        }
    }

    func textBoxOn(_ textField: UITextField) {
        scrollToHeader()
        popupOpen()
        if self.keywordInput.text != "" {
            network.searchRecipeWith(keyword: self.keywordInput.text!)
        }
    }

    func textChange(_ textField: UITextField) {
        network.searchRecipeWith(keyword: self.keywordInput.text!)
        editingKeyword(self.keywordInput.text ?? "")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
