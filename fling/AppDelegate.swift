//
//  AppDelegate.swift
//  fling
//
//  Created by woowabrothers on 2017. 8. 4..
//  Copyright © 2017년 osgd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var cart = Cart()
    var fridge = Refrigerator()
    let myStoragy = Storage()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //UINavigationBar.appearance().tintColor = UIColor.init(red: 1, green: 148/255, blue: 41/255, alpha: 100)

        // for reset userDefault
//        let appDomain = Bundle.main.bundleIdentifier!
//        UserDefaults.standard.removePersistentDomain(forName: appDomain)

        self.cart = myStoragy.loadCart()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        myStoragy.saveCart(cart: cart)
    }

}
