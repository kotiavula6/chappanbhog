//
//  RegisterVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import SKCountryPicker

class RegisterVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var registerBTN: UIButton!
    
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        mobileTF.setLeftPaddingPoints(10)
        emailTF.setLeftPaddingPoints(10)
        nameTF.setLeftPaddingPoints(10)
        ViewSetUp()
    }
    
    //MARK:- FUNCTIONS
    func ViewSetUp() {
        
        DispatchQueue.main.async {
            self.registerBTN.layer.masksToBounds = true
            setShadow(view: self.registerBTN, cornerRadius: 5, shadowRadius: 5, shadowOpacity: 5)
            
            self.flagIMG.layer.cornerRadius = self.flagIMG.frame.height/2
               self.flagIMG.layer.masksToBounds = true
        }
        
        
        guard let country = CountryManager.shared.currentCountry else {
            //            self.countryBTN.setTitle("Pick Country", for: .normal)
            self.flagIMG.isHidden = true
            return
        }
        //        countryBTN.setTitle(country.dialingCode, for: .normal)
        flagIMG.image = country.flag
        //      countryBTN.clipsToBounds = true
        
    }
    
    
    
    //MARK:- ACTIONS
    
    @IBAction func selectCountryButtonClicked(_ sender: UIButton) {
        // Invoke below static method to present country picker without section control
        // CountryPickerController.presentController(on: self) { ... }
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.flagIMG.image = country.flag
            //             self.countryBTN.setTitle(country.dialingCode, for: .normal)
            
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }
    


@IBAction func registerButtonAction(_ sender: UIButton) {
    let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
    self.navigationController?.pushViewController(vc, animated: true)
    
}

@IBAction func loginButtonClicked(_ sender: UIButton) {
    let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
    self.navigationController?.pushViewController(vc, animated: true)
}

@IBAction func fbButtonAction(_ sender: UIButton) {
}
@IBAction func twitterAction(_ sender: UIButton) {
}

@IBAction func googleAction(_ sender: UIButton) {
}
}
