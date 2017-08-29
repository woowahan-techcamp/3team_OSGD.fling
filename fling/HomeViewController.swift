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
    var recipe = Recipe.init()
    var recipeSearchList = SearchList.init()
    
    private let sampleRecipe = Notification.Name.init(rawValue: "sampleRecipe")
    private let flingRecipe = Notification.Name.init(rawValue: "flingRecipe")
    private let failFlingRecipe = Notification.Name.init(rawValue: "failFlingRecipe")
    private let searchRecipe = Notification.Name.init("searchRecipe")
    
    @IBOutlet weak var recipeTableView: UITableView!
    @IBOutlet var searchPopUp: UIView!
    @IBOutlet var homeView: UIView!
    @IBOutlet weak var sampleRecipeCollection: UICollectionView!

    @IBOutlet weak var popupCloseButton: UIButton!
    @IBAction func popupCloseButton(_ sender: Any) {
        homeView.endEditing(true)
        self.popUpClose()
    }

    override func viewWillAppear(_ animated: Bool) {
        let logo = UIImage(named: "fling_logo_white.png")
        let imageView = UIImageView(image: logo)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = CGSize(width: 375, height: 30)
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
        sampleRecipeCollection.addGestureRecognizer(tap)
//        self.navigationController?.navigationBar.addGestureRecognizer(tap)

        tap.cancelsTouchesInView = false

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: sampleRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: flingRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: failFlingRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: searchRecipe, object: nil)

        network.getFlingRecipe()

        sampleRecipeCollection.register(CRVHomeTopHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "topHeader")
        sampleRecipeCollection.register(CRVHomeMidHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "midHeader")

        recipeTableView.tableFooterView = UIView()
        recipeTableView.separatorInset.right = recipeTableView.separatorInset.left
    }

    override func viewWillDisappear(_ animated: Bool) {
        homeView.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func dismissKeyboard() {
        homeView.endEditing(true)
        popUpClose()
    }

    func recieveNotification(notification: Notification) {
        if notification.name == sampleRecipe {
            guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
                return
            }
            self.recipes = recipes
            sampleRecipeCollection.reloadData()
        } else if notification.name == flingRecipe {
            guard let recipe = notification.userInfo?["data"] as? Recipe else {
                return
            }
            let filter = ProductFilter()
            filter.filterProduct(recipe: recipe, fridge: fridge)
            self.recipe = recipe
            self.performSegue(withIdentifier: "HomeToRecipe", sender: self.recipe)

        } else if notification.name == failFlingRecipe {
            // 예외 처리!
        } else if notification.name == searchRecipe {
            guard let recipeList = notification.userInfo?["data"] as? SearchList else { return }
            self.recipeSearchList = recipeList
            recipeTableView.isHidden = false
            recipeTableView.reloadData()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "HomeToRecipe" {
            guard let secondViewController = segue.destination as? RecipeViewController else {
                return
            }
            guard let recipe = sender as? Recipe else {
                return
            }
            secondViewController.searchRecipe = recipe
        }
    }

    func checkRecipeUrl(url: String) -> Bool {
        if !url.contains("haemukja.com/recipes/") {
            return false
        }
        return true
    }
    
    func popUpOpen() {
        let frame = CGRect(x: 15, y: 180, width: 345, height: 200)
        searchPopUp.frame = frame
        self.view.addSubview(self.searchPopUp)
        recipeTableView.allowsSelection = true
    }
    
    func popUpClose() {
        self.searchPopUp.removeFromSuperview()
        recipeTableView.isHidden = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch")
        
        let touch: UITouch? = touches.first

        if touch?.view != searchPopUp {
            self.popUpClose()
            homeView.endEditing(true)
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 6
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            let header = sampleRecipeCollection.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "topHeader", for: indexPath) as! CRVHomeTopHeader
            header.popupOpen = self.popUpOpen
            header.popupClose = self.popUpClose
            header.scrollToHeader = { () -> Void in
                self.sampleRecipeCollection.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            }
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
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        
        if scrollView != recipeTableView {
            self.popUpClose()
            homeView.endEditing(true)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeSearchList.result.count  //add row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeSearchListCell") as? RecipeSearchTableViewCell else { return RecipeSearchTableViewCell.init() }
        
        cell.resultLabel?.text = recipeSearchList.result[indexPath.row].name
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        return cell
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.network.getRecipeWith(recipeId: self.recipeSearchList.result[indexPath.row].id)
    }
}
