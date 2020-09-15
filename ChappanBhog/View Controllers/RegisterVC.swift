//
//  RegisterVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
             mobileTF.setLeftPaddingPoints(10)
             emailTF.setLeftPaddingPoints(10)
             nameTF.setLeftPaddingPoints(10)
            ViewSetUp()
    }


    @IBAction func selectCountryTF(_ sender: UITextField) {
        
        let countryCodesViewController = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "COUNTRYCODES_STORY_IDENTIFIER") as? CountryCodesViewController
            countryCodesViewController?.selectedTF = countryCodeTF
            countryCodesViewController?.selectedImageView = flagIMG
            countryCodesViewController?.modalPresentationStyle = .fullScreen
            
            let navigationController = UINavigationController(rootViewController: countryCodesViewController!)
            navigationController.modalPresentationStyle = .fullScreen
            
            self.navigationController?.present(navigationController, animated: true, completion: nil)
        
    }
    
    func ViewSetUp() {
        
//        selectedCountryDictionary = getDefaultCountryDetailsOfDevice()
        countryCodeTF.text =  (selectedCountryDictionary["dialCode"] as? String ?? "")
            
            flagIMG.image = (selectedCountryDictionary["emoji"] as? String ?? "").emojiToImage()
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
