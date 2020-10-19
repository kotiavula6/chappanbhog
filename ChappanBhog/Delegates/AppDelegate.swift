//
//  AppDelegate.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
//import TwitterKit
import Firebase
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    static let shared: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tabbarController: UITabBarController?
    var sideMenuViewController: SlideMenuController!
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //TWTRTwitter.sharedInstance().start(withConsumerKey:"4Z8hpvQBOxBbtfXtjmtLWtt9Y", consumerSecret:"RfLtpt7X2RS34CAJICJqsTfV3U7kfgfk3XaHWA5oPa2k2GXE6U")

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        
        GIDSignIn.sharedInstance().clientID = "574908180295-s62bs9umoqrvuo366ri3es6ucrq0oqp8.apps.googleusercontent.com"
        FirebaseApp.configure()

        
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
//        let nav = UINavigationController(rootViewController: rootVc)
//        nav.isNavigationBarHidden = true
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        let loggedIn = UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN")
        let type = UserDefaults.standard.integer(forKey: "type")
        let verified = UserDefaults.standard.integer(forKey: Constants.verified)
        
        if loggedIn {
            if type == 0 && verified == 0 {
                // Type = Email and Phone number is not verified
                _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
            }
            else {
                
                _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(showHomeScreen), userInfo: nil, repeats: false)
            }
        }
        else {
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
        }
        
        return true
    }
    


    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ChappanBhog")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    @objc func showHomeScreen() {
        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let customTabbarViewController = Storyboard.instantiateViewController(withIdentifier: "Home") as? UITabBarController,
            let leftVC = Storyboard.instantiateViewController(withIdentifier: "SidemenuController") as? SidemenuController else {
            return
        }
        
        self.tabbarController = customTabbarViewController
        let navigationViewController: UINavigationController = UINavigationController(rootViewController: customTabbarViewController)
        navigationViewController.navigationBar.isHidden = true
        self.sideMenuViewController = SlideMenuController(mainViewController: navigationViewController, leftMenuViewController: leftVC)
        window?.rootViewController = sideMenuViewController
    }
    
    @objc func goToDashBoard() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    @objc func goToLoginScreen() {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        let nav = UINavigationController(rootViewController: rootVc)
        nav.isNavigationBarHidden = true
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    @objc func logout() {
        AppDelegate.shared.goToLoginScreen()
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        GIDSignIn.sharedInstance().signOut()
        clearDefaults()
       // let store = TWTRTwitter.sharedInstance().sessionStore
        //if let userID = store.session()?.userID {
          //store.logOutUserID(userID)
        //}
    }
    
    @objc func clearDefaults() {
        UserDefaults.standard.removeObject(forKey: "ISUSERLOGGEDIN")
        UserDefaults.standard.removeObject(forKey: Constants.Name)
        UserDefaults.standard.removeObject(forKey: Constants.EmailID)
        UserDefaults.standard.removeObject(forKey: Constants.Phone)
        UserDefaults.standard.removeObject(forKey: Constants.DialingCode)
        UserDefaults.standard.removeObject(forKey: Constants.UserId)
        UserDefaults.standard.removeObject(forKey: Constants.IsLogin)
        UserDefaults.standard.removeObject(forKey: Constants.access_token)
        UserDefaults.standard.removeObject(forKey: Constants.verified)
        UserDefaults.standard.removeObject(forKey: Constants.type)
        UserDefaults.standard.removeObject(forKey: Constants.Image)
    }
    
    @objc func notifyCartUpdate() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
    }
    
    /*func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }*/

//    @available(iOS 13.0, *)
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        if let openURLContext = URLContexts.first {
//            let url = openURLContext.url
//            let options: [AnyHashable : Any] = [
//                UIApplication.OpenURLOptionsKey.annotation : openURLContext.options.annotation as Any,
//                UIApplication.OpenURLOptionsKey.sourceApplication : openURLContext.options.sourceApplication as Any,
//                UIApplication.OpenURLOptionsKey.openInPlace : openURLContext.options.openInPlace
//            ]
//            print(options)
//            TWTRTwitter.sharedInstance().application(UIApplication.shared, open: url, options: options)
//        }
//    }
    
  
}

extension AppDelegate {
    func sd_indicator() -> SDWebImageActivityIndicator {
        return SDWebImageActivityIndicator.gray
    }
}
