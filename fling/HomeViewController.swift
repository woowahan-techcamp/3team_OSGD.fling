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
    @IBAction func searchButton(_ sender: Any) {
        self.performSegue(withIdentifier: "HomeToRecipe", sender: self.urlField.text!)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(HomeViewController.dismissKeyboard))
        homeView.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(recieveNotification),
                                               name: Notification.Name.init(rawValue: "flingRecipe"), object: nil)
        
        network.getFlingRecipe()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func dismissKeyboard() {
        homeView.endEditing(true)
    }
    
    func recieveNotification(notification: Notification) {
        guard let recipes = notification.userInfo?["data"] as? [Recipe] else {
            return
        }
        
        self.recipes = recipes
        sampleRecipeCollection.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "HomeToRecipe") {
            let secondViewController = segue.destination as! RecipeViewController
            let searchUrl = sender as! String
            secondViewController.searchUrl = searchUrl
        }
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
        let cell = sampleRecipeCollection.dequeueReusableCell(withReuseIdentifier: "mainRecipeCell",
                                                              for: indexPath) as! HomeRecipeCollectionViewCell
        if recipes.count > 0 {
            cell.sampleRecipeImage?.af_setImage(withURL: URL(string: recipes[indexPath.row].image)!)
            cell.sampleRecipeImage.frame.size = CGSize(width: 180, height: 180)
//            cell.sampleRecipeImage.bounds = CGRect(x: 0, y: 0, width: 100, height: 100)
            
            cell.sampleRecipeLabel.text = recipes[indexPath.row].title
        }

        return cell
    }
}
