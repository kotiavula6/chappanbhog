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
    @IBOutlet weak var phoneTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setAppearence()
    }
    
    
    //MARK:- FUCNTIONS
    func setAppearence() {
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.phoneTF.setLeftPaddingPoints(10)
            self.oldPasswordTF.setLeftPaddingPoints(10)
            self.newPasswordTF.setLeftPaddingPoints(10)
            
            
        }
        
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePasswordButtonAction(_ sender: UIButton) {
        
            
            let kOldPassword = self.oldPasswordTF.text ?? ""
            let kNewPassword = self.newPasswordTF.text ?? ""
            let kPhoneNumber = self.phoneTF.text ?? ""
            
            if kOldPassword.count < 1 {
                alert("ChappanBhog", message: "Please enter your old password.", view: self)
                return
            }
            if kNewPassword.count < 1 {
                alert("ChappanBhog", message: "Please enter your new password.", view: self)
                return
            }
            if kOldPassword == kNewPassword {
                alert("ChappanBhog", message: "Old password & new password can't be same.", view: self)
                return
            }
            
            if kPhoneNumber.count < 1 {
                alert("ChappanBhog", message: "Phone can't be empty.", view: self)
                return
            }
           
            
            let addAddressUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_CHANGE_PASSWORD
            let userID = UserDefaults.standard.value(forKey: Constants.UserId)
            
            var params : [String: Any] = [:]
            params["user_id"] =  userID as Any
            params["old_password"] = kOldPassword as Any
            params["new_password"] = kNewPassword as Any
            
            
            IJProgressView.shared.showProgressView()
            AFWrapperClass.requestPOSTURLWithHeader(addAddressUrl, params: params , success: { (dict) in
                IJProgressView.shared.hideProgressView()
                print(dict)
                print(params)
                if let result = dict as? [String:Any]{
                    print(result)
                    
                  //  let message = result["message"] as? String ?? ""
                    let status = result["success"] as? Bool ?? false
                    
                    if status{
                        let msg = result["message"] as? String ?? "Some error Occured"
                        alert("ChappanBhog", message: msg, view: self)
                        self.navigationController?.popViewController(animated: true)
                    
                    } else {
                        let msg = result["message"] as? String ?? "Some error Occured"
                        alert("ChappanBhog", message: msg, view: self)
                        
                    }
                } else {
                    
                }
            }) { (error) in
                
                alert("ChappanBhog", message: error.description, view: self)
            }
            
            
            
            
            
        }
        
    
}
