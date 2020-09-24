//
//  SignInVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {
    
    var message:String = ""
    
    //MARK:- OUTLETS
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setAppearance()
        
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        passwordTF.setLeftPaddingPoints(10)
        userNameTF.setLeftPaddingPoints(10)
        DispatchQueue.main.async  {
            
        }
    }
 
    
    //MARK:- ACTIONS
    
    @IBAction func creatAccountAction(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signInButtonClicked(_ sender: UIButton) {

                if (userNameTF.text?.isEmpty)!{
                   
                   ValidateData(strMessage: " Please enter email address")
               }
               else if isValidEmail(email: (userNameTF.text)!) == false{
                   
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
                     API_LOGIN()
               }

    }
    
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fbAction(_ sender: UIButton) {
        
        
    }
    @IBAction func twitterAccount(_ sender: UIButton) {
        
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        
        
    }
    
    



//MARK:- LOGIN API

    func API_LOGIN() {
        
//        - email
//        - pwd
//        - social_id (optional)
//        - type
//        - name  (optional)

        IJProgressView.shared.showProgressView()
        let loginUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_LOGIN
        let parms : [String:Any] = ["user_email":userNameTF.text ?? "","user_pass":passwordTF.text ?? "","type":0,"social_id":"","name":""]
        
        AFWrapperClass.requestPOSTURL(loginUrl, params: parms, success: { (dict) in
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
