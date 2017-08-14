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
    var searchRecipe = Recipe.init()

    private let sampleRecipe = Notification.Name.init(rawValue: "sampleRecipe")
    private let flingRecipe = Notification.Name.init(rawValue: "flingRecipe")
    private let failFlingRecipe = Notification.Name.init(rawValue: "FailFlingRecipe")

    @IBOutlet var homeView: UIView!
    @IBOutlet weak var sampleRecipeCollection: UICollectionView!
    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var urlWarningLabel: UILabel!
    @IBAction func searchButton(_ sender: Any) {
        if checkRecipeUrl(url: self.urlField.text ?? "") {
            network.getRecipeWith(url: self.urlField.text ?? "")
            // 팝업 켜기
//            let spinnerIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
//            spinnerIndicator.center = CGPoint(x: 135.0, y: 65.5)
//            spinnerIndicator.color = UIColor.black
//            spinnerIndicator.startAnimating()
//            alertController.view.addSubview(spinnerIndicator)
//            self.present(alertController, animated: false, completion: nil)
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
                                               name: self.sampleRecipe, object: nil)
        //swiftlint:disable line_length
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification),
                                               name: Notification.Name.init(rawValue: "UIKeyboardWillShowNotification"),
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: flingRecipe, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification), name: failFlingRecipe, object: nil)

        network.getFlingRecipe()
        urlWarningLabel.layer.cornerRadius = 5
    }

    override func viewWillDisappear(_ animated: Bool) {
        homeView.endEditing(true)
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
