//
//  sideMenu.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class sideMenu: UIViewController {
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var closeMenu:(()->())?
    var ShopAction:(()->())?
    var myAccountAction:(()->())?
    var settingsAction:(()->())?
    var cartAction:(()->())?
    var aboutAction:(()->())?
    var logoutAction:(()->())?
    
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var profileIMG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 1, animations: {
            self.leadingConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
   
    
        let name = UserDefaults.standard.value(forKey: Constants.Name) as? String ?? ""
            print(name)
        nameLBL.text = name
        
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
