//
//  UpdatePasswordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class UpdatePasswordVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var updatePasswordBTN: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var oldPasswordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setAppearence()
        oldPasswordTF.isSecureTextEntry = true
        newPasswordTF.isSecureTextEntry = true
        confirmPasswordTF.isSecureTextEntry = true
    }
    
    
    //MARK:- FUCNTIONS
    func setAppearence() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.oldPasswordTF.setLeftPaddingPoints(10)
            self.newPasswordTF.setLeftPaddingPoints(10)
            self.confirmPasswordTF.setLeftPaddingPoints(10)
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePasswordButtonAction(_ sender: UIButton) {
        
        let kOldPassword = self.oldPasswordTF.text ?? ""
        let kNewPassword = self.newPasswordTF.text ?? ""
        let kConfirmPassword = self.confirmPasswordTF.text ?? ""
        
        if kOldPassword.count < 1 {
            alert("ChhappanBhog", message: "Please enter your old password.", view: self)
            return
        }
        
        if kNewPassword.count < 1 {
            alert("ChhappanBhog", message: "Please enter your new password.", view: self)
            return
        }
        
        if kConfirmPassword.count < 1 {
            alert("ChhappanBhog", message: "Please confirm your password.", view: self)
            return
        }
                
        /*if kConfirmPassword != kNewPassword {
            alert("ChhappanBhog", message: "Password & confirm password don't match.", view: self)
            return
        }*/
        
        if kOldPassword == kNewPassword {
            alert("ChhappanBhog", message: "Old password & new password can't be same.", view: self)
            return
        }
        
        let addAddressUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_CHANGE_PASSWORD
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        
        var params : [String: Any] = [:]
        params["user_id"] =  userID
        params["old_password"] = kOldPassword
        params["new_password"] = kNewPassword
        
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestPOSTURLWithHeader(addAddressUrl, params: params , success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            //  let message = result["message"] as? String ?? ""
            let status = dict["success"] as? Bool ?? false
            if status {
                let msg = dict["message"] as? String ?? "Some error Occured"
                alert("ChhappanBhog", message: msg, view: self)
                // self.navigationController?.popViewController(animated: true)
                AppDelegate.shared.goToLoginScreen()
                
            } else {
                let msg = dict["message"] as? String ?? "Some error Occured"
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            alert("ChhappanBhog", message: error.description, view: self)
        }
    }
}
