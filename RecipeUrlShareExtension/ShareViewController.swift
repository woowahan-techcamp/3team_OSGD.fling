//
//  ShareViewController.swift
//  RecipeUrlShareExtension
//
//  Created by woowabrothers on 2017. 8. 24..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Alamofire

class ShareViewController: SLComposeServiceViewController {
    
    private var products = [ShareProduct]()
    fileprivate var selectedShareProduct: ShareProduct?
    var recipeInfo = ["url": "", "title": "", "writer": ""]
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        //products.value = selectedShareProduct?.title
        if let products = SLComposeSheetConfigurationItem() {
            products.title = recipeInfo["title"] ?? ""
            products.value = "재료 선택하기"
            products.tapHandler = {
                let vc = ExtensionRecipeViewController()
                vc.userShareProducts = self.products
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [products]
        }
        return nil
    }
    
    override func viewDidLoad() {
        
        loadUrlFromExtension()
        
        drawShareView()
        
        for i in 1...3 {                //API 호출로 변경하기
            let product = ShareProduct()
            product.name = "ShareProduct \(i)"
            products.append(product)
        }

        selectedShareProduct = products.first
        
    }
    
    func drawShareView() {
        let imageView = UIImageView(image: UIImage(named: "fling_logo_white.png"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
        navigationController?.navigationBar.topItem?.titleView = imageView  //title logo 안 붙음
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.backgroundColor = UIColor(red:1.00, green:0.72, blue:0.26, alpha:1.0)
    }
    
    func loadUrlFromExtension() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem else {
            return
        }
        guard let itemProvider = extensionItem.attachments?.first as? NSItemProvider else {
            return
        }
        let propertyList = String(kUTTypePropertyList)
        
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            //swiftlint:disable line_length unused_closure_parameter
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary {
                        if let urlString = results["URL"] as? String,
                            let titleString = results["title"] as? String,
                            let writerString = results["writer"] as? String {
                            self.recipeInfo["url"] = urlString
                            self.recipeInfo["title"] = titleString
                            self.recipeInfo["writer"] = writerString
                            self.loadRecipeInfo()
                        }
                    }
                }
            })
        } else {
            print("error")
            //예외 처리 해주기
        }
    }
    
    func loadRecipeInfo() {
        func getRecipeWith(url: String) {
            let mainUrl = "http://52.79.119.41/recipes/"
            let parameters: Parameters = ["url": url]
            // All three of these calls are equivalent
            Alamofire.request(mainUrl, method: .post, parameters: parameters).responseJSON { response in
//                if let recipeData = response.result.value as? [String: Any] {
//                    let recipe = Recipe.init(data: recipeData)
//                    let productUrl = self.productUrl.appending((recipe?.rid.description)!)
//                    Alamofire.request(productUrl).responseJSON(completionHandler: { response in
//                        if let products = response.result.value as? [[String: Any]] {
//                            products.forEach({ object in
//                                recipe?.add(product: Product.init(data: object)!, number: 1)
//                            })
//                            NotificationCenter.default.post(name: self.flingRecipe,
//                                                            object: self, userInfo: ["data": recipe ?? ""])
//                        }
//                    })
//                } else {
//                    NotificationCenter.default.post(name: self.failNetwork,
//                                                    object: self, userInfo: [:])
//                }
            }
        }

        var url = self.recipeInfo["url"] ?? ""
        url = url.replace(target: "//m.", withString: "//").replace(target: "/#/", withString: "/")
        getRecipeWith(url: url)
    }
}

extension ShareViewController: ExtensionRecipeViewControllerDelegate {
    func selected(products: ShareProduct) {
        selectedShareProduct = products
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
