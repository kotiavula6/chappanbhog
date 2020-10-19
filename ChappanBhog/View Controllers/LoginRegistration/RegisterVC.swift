//
//  RegisterVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import SKCountryPicker
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
//import TwitterKit

class RegisterVC: UIViewController {
    
    //MARK:- OUTLETS
    
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var flagIMG: UIImageView!
    @IBOutlet weak var countryContainer: UIView!
    @IBOutlet weak var mobileTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var countryCodeTF: UITextField!
    @IBOutlet weak var registerBTN: UIButton!
    var message:String = ""
    var isEmailRegisteration: Bool = false
    var selectedCountry: Country?
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTF.keyboardType = .emailAddress
        mobileTF.keyboardType = .phonePad
        nameTF.autocapitalizationType = .words
        
        //set ASHelper class delegate
            if #available(iOS 13.0, *) {
                ASHelper.shared.delegate = self
            } else {
                // Fallback on earlier versions
            }
        
        // Do any additional setup after loading the view.
        
        setAppearance()
    }
    
    //MARK:- ACTIONS
    
    @IBAction func selectCountryButtonClicked(_ sender: UIButton) {
        // Invoke below static method to present country picker without section control
        // CountryPickerController.presentController(on: self) { ... }
        
        let countryController = CountryPickerWithSectionViewController.presentController(on: self) { [weak self] (country: Country) in
            
            guard let self = self else { return }
            
            self.flagIMG.image = country.flag
            self.selectedCountry = country
            //             self.countryBTN.setTitle(country.dialingCode, for: .normal)
            
        }
        
        // can customize the countryPicker here e.g font and color
        countryController.detailColor = UIColor.red
    }
    
    
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        
        if (nameTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter username")
        }
        else if (emailTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter email address")
        }
        else if (mobileTF.text?.count)! > 10 || (mobileTF.text?.count)! < 10 {
            
            ValidateData(strMessage: " Please enter valid mobile")
        }
        else if isValidEmail(email: (emailTF.text)!) == false{
            
            ValidateData(strMessage: "Enter valid email")
        }
        else if (passwordTF.text?.isEmpty)!{
            
            ValidateData(strMessage: " Please enter password")
        }else if (passwordTF.text?.count)! < 4 || (passwordTF.text?.count)! > 15{
            
            ValidateData(strMessage: "Please enter minimum 4 digit password")
            UserDefaults.standard.set(passwordTF.text, forKey: "password")
            UserDefaults.standard.string(forKey: "password")
        }
        else {
            isEmailRegisteration = true
            let phone = mobileTF.text ?? ""
            let code = (self.selectedCountry?.dialingCode ?? "+91")
            let parms : [String:Any] = ["user_email": emailTF.text ?? "","phone": phone,"name":nameTF.text ?? "","password":passwordTF.text ?? "","type":0, "country_code": code]
            API_NEW_USER_REGISTER(params: parms as NSDictionary)
            view.endEditing(true)
        }
    }
    
    @IBAction func loginButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func fbButtonAction(_ sender: UIButton) {
        isEmailRegisteration = false
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
    
    @IBAction func twitterAction(_ sender: UIButton) {
        isEmailRegisteration = false
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
                    self.API_NEW_USER_REGISTER(params: parms as NSDictionary)
                    
                } else {
                    
                    print("error: \(String(describing: error?.localizedDescription))")
                    self.message = error?.localizedDescription ?? ""
                    alert("ChhappanBhog", message: self.message, view: self)
                    
                }
            })*/
        
        
    }
    
    @IBAction func googleAction(_ sender: UIButton) {
        isEmailRegisteration = false
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate=self
        GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    }
    
    @IBAction func appleLoginClicked(_ sender: UIButton) {
        isEmailRegisteration = false
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
                        
                        self.API_NEW_USER_REGISTER(params: parms as NSDictionary)
                        
                    }else {
                        print(error?.localizedDescription ?? "Nothing")
                    }
                })
            }
            
        }
    
    
    //MARK:- UI SETUP
    
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
        passwordTF.setLeftPaddingPoints(10)
        
        guard let country = CountryManager.shared.currentCountry else {
            //            self.countryBTN.setTitle("Pick Country", for: .normal)
            self.flagIMG.isHidden = true
            return
        }
        //        countryBTN.setTitle(country.dialingCode, for: .normal)
        self.selectedCountry = country
        flagIMG.image = country.flag
        //      countryBTN.clipsToBounds = true
        
    }
    
    
    //MARK:- REGISTER USER
    
    func API_NEW_USER_REGISTER(params: NSDictionary) {
        
        IJProgressView.shared.showProgressView()
        let signUpUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_REGISTER
        
//        let parms : [String:Any] = ["user_email": emailTF.text ?? "","phone":mobileTF.text ?? "","name":nameTF.text ?? "","password":passwordTF.text ?? "","type":0]
        AFWrapperClass.requestPOSTURL(signUpUrl, params: params as! [String:Any], success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)

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
//                    email = "asdf@gmail.com";
//                    name = "Agra\U2019s ";
//                    phone = 1231231231;
//                    type = 0;
//                    "user_id" = 45148;
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let phone = data["phone"] as? String ?? ""
                    let user_id = data["user_id"] as? Int ?? 0
                    let token = data["token"] as? String ?? ""
                    
                    UserDefaults.standard.set(name, forKey: Constants.Name)
                    UserDefaults.standard.set(email, forKey: Constants.EmailID)
                    UserDefaults.standard.set(phone, forKey: Constants.Phone)
                    UserDefaults.standard.set(user_id, forKey: Constants.UserId)
                    UserDefaults.standard.set(token, forKey: Constants.access_token)
            
    
                    if self.isEmailRegisteration {
                        // Show phone verification screen
                        let code = (self.selectedCountry?.dialingCode ?? "+91")
                        UserDefaults.standard.set(code, forKey: Constants.DialingCode)
                        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
                        vc.phone = phone
                        vc.code = code
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        // Show home
                        AppDelegate.shared.showHomeScreen()
//                        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
//                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }) { (error) in
        }
        
    }
}

//MARK:- APPLE LOGIN METHODS

extension RegisterVC: LoginDelegate {
    func authorizationDidCompleteWith(data: [String : Any?]) {
        
        let email = data["email"] as? String ?? ""
        let kemail = email.replacingOccurrences(of: "N/A", with: "")
        
        let userID = data["userID"]  as? String ?? ""
        let kuserID = userID.replacingOccurrences(of: "N/A", with: "")
        
        let name = data["name"]  as? String ?? ""
        let kname = name.replacingOccurrences(of: "N/A", with: "")
        
        let parms : [String:Any] = ["user_email":
            kemail ,"password":"","type":4,"social_id":kuserID ,"name":kname ]
       API_NEW_USER_REGISTER(params: parms as NSDictionary)
        print(data)
        print(parms)
        
        //  ["userID": Optional("000486.a05e27cfd4f14c4188201c423861cfd6.1307"), "email": Optional("N/A"), "tokenID": Optional(773 bytes), "status": Optional(1), "name": Optional("N/A")]
    }
    
    func didCompleteWithError(error: Error?) {
        print("Errrrr")
    }
    
    
}

//MARK:- GOOGLE LOGIN METHODS

extension RegisterVC: GIDSignInDelegate{
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
            
          API_NEW_USER_REGISTER(params: parms as NSDictionary)
     
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
