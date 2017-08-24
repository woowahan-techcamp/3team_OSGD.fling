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

class ShareViewController: SLComposeServiceViewController {

    private var userDecks = [Deck]()
    fileprivate var selectedDeck: Deck?

    override func isContentValid() -> Bool {
        return true
    }

    override func didSelectPost() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        //deck.value = selectedDeck?.title
        if let deck = SLComposeSheetConfigurationItem() {
            deck.title = "재료 선택하기"
            deck.value = ""
            deck.tapHandler = {
                let vc = ExtensionRecipeViewController()
                vc.userDecks = self.userDecks
                vc.delegate = self
                self.pushConfigurationViewController(vc)
            }
            return [deck]
        }
        return nil
    }

    override func viewDidLoad() {

        loadUrlFromExtension()

        drawShareView()

        for i in 1...3 {                //API 호출로 변경하기
            let deck = Deck()
            deck.title = "Deck \(i)"
            userDecks.append(deck)
        }

        selectedDeck = userDecks.first

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
        //swiftlint:disable force_cast
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)

        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            //swiftlint:disable line_length unused_closure_parameter
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String//,
                        /*let url = NSURL(string: urlString)*/ {
                        print("URL retrieved: \(urlString)")
                    }
                }
            })
        } else {
            print("error")
        }
    }
}

extension ShareViewController: ExtensionRecipeViewControllerDelegate {
    func selected(deck: Deck) {
        selectedDeck = deck
        reloadConfigurationItems()
        popConfigurationViewController()
    }
}
