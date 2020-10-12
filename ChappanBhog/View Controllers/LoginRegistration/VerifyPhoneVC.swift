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

class VerifyPhoneVC: UIViewController {
    
    var message:String = ""
    //MARK:- OUTLETS
    @IBOutlet weak var TF6: UITextField!
    @IBOutlet weak var TF5: UITextField!
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF1: UITextField!
    
    var phone: String = ""
    var code: String = ""
    var verificationID: String = ""
    var userID = ""
    
    
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
        
        IJProgressView.shared.showProgressView()
        sendVerificationCode {
            IJProgressView.shared.hideProgressView()
        }
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
            DispatchQueue.main.async {
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
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
            
            self.showAlertWithTitle(title: "", message: "A verification code has been sent to your registered number.", okButton: "Ok", cancelButton: "", okSelectorName: nil)
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
                
        _ = AF.request(loginUrl, method: .post, parameters: ["user_id": userId, "verified": "1"], encoding: JSONEncoding.default, headers: [header], interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                // 1 - user verified
                UserDefaults.standard.set(1, forKey: Constants.verified)
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
            alert("ChappanBhog", message: self.message, view: self)
            
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
}
