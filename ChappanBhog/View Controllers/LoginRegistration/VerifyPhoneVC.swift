//
//  VerifyPhoneVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import FirebaseAuth
import Alamofire
import SKCountryPicker

class VerifyPhoneVC: UIViewController {
    
    let tickImage = #imageLiteral(resourceName: "tick")
    let editImage = #imageLiteral(resourceName: "edit")
    
    var message:String = ""
    //MARK:- OUTLETS
    @IBOutlet weak var TF6: UITextField!
    @IBOutlet weak var TF5: UITextField!
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF1: UITextField!
    
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var iVDropdown: UIImageView!
    @IBOutlet weak var editButtonContainer: UIView!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var layoutConstraintButtonEditWith: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintButtonEditHeight: NSLayoutConstraint!
    
    var selectedCountry: Country?
    
    var phone: String = ""
    var code: String = ""
    var verificationID: String = ""
    var userID = ""
    var editMode: Bool = false
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        TF1.delegate = self
        TF2.delegate = self
        TF3.delegate = self
        TF4.delegate = self
        TF5.delegate = self
        TF6.delegate = self
        
        TF1.keyboardType = .numberPad
        TF2.keyboardType = .numberPad
        TF3.keyboardType = .numberPad
        TF4.keyboardType = .numberPad
        TF5.keyboardType = .numberPad
        TF6.keyboardType = .numberPad
        
                
        mobileTF.keyboardType = .phonePad
        
        if !code.isEmpty { selectedCountry = CountryManager.shared.country(withDigitCode: code) }
        if selectedCountry == nil {
            code = "+91"
            if let country = CountryManager.shared.currentCountry {
                selectedCountry = country
                code = country.dialingCode ?? "+91"
            }
        }
        flagIMG.layer.cornerRadius = self.flagIMG.frame.height/2
        flagIMG.layer.masksToBounds = true
        flagIMG.image = selectedCountry?.flag
        mobileTF.text = phone
        
        IJProgressView.shared.showProgressView()
        sendVerificationCode {
            IJProgressView.shared.hideProgressView()
        }
        
        mobileTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        updateEditMode()
    }
    //http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com/api/verify_account
    
    // MARK:- ACTIONS
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func ResendAction(_ sender: UIButton) {
        IJProgressView.shared.showProgressView()
        sendVerificationCode {
            IJProgressView.shared.hideProgressView()
        }
    }
    
    @IBAction func verifyClicked(_ sender: UIButton) {
        
        let result = validate()
        if !result.success {
            return
        }
        
        IJProgressView.shared.showProgressView()
        verifyPhoneNumber(code: code) { (success) in
            IJProgressView.shared.hideProgressView()
            if !success {
                // self.showAlertWithTitle(title: "", message: "Invalid verification code", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                return
            }
            
            // Update verify status on server
            self.updateVerifiedStatusOnServer(verified: true)
            
            // Move to home
            AppDelegate.shared.showHomeScreen()
//            DispatchQueue.main.async {
//                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
        }
    }
    
    @IBAction func selectCountryButtonClicked(_ sender: UIButton) {
        
        if !editMode { return }
        
        // Invoke below static method to present country picker without section control
        // CountryPickerController.presentController(on: self) { ... }
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            self.flagIMG.image = country.flag
            self.selectedCountry = country
            self.code = country.dialingCode ?? "0"
            
            IJProgressView.shared.showProgressView()
            self.sendVerificationCode {
                IJProgressView.shared.hideProgressView()
            }
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }
    
    @IBAction func editPhoneField(_ sender: UIButton) {
        if !editMode {
            editMode = true
            mobileTF.isUserInteractionEnabled = true
            mobileTF.becomeFirstResponder()
        }
        else {
            // Tick click
            // Send the verification code
            editMode = false
            IJProgressView.shared.showProgressView()
            sendVerificationCode {
                IJProgressView.shared.hideProgressView()
            }
        }
        updateEditMode()
    }
    
    // MARK:- Methods
    func updateEditMode() {
        if editMode {
            iVDropdown.isHidden = false
            btnEdit.setImage(tickImage, for: .normal)
            btnEdit.tintColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            mobileTF.isUserInteractionEnabled = true
            mobileTF.textColor = .black
            layoutConstraintButtonEditWith.constant = 24
            layoutConstraintButtonEditHeight.constant = 24
        }
        else {
            iVDropdown.isHidden = true
            btnEdit.setImage(editImage, for: .normal)
            btnEdit.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            mobileTF.isUserInteractionEnabled = false
            mobileTF.textColor = .lightGray
            layoutConstraintButtonEditWith.constant = 18
            layoutConstraintButtonEditHeight.constant = 18
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        phone = textField.text ?? ""
    }
}

extension VerifyPhoneVC {
    
