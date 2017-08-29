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
    var seasonRecipes = [Recipe]()
    var fridge = Refrigerator()
    var recipe = Recipe.init()
    var recipeSearchList = SearchList.init()
    var keyword = ""
    let keywordHighlight = KeywordHighlight()

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

        sampleRecipeCollection.register(CRVHomeTopHeader.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "topHeader")
        sampleRecipeCollection.register(CRVHomeMidHeader.self,
                                        forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                        withReuseIdentifier: "midHeader")
        recipeTableView.tableFooterView = UIView()
        recipeTableView.separatorInset.right = recipeTableView.separatorInset.left

        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: network.sampleRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: network.flingRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: network.failNetwork, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: network.searchRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: network.seasonMenu, object: nil)

        network.getFlingRecipe()
        network.getSeason()
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
        if notification.name == network.sampleRecipe {
            guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
                return
            }
            self.recipes = recipes
            sampleRecipeCollection.reloadData()
        } else if notification.name == network.flingRecipe {
            guard let recipe = notification.userInfo?["data"] as? Recipe else {
                return
            }
            let filter = ProductFilter()
            filter.filterProduct(recipe: recipe, fridge: fridge)
            self.recipe = recipe
            self.performSegue(withIdentifier: "HomeToRecipe", sender: self.recipe)
        } else if notification.name == network.failNetwork {
            // 예외 처리!
        } else if notification.name == network.searchRecipe {
            guard let recipeList = notification.userInfo?["data"] as? SearchList else { return }
            self.recipeSearchList = recipeList
            recipeTableView.isHidden = false
            recipeTableView.reloadData()
        } else if notification.name == network.seasonMenu {
            guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
                return
            }
            self.seasonRecipes = recipes
            sampleRecipeCollection.reloadData()
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

    func popUpOpen() {
        let width = self.view.frame.width - 30
        let frame = CGRect(x: 15, y: 190, width: width, height: 200)
        searchPopUp.frame = frame
        self.view.addSubview(self.searchPopUp)
        recipeTableView.allowsSelection = true
    }

    func popUpClose() {
        self.searchPopUp.removeFromSuperview()
        recipeTableView.isHidden = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
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
            if recipes.count != 0 {
                return recipes.count - 2
            } else {
                return recipes.count
            }
        } else {
            if seasonRecipes.count != 0 {
                return self.seasonRecipes.count - 1
            } else {
                return self.seasonRecipes.count
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        if indexPath.section == 0 {
            guard let header = sampleRecipeCollection.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "topHeader", for: indexPath
                ) as? CRVHomeTopHeader else {
                return CRVHomeTopHeader()
            }
            header.popupOpen = self.popUpOpen
            header.popupClose = self.popUpClose
            header.editingKeyword = { keyword -> Void in
                self.keyword = keyword
            }
            header.scrollToHeader = { () -> Void in
                self.sampleRecipeCollection.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            }
            return header
        } else {
            guard let header = sampleRecipeCollection.dequeueReusableSupplementaryView(
                ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "midHeader", for: indexPath
                ) as? CRVHomeMidHeader else {
                    return CRVHomeMidHeader()
            }
            return header
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
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

        var recipeCell = Recipe()
        if indexPath.section == 0 {
            recipeCell = self.recipes[indexPath.row]
        } else {
            recipeCell = self.seasonRecipes[indexPath.row]
        }

        if recipes.count > 0 {
            if recipeCell.image != "" {
                cell.sampleRecipeImage?.af_setImage(withURL: URL(string: recipeCell.image)!)
            }
            cell.sampleRecipeLabel.text = recipeCell.title
            cell.sampleRecipeSubtitleLabel.text = recipeCell.subtitle
            cell.clickHandler = { () -> Void in
                self.network.getRecipeWith(recipeId: recipeCell.rid)
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

        let result = recipeSearchList.result[indexPath.row].name
        cell.resultLabel.attributedText = keywordHighlight.addBold(keyword: keyword, text: result)
        cell.resultLabel.font = UIFont.systemFont(ofSize: 12)
        cell.selectionStyle = UITableViewCellSelectionStyle.default
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.network.getRecipeWith(recipeId: self.recipeSearchList.result[indexPath.row].id)
    }
}
