//
//  ForgotPasswordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 15/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var gradientView: UIView!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendLinkAction(_ sender: UIButton) {
        let email = emailTF.text ?? ""
        if email.isEmpty {
            ValidateData(strMessage: " Please enter email address")
            return
        }
        
        if !isValidEmail(email: email) {
            ValidateData(strMessage: "Enter valid email")
            return
        }
        
        API_FORGOT_PASWORD()
    }
}

extension ForgotPasswordVC {
    
    func API_FORGOT_PASWORD() {
        
        let addAddressUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_FORGOT_PASSWORD
        let params = ["email" : emailTF.text ?? ""]
        
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
               // alert("ChhappanBhog", message: msg, view: self)
    
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "ChhappanBhog", message: msg, preferredStyle: .alert)
                    
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
                
            } else {
                let msg = dict["message"] as? String ?? "Some error Occured"
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            alert("ChhappanBhog", message: error.description, view: self)
        }
    }
}
