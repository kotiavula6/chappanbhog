//
//  SignInVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTF.setLeftPaddingPoints(10)
        userNameTF.setLeftPaddingPoints(10)
        setUI()
        
    }
    func setUI() {
        DispatchQueue.main.async  {
            setShadow(view: self.signInBTN, cornerRadius: 5, shadowRadius: 2, shadowOpacity: 2)
        }
    }

    @IBAction func creatAccountAction(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
           self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
 
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    

