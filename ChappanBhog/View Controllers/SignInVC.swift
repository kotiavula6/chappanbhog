//
//  SignInVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setAppearance()
        
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        passwordTF.setLeftPaddingPoints(10)
        userNameTF.setLeftPaddingPoints(10)
        DispatchQueue.main.async  {
            
        }
    }
    
    

    
    
    //MARK:- ACTIONS
    
    @IBAction func creatAccountAction(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
//        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
//        self.navigationController?.pushViewController(vc, animated: true)
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
          self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fbAction(_ sender: UIButton) {
        
        
    }
    @IBAction func twitterAccount(_ sender: UIButton) {
        
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        
        
    }
    
    
}


