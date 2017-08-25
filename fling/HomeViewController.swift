//
//  HomeViewController.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 9..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HomeViewController: UIViewController {

    let network = Network()
    let alertController = UIAlertController(title: nil, message: "Please wait\n\n", preferredStyle: .alert)
    var recipes = [Recipe]()
    var fridge = Refrigerator()
    var searchRecipe = Recipe.init()

    private let sampleRecipe = Notification.Name.init(rawValue: "sampleRecipe")
    private let flingRecipe = Notification.Name.init(rawValue: "flingRecipe")
    private let failFlingRecipe = Notification.Name.init(rawValue: "failFlingRecipe")

    @IBOutlet var homeView: UIView!
    @IBOutlet weak var sampleRecipeCollection: UICollectionView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var urlWarningLabel: UILabel!
    @IBAction func searchButton(_ sender: Any) {
        if checkRecipeUrl(url: self.urlField.text ?? "") {
            network.getRecipeWith(url: self.urlField.text ?? "")
        } else {
            urlWarningLabel.isHidden = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        let logo = UIImage(named: "fling_logo_white.png")
        let imageView = UIImageView(image: logo)
        imageView.frame.size = CGSize(width: 375, height: 30)
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        self.fridge = appDelegate.fridge

        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
        homeView.addGestureRecognizer(tap)

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: sampleRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: flingRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: failFlingRecipe, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification),
                                               name: Notification.Name.init(rawValue: "UIKeyboardWillShowNotification"),
                                               object: nil)

        network.getFlingRecipe()

        sampleRecipeCollection.register(CRVHomeTopHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "topHeader")
        sampleRecipeCollection.register(CRVHomeMidHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "midHeader")

        
        //urlWarningLabel.layer.cornerRadius = 5
    }

    override func viewWillDisappear(_ animated: Bool) {
        homeView.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func keyboardWillShow() {
//        urlWarningLabel.isHidden = true
    }

    func dismissKeyboard() {
        homeView.endEditing(true)
    }

    func reciveNotification(moveNoti: Notification) {
        if moveNoti.name == Notification.Name.init("moveToRecipe") {
            self.performSegue(withIdentifier: "HomeToRecipe", sender: self.urlField.text!)
                   } else {
            // 올바르지 않은 url??
        }
        // 팝업 끄기
    }

    func recieveNotification(notification: Notification) {
        if notification.name == sampleRecipe {
            guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
                return
            }
            self.recipes = recipes
            sampleRecipeCollection.reloadData()
        } else if notification.name == Notification.Name.init(rawValue: "UIKeyboardWillShowNotification") {
            keyboardWillShow()
        } else if notification.name == flingRecipe {
//            alertController.dismiss(animated: true, completion: nil)
            guard let recipe = notification.userInfo?["data"] as? Recipe else {
                return
            }
            let filter = ProductFilter()
            filter.filterProduct(recipe: recipe, fridge: fridge)
            self.searchRecipe = recipe
            self.performSegue(withIdentifier: "HomeToRecipe", sender: self.searchRecipe)

        } else if notification.name == failFlingRecipe {
//            alertController.dismiss(animated: true, completion: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "HomeToRecipe" {
            guard let secondViewController = segue.destination as? RecipeViewController else {
                return
            }
            guard let searchRecipe = sender as? Recipe else {
                return
            }
            secondViewController.searchRecipe = searchRecipe
        }
    }

    func checkRecipeUrl(url: String) -> Bool {
        if !url.contains("haemukja.com/recipes/") {
            return false
        }
        return true
    }
}

//return으로 검색하게
//extension HomeViewController: UITextFieldDelegate {
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
//}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 6
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let header = sampleRecipeCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "topHeader", for: indexPath) as! CRVHomeTopHeader
            return header

        } else {
            let header = sampleRecipeCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "midHeader", for: indexPath) as! CRVHomeMidHeader
            return header
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        let collectionViewSize = sampleRecipeCollection.frame.size.width

        if section == 0 {
            let size = CGSize.init(width: collectionViewSize, height: 300)
            return size
        } else {
            let size = CGSize.init(width: collectionViewSize, height: 100)
            return size
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            sampleRecipeCollection.dequeueReusableCell(withReuseIdentifier: "mainRecipeCell", for: indexPath)
                as? HomeRecipeCollectionViewCell else {
                    return HomeRecipeCollectionViewCell()
        }
    
        // for collection view image position padding!
        var padding = CGFloat.init(0)
        if indexPath.row%2 == 0 {
            padding =  CGFloat.init(10)
        }
        
        let collectionViewSize = sampleRecipeCollection.frame.size.width
        let cgSize = CGSize.init(width: collectionViewSize/2, height: collectionViewSize/2 + 10)
        cell.frame.size = cgSize

        if recipes.count > 0 {
            if recipes[indexPath.row].image != "" {
                cell.sampleRecipeImage?.af_setImage(withURL: URL(string: recipes[indexPath.row].image)!)
            }
            cell.sampleRecipeImage.frame.size = CGSize(width: collectionViewSize/2 - 20, height: collectionViewSize/2 - 20)
          
            cell.sampleRecipeImage.frame.origin = CGPoint(x: padding, y: 0)
            
            cell.sampleRecipeLabel.text = recipes[indexPath.row].title
            cell.sampleRecipeSubtitleLabel.text = recipes[indexPath.row].subtitle
            cell.clickHandler = { () -> Void in
                self.network.getRecipeWith(recipeId: self.recipes[indexPath.row].rid)
            }
        }

        return cell
    }
}
