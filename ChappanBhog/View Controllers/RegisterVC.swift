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
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var registerBTN: UIButton!
    var message:String = ""
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setAppearance()
    }
    
    
    //MARK:- REGISTER USER
    
    func RegisterUser() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = ApplicationUrl.WEB_SERVER + WebserviceNamme.API_GET_REGISTER
        
//        let deviceID = UserDefaults.standard.value(forKey: "deviceToken") as? String ?? ""
//        let userlatitude = UserDefaults.standard.value(forKey: "Latitude")
//        let userlongitude = UserDefaults.standard.value(forKey: "Longitude")
//        let userCity = UserDefaults.standard.value(forKey: "City")
                
//        let mobile = mobileTF.text ?? ""
//        let email = emailTF.text ?? ""
//        let name = nameTF.text ?? ""
//        let countryCode = countryCodeTF.text ?? ""
//        let password = passwordTF.text ?? ""
        
        
        let parms : [String:Any] = ["email": emailTF.text ?? "","mobile":mobileTF.text ?? "","name":nameTF.text ?? "","password":passwordTF.text ?? ""]
        
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            print(dict)
            
            
            let userID = dict.value(forKey: "id") as? Int ?? 0
            print(userID)
            
            UserDefaults.standard.set(userID, forKey: "Uid")
            
            if let result = dict as? [String:Any]{
                print(result)
                let detail = result["user_detail"] as?  [[String:Any]]
                print(detail)
                
                let data = detail?[0]
                print(data)
                
                let googileID = data?["google_id"] as? String ?? ""
                UserDefaults.standard.set(googileID, forKey: "googleId")
  
                self.message = result["message"] as? String ?? ""
                let status = result["status"] as? Int ?? 0
                if status == 0{
                    
                    alert("SafeShopper", message: self.message, view: self)
                }else{
                    UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                          
                      //        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                      //        self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }) { (error) in
        }
        
    }
    
    
    //MARK:- FUNCTIONS
    
    func setAppearance() {
        
        DispatchQueue.main.async {
            self.registerBTN.layer.masksToBounds = true
            setShadow(view: self.registerBTN, cornerRadius: 5, shadowRadius: 5, shadowOpacity: 5)
            
            self.flagIMG.layer.cornerRadius = self.flagIMG.frame.height/2
            self.flagIMG.layer.masksToBounds = true
        }
        
        mobileTF.setLeftPaddingPoints(10)
        emailTF.setLeftPaddingPoints(10)
        nameTF.setLeftPaddingPoints(10)
        passwordTF.setLeftPaddingPoints(10)
        
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
        //
        //        @IBOutlet weak var countryContainer: UIView!
        //           @IBOutlet weak var mobileTF: UITextField!
        //           @IBOutlet weak var emailTF: UITextField!
        //           @IBOutlet weak var nameTF: UITextField!
        //           @IBOutlet weak var countryCodeTF: UITextField!
        
//        let mobile = mobileTF.text ?? ""
//        let email = emailTF.text ?? ""
//        let name = nameTF.text ?? ""
//        let countryCode = countryCodeTF.text ?? ""
//        let password = passwordTF.text ?? ""
        
        if (nameTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter username")
        }
        else if (emailTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email address")
        }
        else if (mobileTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter mobile")
        }
        else if isValidEmail(email: (emailTF.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
        }
        else if (passwordTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
        }else if (passwordTF.text?.count)! < 4 || (passwordTF.text?.count)! > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.set(passwordTF.text, forKey: "password")
            UserDefaults.standard.string(forKey: "password")
        }
        else{
            RegisterUser()
        }
  
        
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
