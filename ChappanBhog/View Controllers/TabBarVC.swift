//
//  TabBarVC.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 29/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
        tabbarAppearcance()
    }
    
    func tabbarAppearcance() {
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue]
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.black
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.appColor()
            tabBar.standardAppearance = appearance
        }
        else {
            tabBar.unselectedItemTintColor = UIColor.black
            tabBar.tintColor = UIColor.appColor()
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController is MyAccountVC {
            let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
            if loginNeeded { return false}
        }
        else if viewController is CategoryAndItemsVC {
            let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
            if loginNeeded { return false}
        }
        else if viewController is NotificationsVC {
            let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
            if loginNeeded { return false}
        }
        
        return true
    }
}
