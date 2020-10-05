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
import TwitterKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

 var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        TWTRTwitter.sharedInstance().start(withConsumerKey:"4Z8hpvQBOxBbtfXtjmtLWtt9Y", consumerSecret:"RfLtpt7X2RS34CAJICJqsTfV3U7kfgfk3XaHWA5oPa2k2GXE6U")

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        GIDSignIn.sharedInstance().clientID = "574908180295-nuhnssptokucg4cr05sr0qihol6fg7v1.apps.googleusercontent.com"
        
//        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
//        let rootVc = storyBoard.instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
//        let nav = UINavigationController(rootViewController: rootVc)
//        nav.isNavigationBarHidden = true
//        self.window?.rootViewController = nav
//        self.window?.makeKeyAndVisible()
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
            
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToDashBoard), userInfo: nil, repeats: false)
            
        }
        else {
            _ = Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
 @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
  
}