    func sendVerificationCode(_ completion: @escaping () -> Void) {
        let updatedPhone = "\(self.code)\(self.phone)"
        PhoneAuthProvider.provider().verifyPhoneNumber(updatedPhone, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.showAlertWithTitle(title: "", message: error?.localizedDescription ?? "", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                completion()
                return
            }
            
            self.showAlertWithTitle(title: "", message: "We have resent the verification code on your registered mobile number.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
            self.verificationID = verificationID ?? ""
            completion()
        }
    }
    
    func verifyPhoneNumber(code: String, _ completion: @escaping (_ success: Bool) -> Void) {
        if self.verificationID == "" {
            completion(false)
            return
        }
        let tf1 = self.TF1.text ?? ""
        let tf2 = self.TF2.text ?? ""
        let tf3 = self.TF3.text ?? ""
        let tf4 = self.TF4.text ?? ""
        let tf5 = self.TF5.text ?? ""
        let tf6 = self.TF6.text ?? ""
        
        let combinedCode = "\(tf1)\(tf2)\(tf3)\(tf4)\(tf5)\(tf6)"
        
        let credential = PhoneAuthProvider.provider().credential( withVerificationID: verificationID, verificationCode: combinedCode)
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                self.showAlertWithTitle(title: "", message: error.localizedDescription, okButton: "Ok", cancelButton: "", okSelectorName: nil)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func validate() -> (success: Bool, code: String) {
        let c1 = TF1.text ?? ""
        let c2 = TF2.text ?? ""
        let c3 = TF3.text ?? ""
        let c4 = TF4.text ?? ""
        let c5 = TF5.text ?? ""
        let c6 = TF6.text ?? ""
        if c1.isEmpty || c2.isEmpty || c3.isEmpty || c4.isEmpty || c5.isEmpty || c5.isEmpty {
            return (false, "")
        }
        let code = c1 + c2 + c3 + c4 + c5 + c6
        return (true, code)
    }
    
    func updateVerifiedStatusOnServer(verified: Bool) {
        let loginUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_UPDATE_PHONE_VERIFIED
        let token = UserDefaults.standard.string(forKey: Constants.access_token) ?? ""
        let userId = UserDefaults.standard.string(forKey: Constants.UserId) ?? ""
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let params = ["user_id": userId, "verified": "1", "phone": phone, "country_code": code]
        _ = AF.request(loginUrl, method: .post, parameters: params, encoding: JSONEncoding.default, headers: [header], interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                // 1 - user verified
                UserDefaults.standard.set(1, forKey: Constants.verified)
                UserDefaults.standard.set(self.phone, forKey: Constants.Phone)
                UserDefaults.standard.set(self.code, forKey: Constants.DialingCode)
                UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                print(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension VerifyPhoneVC {
func API_GET_DASHBOARD_DATA() {
    
    IJProgressView.shared.showProgressView()
    let bannersUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_VERIFY_ACCOUNT
    let params:[String:Any] = ["":""]
    
    AFWrapperClass.requestPOSTURL(bannersUrl, params: params, success: { (dict) in
        IJProgressView.shared.hideProgressView()
        
        let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
        if isTokenExpired {
            return
        }
        
        print(dict)
        
        let response = dict["data"] as? NSDictionary ?? NSDictionary()
        let success = dict["success"] as? Int ?? 0
        
        if success == 0 {
            
            self.message = dict["message"] as? String ?? ""
            alert("ChhappanBhog", message: self.message, view: self)
            
        }else {
            
         
        }
 
        
    }) { (error) in
        
        IJProgressView.shared.hideProgressView()
        
    }
}
}
extension VerifyPhoneVC: UITextFieldDelegate {
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if ((textField.text?.count)! < 1 ) && (string.count > 0) {
            if textField == TF1 {
              //  tfOtp1.backgroundColor = APP_BLUE_COLOR
                TF2.becomeFirstResponder()
            }
            
            if textField == TF2 {
            //    tfOtp2.backgroundColor = APP_BLUE_COLOR
                TF3.becomeFirstResponder()
            }
            
            if textField == TF3 {
             //   tfOtp3.backgroundColor = APP_BLUE_COLOR
                TF4.becomeFirstResponder()
            }
            
            if textField == TF4 {
            //    tfOtp4.backgroundColor = APP_BLUE_COLOR
                TF5.becomeFirstResponder()
            }
            
            if textField == TF5 {
             //   tfOtp5.backgroundColor = APP_BLUE_COLOR
                TF6.becomeFirstResponder()
            }
            if textField == TF6 {
             //   tfOtp6.backgroundColor = APP_BLUE_COLOR
                TF6.resignFirstResponder()
            }
            
            textField.text = string
            return false
        } else if ((textField.text?.count)! >= 1) && (string.count == 0) {
            if textField == TF6 {
             //   tfOtp2.backgroundColor = LIGHT_GRAY_COLOR
                TF5.becomeFirstResponder()
            }
            if textField == TF5 {
              //  tfOtp3.backgroundColor = LIGHT_GRAY_COLOR
                TF4.becomeFirstResponder()
            }
            if textField == TF4 {
              //  tfOtp4.backgroundColor = LIGHT_GRAY_COLOR
                TF3.becomeFirstResponder()
            }
            if textField == TF3 {
             //   tfOtp5.backgroundColor = LIGHT_GRAY_COLOR
                TF2.becomeFirstResponder()
            }
            if textField == TF2 {
             //   tfOtp6.backgroundColor = LIGHT_GRAY_COLOR
                TF1.becomeFirstResponder()
            }
            if textField == TF1 {
             //   tfOtp1.backgroundColor = LIGHT_GRAY_COLOR
                TF1.resignFirstResponder()
            }
            
            textField.text = ""
            return false
        } else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*if textField == mobileTF {
            IJProgressView.shared.showProgressView()
            sendVerificationCode {
                IJProgressView.shared.hideProgressView()
            }
        }*/
    }
}
