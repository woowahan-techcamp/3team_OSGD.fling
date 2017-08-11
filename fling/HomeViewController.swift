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
    var recipes = [Recipe]()

    @IBOutlet var homeView: UIView!
    @IBOutlet weak var sampleRecipeCollection: UICollectionView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var urlWarningLabel: UILabel!
    @IBAction func searchButton(_ sender: Any) {
        if checkRecipeUrl(url: self.urlField.text ?? "") {
            self.performSegue(withIdentifier: "HomeToRecipe", sender: self.urlField.text!)
        } else {
            urlWarningLabel.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(HomeViewController.dismissKeyboard))
        homeView.addGestureRecognizer(tap)

        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification),
                                               name: Notification.Name.init(rawValue: "flingRecipe"), object: nil)
        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification),
                                               name: NSNotification.Name.init(rawValue: "UIKeyboardWillShowNotification"),
                                               object: nil)

        network.getFlingRecipe()
        network.getRecipeWith(url: "http://haemukja.com/recipes/340")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func keyboardWillShow() {
        urlWarningLabel.isHidden = true
    }

    func dismissKeyboard() {
        homeView.endEditing(true)
    }

    func recieveNotification(notification: Notification) {
        if notification.name == Notification.Name.init(rawValue: "flingRecipe") {
            guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
                return
            }
            self.recipes = recipes
            sampleRecipeCollection.reloadData()
        } else if notification.name == Notification.Name.init(rawValue: "UIKeyboardWillShowNotification") {
            keyboardWillShow()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "HomeToRecipe" {
            guard let secondViewController = segue.destination as? RecipeViewController else {
                return
            }
            guard let searchUrl = sender as? String else {
                return
            }
            secondViewController.searchUrl = searchUrl
        }
    }

    func checkRecipeUrl(url: String) -> Bool {
        if !url.contains("haemukja.com/recipes/") {
            return false
        }
        return true
    }

}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
            sampleRecipeCollection.dequeueReusableCell(withReuseIdentifier: "mainRecipeCell", for: indexPath)
                as? HomeRecipeCollectionViewCell else {
                    return HomeRecipeCollectionViewCell()
        }

        if recipes.count > 0 {
            if recipes[indexPath.row].image != "" {
                cell.sampleRecipeImage?.af_setImage(withURL: URL(string: recipes[indexPath.row].image)!)
            }
            cell.sampleRecipeImage.frame.size = CGSize(width: 180, height: 180)
//            cell.sampleRecipeImage.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)

            cell.sampleRecipeLabel.text = recipes[indexPath.row].title
        }

        return cell
    }
}
