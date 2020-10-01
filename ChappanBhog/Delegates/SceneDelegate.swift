//
//  SceneDelegate.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import TwitterKit

 @available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


   
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
     
        
        if UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN") == true {
                
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToDashBoard), userInfo: nil, repeats: false)
                
            }
            else {
                _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(goToLoginScreen), userInfo: nil, repeats: false)
            }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
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
    
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let openURLContext = URLContexts.first {
            let url = openURLContext.url
            let options: [AnyHashable : Any] = [
                UIApplication.OpenURLOptionsKey.annotation : openURLContext.options.annotation as Any,
                UIApplication.OpenURLOptionsKey.sourceApplication : openURLContext.options.sourceApplication as Any,
                UIApplication.OpenURLOptionsKey.openInPlace : openURLContext.options.openInPlace
            ]
            print(options)
            TWTRTwitter.sharedInstance().application(UIApplication.shared, open: url, options: options)
        }
    }
             
}

