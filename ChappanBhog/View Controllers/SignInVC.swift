//
//  SignInVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SignInVC: UIViewController  {
    
    
    var message:String = ""
    
    //MARK:- OUTLETS
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set ASHelper class delegate
        if #available(iOS 13.0, *) {
            ASHelper.shared.delegate = self
        } else {
            // Fallback on earlier versions
        }
        setAppearance()
        
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        passwordTF.setLeftPaddingPoints(10)
        userNameTF.setLeftPaddingPoints(10)
        DispatchQueue.main.async  {
            
        }
    }
    
    
    
//    //MARK:- Google Delegate Methods
//
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        if let error = error {
//            print(error.localizedDescription)
//        }
//        if error == nil {
//            guard let email = user.profile.email,
//                let googleID = user.userID,
//                let name = user.profile.name
//                else { return }
//            guard let token = user.authentication.idToken else {
//                return
//            }
//            print("\(email), \(googleID), \(name), \(token)")
//            let param: [String: Any] = [
//                "email": email,
//                "type": "social"
//            ]
//            print(param)
////            self.defaults.set(true, forKey: "isSocial")
////            self.defaults.set(email, forKey: "email")
////            self.defaults.set("1122", forKey: "password")
////            self.defaults.synchronize()
////            self.adForest_loginUser(parameters: param as NSDictionary)
//        }
//    }
//    // Google Sign In Delegate
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
//        self.present(viewController, animated: true, completion: nil)
//    }
//
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
//        dismiss(animated: true, completion: nil)
//    }
//
    
    
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
            
            let parms : [String:Any] = ["user_email":userNameTF.text ?? "","user_pass":passwordTF.text ?? "","type":0,"social_id":"","name":""]
            
            API_LOGIN(params: parms as NSDictionary)
            view.endEditing(true)
        }
        
    }
    
    
    @IBAction func forgotPasswordAction(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fbAction(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)! {
                print("Cancel")
            }
            else if error == nil {
                self.userProfileDetails()
                
            } else {
            }
        }
    }
    @IBAction func twitterAccount(_ sender: UIButton) {
        
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {

        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
        
        
    }
    
    @IBAction func appleLoginClicked(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            
            ASHelper.shared.performRequest()
            //signIn completion response will come in ASHelper Delegate functions
        }
    }
    
    
    
    func userProfileDetails() {
        
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    print(result ?? "")
                    guard let results = result as? NSDictionary else { return }
                    // guard let facebookId = results["email"] as? String,
                    
                    
                    var email = results["email"] as? String ?? ""
                    let id = results["id"] as? String ?? ""
                    let defaultEmail = id + "@facebook.com"
                    let name = results["name"] as? String ?? ""
                    
                    email = email == "" ? defaultEmail:email
                    
                    print("\(email),")
//                    Kdefaults.set(true, forKey: "isSocial")
//                    Kdefaults.set(email, forKey: "email")
//                    Kdefaults.set("1122", forKey: "password")
//                    Kdefaults.synchronize()
                    
                    let parms : [String:Any] = ["user_email":email,"user_pass":"","type":1,"social_id":"Facebook","name":name]
                    
                    self.API_LOGIN(params: parms as NSDictionary)
                    
                }else {
                    print(error?.localizedDescription ?? "Nothing")
                }
            })
        }
        
    }
    
    
    //MARK:- LOGIN API
    
    func API_LOGIN(params: NSDictionary) {
        
        IJProgressView.shared.showProgressView()
        let loginUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_LOGIN
        print(params)
        AFWrapperClass.requestPOSTURL(loginUrl, params: params as! [String:Any] , success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)
            print(params)
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
                    
//                    UserDefaults.standard.set(name, forKey: Constants.Name)
//                    UserDefaults.standard.set(email, forKey: Constants.EmailID)
//                    UserDefaults.standard.set(phone, forKey: Constants.Phone)
//                    UserDefaults.standard.set(user_id, forKey: Constants.UserId)
//                    UserDefaults.standard.set(true, forKey: Constants.IsLogin)
//                    UserDefaults.standard.set(data, forKey: Constants.UserDetails)
                    
                    let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
        }) { (error) in
        }
        
    }
}

extension SignInVC:LoginDelegate {
    func authorizationDidCompleteWith(data: [String : Any?]) {
        
        let email = data["email"] as? String ?? ""
        let kemail = email.replacingOccurrences(of: "N/A", with: "")
        
        let userID = data["userID"]  as? String ?? ""
        let kuserID = userID.replacingOccurrences(of: "N/A", with: "")
        
        let name = data["name"]  as? String ?? ""
        let kname = name.replacingOccurrences(of: "N/A", with: "")
        
        let parms : [String:Any] = ["user_email":
            kemail ,"password":"","type":4,"social_id":kuserID ,"name":kname ]
        API_LOGIN(params: parms as NSDictionary)
        print(data)
        print(parms)
        
        //  ["userID": Optional("000486.a05e27cfd4f14c4188201c423861cfd6.1307"), "email": Optional("N/A"), "tokenID": Optional(773 bytes), "status": Optional(1), "name": Optional("N/A")]
    }
    
    func didCompleteWithError(error: Error?) {
        print("Errrrr")
    }
    
    
}

extension SignInVC:GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        else{
            let email = user.profile.email ?? ""
            let devpassword = "9DfgR0WVWKwgXa-JQIHSpNq3"
            
            let userId = user.userID ?? ""
            let idToken = user.authentication.idToken
            
            let fullName = user.profile.name ?? ""
            let givenName = user.profile.givenName ?? ""
            let familyName = user.profile.familyName ?? ""
            UserDefaults.standard.set(devpassword, forKey: "oldPassword")
            
            //  let user: GIDGoogleUser =
            if user.profile.hasImage{
                let profilePicURL = user.profile.imageURL(withDimension: 200).absoluteString
                UserDefaults.standard.set(profilePicURL, forKey: "GIMAGE")
                print(profilePicURL)
                
            }
  
            let parms : [String:Any] = ["user_email":email,"user_pass":"","type":2,"social_id":"Google Plus","name":fullName]
            
            API_LOGIN(params: parms as NSDictionary)
     
            print("welcome:,\(userId),\(idToken),\(fullName),\(email),\(devpassword)")
            
        }
    }
    

    func signInwillDispatch(signIn:GIDSignIn!,error:NSError){
        print("Will Dispatch")
    }
    func signIn(signIn:GIDSignIn!,presentViewController viewController:UIViewController){
        self.present(viewController, animated: true, completion: nil)
        print("Sign in presented")
    }
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if let a = error{
            print("error in google login\(a.localizedDescription)")
        }
    }
}
