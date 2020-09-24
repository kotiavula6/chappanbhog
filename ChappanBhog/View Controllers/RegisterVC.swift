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
        
        if (nameTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter username")
        }
        else if (emailTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email address")
        }
        else if (mobileTF.text?.count)! > 10 || (mobileTF.text?.count)! < 10 {
            
            ValidateData(strMessage: " Please enter valid mobile")
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
            API_NEW_USER_REGISTER()
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
    
    
    //MARK:- UI SETUP
    
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
    
    
    //MARK:- REGISTER USER
    
    func API_NEW_USER_REGISTER() {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_REGISTER
        let parms : [String:Any] = ["user_email": emailTF.text ?? "","phone":mobileTF.text ?? "","name":nameTF.text ?? "","password":passwordTF.text ?? "","type":0]
        
        AFWrapperClass.requestPOSTURL(signUpUrl, params: parms, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)

            if let result = dict as? [String:Any]{
                print(result)
                
                //                let googileID = data?["google_id"] as? String ?? ""
                //                UserDefaults.standard.set(googileID, forKey: "googleId")
                
                self.message = result["message"] as? String ?? ""
                let success = result["success"] as? Int ?? 0
                
                if success == 0{
                    alert("ChappanBhog", message: self.message, view: self)
                }else{
                    let data = result["data"] as? [String:Any] ?? [:]
//                    email = "asdf@gmail.com";
//                    name = "Agra\U2019s ";
//                    phone = 1231231231;
//                    type = 0;
//                    "user_id" = 45148;
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let phone = data["phone"] as? String ?? ""
                    let user_id = data["user_id"] as? String ?? ""
                    
                    UserDefaults.standard.set(name, forKey: Constants.Name)
                    UserDefaults.standard.set(email, forKey: Constants.EmailID)
                    UserDefaults.standard.set(phone, forKey: Constants.Phone)
                    UserDefaults.standard.set(user_id, forKey: Constants.UserId)
                    UserDefaults.standard.set(true, forKey: Constants.IsLogin)
                    UserDefaults.standard.set(data, forKey: Constants.UserDetails)
    
                    let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }) { (error) in
        }
        
    }
}
