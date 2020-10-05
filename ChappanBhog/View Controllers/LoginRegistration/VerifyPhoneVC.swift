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
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF1: UITextField!
    
    var phone: String = ""
    var code: String = ""
    var verificationID: String = ""
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        IJProgressView.shared.showProgressView()
        sendVerificationCode {
            IJProgressView.shared.hideProgressView()
        }
    }
    //http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com/api/verify_account
    
    // MARK:- ACTIONS
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
        PhoneAuthProvider.provider().verifyPhoneNumber(self.phone, uiDelegate: nil) { (verificationID, error) in
            if error != nil {
                self.showAlertWithTitle(title: "", message: "", okButton: "Ok", cancelButton: "", okSelectorName: nil)
                completion()
                return
            }
            self.verificationID = verificationID ?? ""
            completion()
        }
    }
    
    func verifyPhoneNumber(code: String, _ completion: @escaping (_ success: Bool) -> Void) {
        if self.verificationID == "" {
            completion(false)
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential( withVerificationID: verificationID, verificationCode: code)
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
        if c1.isEmpty || c2.isEmpty || c3.isEmpty || c4.isEmpty {
            return (false, "")
        }
        let code = c1 + c2 + c3 + c4
        return (true, code)
    }
    
    func updateVerifiedStatusOnServer(verified: Bool) {
        let loginUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_UPDATE_PHONE_VERIFIED
        let token = UserDefaults.standard.string(forKey: Constants.access_token) ?? ""
        let userId = UserDefaults.standard.string(forKey: Constants.UserId) ?? ""
        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
                
        _ = AF.request(loginUrl, method: .post, parameters: ["user_id": userId], encoding: JSONEncoding.default, headers: [header], interceptor: nil).responseJSON { (response) in
            switch response.result {
            case .success(let value):
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
