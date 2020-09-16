//
//  sideMenu.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class sideMenu: UIViewController {
    
    var closeMenu:(()->())?
    var ShopAction:(()->())?
    var myAccountAction:(()->())?
    var settingsAction:(()->())?
    var cartAction:(()->())?
    var aboutAction:(()->())?
    var logoutAction:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func closeMenuButton(_ sender: UIButton) {
        if let actio = closeMenu {
            actio()
        }
    }
    
    @IBAction func shopActionClicked(_ sender: UIButton) {
        if let actio = ShopAction {
            actio()
        }
    }
    
    @IBAction func myAccountClicked(_ sender: UIButton) {
        if let actio = myAccountAction {
            actio()
        }
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
        if let actio = settingsAction {
            actio()
        }
    }
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        print("cartButtonClicked")
        if let actio = cartAction {
            actio()
        }
    }
    
    @IBAction func aboutButtonClicked(_ sender: UIButton) {
        if let actio = aboutAction {
            actio()
        }
    }
    @IBAction func logoutButtonClicked(_ sender: UIButton) {
        if let actio = logoutAction {
                   actio()
               }
        
    }
    
    
}
