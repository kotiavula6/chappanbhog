//
//  ProfileDetailsVC.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 30/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import SKCountryPicker

class ProfileDetailsVC: UIViewController {

    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var registerBTN: UIButton!

    var isEmailRegisteration: Bool = false
    var selectedCountry: Country?
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.keyboardType = .emailAddress
        mobileTF.keyboardType = .phonePad
        nameTF.autocapitalizationType = .words
        
        // Do any additional setup after loading the view.
        setAppearance()
    }
    
    // MARK:- ACTIONS
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectCountryButtonClicked(_ sender: UIButton) {
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            self.flagIMG.image = country.flag
            self.selectedCountry = country
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }

    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        let _phone = mobileTF.text ?? ""
        if (nameTF.text?.isEmpty)!{
            ValidateData(strMessage: "Please enter name")
        }
        else if (emailTF.text?.isEmpty)!{
            ValidateData(strMessage: "Please enter email address")
        }
        else if isValidEmail(email: (emailTF.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
        }
        else if _phone.isEmpty {
            ValidateData(strMessage: "Please enter your mobile number")
        }
        else if _phone.count < 7 || _phone.count > 14 {
            ValidateData(strMessage: "Please enter a valid mobile number")
        }
        else {
            isEmailRegisteration = true
            let phone = mobileTF.text ?? ""
            let code = (self.selectedCountry?.dialingCode ?? "+91")
            let parms : [String:Any] = ["user_email": emailTF.text ?? "", "phone": phone, "name": nameTF.text ?? "", "country_code": code]
            API_SAVE_USER(params: parms)
            view.endEditing(true)
        }
    }
    
    
    // MARK:- UI SETUP
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
        
        guard let country = CountryManager.shared.currentCountry else {
            self.flagIMG.isHidden = true
            return
        }
        self.selectedCountry = country
        flagIMG.image = country.flag
    }
}

extension ProfileDetailsVC {
    
    func API_SAVE_USER(params: [String: Any]) {
        
        IJProgressView.shared.showProgressView()
        let saveUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_SAVE_USER
        
        AFWrapperClass.requestPOSTURLWithHeader(saveUrl, params: params, success: { (dict) in
            
            IJProgressView.shared.hideProgressView()
            print(dict)
            
            let message = dict["message"] as? String ?? ""
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                alert("ChhappanBhog", message: message, view: self)
            } else {
                let data = dict["data"] as? [String:Any] ?? [:]
                let name = data["name"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let phone = data["phone"] as? String ?? ""
                
                UserDefaults.standard.set(name, forKey: Constants.Name)
                UserDefaults.standard.set(email, forKey: Constants.EmailID)
                UserDefaults.standard.set(phone, forKey: Constants.Phone)
                
                CartHelper.shared.manageAddress.email = email
                CartHelper.shared.manageAddress.phone = phone
                
                let code = (self.selectedCountry?.dialingCode ?? "+91")
                UserDefaults.standard.set(code, forKey: Constants.DialingCode)
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                vc.phone = phone
                vc.code = code
                vc.isFromSaveUser = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }) { (error) in
            alert("ChhappanBhog", message: error.localizedDescription, view: self)
        }
    }
}
