//
//  RegisterVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    
    var countryContaine:countryContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
             mobileTF.setLeftPaddingPoints(10)
             emailTF.setLeftPaddingPoints(10)
             nameTF.setLeftPaddingPoints(10)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "" {
            
            countryContaine = segue.destination as? countryContainer
            countryContaine?.closeAction = {
                self.view.sendSubviewToBack(self.countryContainer)
            }
        }
    }
    
    @IBAction func countryCodeClicked(_ sender: UIButton) {
        self.view.bringSubviewToFront(countryContainer)
        
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                   self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.navigationController?.pushViewController(vc, animated: true)
    }
}
