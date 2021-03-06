//
//  SignInVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
//import TwitterKit

class SignInVC: UIViewController  {
    
    
    var message:String = ""
    
    //MARK:- OUTLETS
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var signInBTN: UIButton!
    @IBOutlet weak var userNameTF: UITextField!
    
    
    @IBOutlet weak var layoutConstaintAppleloginHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstaintAppleloginORViewTop: NSLayoutConstraint!
    @IBOutlet weak var layoutConstaintAppleloginORViewHeight: NSLayoutConstraint!
    @IBOutlet weak var layoutConstaintAppleloginORViewBottom: NSLayoutConstraint!
    
    
    let provider = OAuthProvider(providerID: "twitter.com")
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTF.placeholder = "Email"
        passwordTF.placeholder = "Password"
                
        //set ASHelper class delegate
        if #available(iOS 13.0, *) {
            ASHelper.shared.delegate = self
            layoutConstaintAppleloginHeight.constant = 54
            layoutConstaintAppleloginORViewTop.constant = 15
            layoutConstaintAppleloginORViewHeight.constant = 24.5
            layoutConstaintAppleloginORViewBottom.constant = 14
        } else {
            // Fallback on earlier versions
            layoutConstaintAppleloginHeight.constant = 0
            layoutConstaintAppleloginORViewTop.constant = 0
            layoutConstaintAppleloginORViewHeight.constant = 0
            layoutConstaintAppleloginORViewBottom.constant = 0
        }
        
        //setAppearance()
        userNameTF.keyboardType = .emailAddress
        
        let loggedIn = UserDefaults.standard.bool(forKey: "ISUSERLOGGEDIN")
        if loggedIn {
            let phone = UserDefaults.standard.string(forKey: Constants.Phone) ?? ""
            let code = UserDefaults.standard.string(forKey: Constants.DialingCode) ?? ""
            let verified = UserDefaults.standard.integer(forKey: Constants.verified)
            let type = UserDefaults.standard.integer(forKey: Constants.type)
            if verified == 0 && type == 0 {
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                vc.phone = phone
                vc.code = code
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        CartHelper.shared.clearCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
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
            
            ValidateData(strMessage: "Please enter email address")
        }
        else if isValidEmail(email: (userNameTF.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
        }
        else if (passwordTF.text?.isEmpty)!{
            
            ValidateData(strMessage: "Please enter password")
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
        
        IJProgressView.shared.showProgressView()
        provider.getCredentialWith(nil) { credential, error in
            
            // IJProgressView.shared.hideProgressView()
            
            if error != nil {
                // Handle error.
                IJProgressView.shared.hideProgressView()
                print("error: \(error!.localizedDescription)");
                return
            }
            if credential != nil {
                
                // IJProgressView.shared.showProgressView()
                Auth.auth().signIn(with: credential!) { (authResult, error) in
                    IJProgressView.shared.hideProgressView()
                    if error != nil {
                        // Handle error.
                        print("error: \(String(describing: error?.localizedDescription))")
                        self.message = error?.localizedDescription ?? ""
                        alert("ChhappanBhog", message: self.message, view: self)
                        return
                    }
                    
                    if let userData = authResult {
                        if let currentUserData = userData.additionalUserInfo {
                            let currentUser = currentUserData.profile ?? [:]
                            let userName = currentUser["name"] as? String ?? ""
                            let userEmail = currentUser["email"] as? String ?? ""
                            
                            let parms : [String:Any] = ["user_email":userEmail,"user_pass":"","type":3,"social_id":"Twitter","name":userName]
                            self.API_LOGIN(params: parms as NSDictionary)
                        } else {
                            print("error: \(String(describing: error?.localizedDescription))")
                            self.message = error?.localizedDescription ?? ""
                            alert("ChhappanBhog", message: self.message, view: self)
                        }
                    } else {
                        print("error: \(String(describing: error?.localizedDescription))")
                        self.message = error?.localizedDescription ?? ""
                        alert("ChhappanBhog", message: self.message, view: self)
                    }
                }
                
                
                
            } else {
                IJProgressView.shared.hideProgressView()
                self.message = error?.localizedDescription ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
            }
        }
        
        
        /*TWTRTwitter.sharedInstance().logIn(completion: { (session, error) in
            if (session != nil) {
                print("signed in as \(session?.userName ?? "")")
                
                let username = session?.userName ?? ""
                let userID = session?.userID ?? ""
                var Email:String = ""
                
                let client = TWTRAPIClient.withCurrentUser()
                client.requestEmail { email, error in
                    
                    if (email != nil) {
                        Email = email ?? ""
                        
                    } else {
                        print("error: \(error!.localizedDescription)");
                    }
                }
                
                    let parms : [String:Any] = ["user_email":Email,"user_pass":"","type":3,"social_id":"Twitter","name":username]
                self.API_LOGIN(params: parms as NSDictionary)
                
            } else {
                
                print("error: \(String(describing: error?.localizedDescription))")
                self.message = error?.localizedDescription ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
                
            }
        })*/
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    @IBAction func continueAsGuestAction(_ sender: UIButton) {
        
        UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
        UserDefaults.standard.set("", forKey: Constants.Name)
        UserDefaults.standard.set("", forKey: Constants.EmailID)
        UserDefaults.standard.set("", forKey: Constants.Phone)
        UserDefaults.standard.set("", forKey: Constants.DialingCode)
        UserDefaults.standard.set(0,  forKey: Constants.UserId)
        UserDefaults.standard.set(false, forKey: Constants.IsLogin)
        UserDefaults.standard.set("", forKey: Constants.access_token)
        UserDefaults.standard.set(0, forKey: Constants.verified)
        UserDefaults.standard.set(0, forKey: Constants.type)
        UserDefaults.standard.set("", forKey: Constants.Image)
        
        AppDelegate.shared.showHomeScreen()
    }
    
    @IBAction func appleLoginClicked(_ sender: UIButton) {
        if #available(iOS 13.0, *) {
            
            ASHelper.shared.performRequest()
            //signIn completion response will come in ASHelper Delegate functions
        }
    }
    
    
    //MARK:- FACBOOK USERDETAILS
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
            if let result = dict as? [String:Any]{
                 print(result)
                
                //                let googileID = data?["google_id"] as? String ?? ""
                //                UserDefaults.standard.set(googileID, forKey: "googleId")
                
                self.message = result["message"] as? String ?? ""
                let success = result["success"] as? Int ?? 0
                
                if success == 0{
                    alert("ChhappanBhog", message: self.message, view: self)
                }else{
                    let data = result["data"] as? [String:Any] ?? [:]
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let phone = data["phone"] as? String ?? ""
                    let code = data["country_code"] as? String ?? "+91"
                    let user_id = data["user_id"] as? Int ?? 0
                    let token = data["token"] as? String ?? ""
                    let verified = Int(data["verified"] as? String ?? "0") ?? 0
                    let type = data["type"] as? Int ?? 0
                    let imageStr = data["image"] as? String ?? ""
                    
                    print(user_id)
                    print(token)
                    
                    UserDefaults.standard.set(true, forKey: "ISUSERLOGGEDIN")
                    UserDefaults.standard.set(name, forKey: Constants.Name)
                    UserDefaults.standard.set(email, forKey: Constants.EmailID)
                    UserDefaults.standard.set(phone, forKey: Constants.Phone)
                    UserDefaults.standard.set(code, forKey: Constants.DialingCode)
                    UserDefaults.standard.set(user_id, forKey: Constants.UserId)
                    UserDefaults.standard.set(true, forKey: Constants.IsLogin)
                    UserDefaults.standard.set(token, forKey: Constants.access_token)
                    UserDefaults.standard.set(verified, forKey: Constants.verified)
                    UserDefaults.standard.set(type, forKey: Constants.type)
                    UserDefaults.standard.set(imageStr, forKey: Constants.Image)
                    
                    if verified == 0 && type == 0 {
                        // Ask for phone verification again
                        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                        vc.phone = phone
                        vc.code = code
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        AppDelegate.shared.uploadTokenToServer()
                        AppDelegate.shared.showHomeScreen()
//                        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }) { (error) in
            alert("ChhappanBhog", message: "We're facing an internal issue. Please try after sometime.", view: self)
        }
        
    }
}
//MARK:- APPLE LOGIN
extension SignInVC: LoginDelegate {
    func authorizationDidCompleteWith(data: [String : Any?]) {
        
        let email = data["email"] as? String ?? ""
        let kemail = email.replacingOccurrences(of: "N/A", with: "")
        
        let userID = data["userID"]  as? String ?? ""
        let kuserID = userID.replacingOccurrences(of: "N/A", with: "")
        
        let name = data["name"]  as? String ?? ""
        let kname = name.replacingOccurrences(of: "N/A", with: "")
        
        let parms : [String:Any] = ["user_email": kemail, "password": "", "type": 4, "social_id": kuserID, "name": kname]
        
       // print(data)
       // print(parms)
        
        API_LOGIN(params: parms as NSDictionary)
        
        //  ["userID": Optional("000486.a05e27cfd4f14c4188201c423861cfd6.1307"), "email": Optional("N/A"), "tokenID": Optional(773 bytes), "status": Optional(1), "name": Optional("N/A")]
    }
    
    func didCompleteWithError(error: Error?) {
        print("Errrrr")
    }    
}


//MARK:- GOOGLE SIGN IN METHODS
extension SignInVC: GIDSignInDelegate{
    
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
