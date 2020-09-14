//
//  Constants.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit


//MARK:- BACKGROUND GRADIENT COLOR

let SCREEN_WIDTH =  UIScreen.main.bounds.size.width
let SCREEN_HEIGHT =  UIScreen.main.bounds.size.height
let SCREEN_MAX_LENGTH = max(SCREEN_WIDTH, SCREEN_HEIGHT)
let SCREEN_MIN_LENGTH = min(SCREEN_WIDTH, SCREEN_HEIGHT)

func setGradientBackground(view: UIView) {
    let colorTop =  UIColor(red: 252.0/255.0, green: 167.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 229/255.0, green: 112.0/255.0, blue: 28.0/255.0, alpha: 1.0).cgColor
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds
    
    view.layer.insertSublayer(gradientLayer, at:0)
}


    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPad5Gen_Air_Pro9 = "iPad5Gen, Air, Air 2, Pro9"
        case iPadPro10 = "iPadPro10"
        case iPadPro12 = "iPadPro12.9"
        case unknown
    }
    
    var deviceType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        case 2048:
            return .iPad5Gen_Air_Pro9
        case 2224:
            return .iPadPro10
        case 2732:
            return .iPadPro12
        default:
            return .unknown
        }
    }
    


//MARK:- Button
extension UIButton {
    
    func setStandardCornerRadius(radius : CGFloat) {
        self.layer.cornerRadius = radius
    }
}
//MARK: //////    Change TF Placeholder Color  ////////
extension UITextField {
    
    func setPlaceHolderColorWith(strPH:String, color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string: strPH, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func givingTextfieldLeftPadding(padding: CGFloat) {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.bounds.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    func setLeftIcon(_ icon: UIImage, padding: CGFloat, widthSize: CGFloat, heightSize: CGFloat) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: widthSize+padding, height: heightSize) )
        let iconView  = UIImageView(frame: CGRect(x: padding/2, y: 0, width: widthSize, height: heightSize))
        iconView.layer.cornerRadius = iconView.bounds.size.height / 2
        iconView.image = icon
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
    
    func setLeftImageForCurrencyIcon(urlString: String) {
        let outerView = UIView(frame: CGRect(x: 0, y: 0, width: 25+20, height: 25) )
        let iconView  = UIImageView(frame: CGRect(x: 10, y: 0, width: 25, height: 25))
        iconView.layer.cornerRadius = iconView.bounds.size.width / 2
        iconView.imageFromURL(urlString: urlString)
        outerView.addSubview(iconView)
        leftView = outerView
        leftViewMode = .always
    }
    
    func setRightIcon(_ icon: UIImage, padding: CGFloat, widthSize: CGFloat, heightSize: CGFloat) {
        let iconView  = UIImageView(frame: CGRect(x: padding, y: 0, width: widthSize, height: heightSize))
        iconView.image = icon
        rightView = iconView
        rightViewMode = .always
    }
    
}

//MARK:- ImageView
extension UIImageView {
    func downloadImageFromURL(urlString: String, placeHolder: UIImage) {
        let url = URL(string: urlString)
//        self.kf.indicatorType = .activity
//        self.kf.setImage(with: url, placeholder: placeHolder)
    }
    
    func imageFromURL(urlString: String) {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        self.addSubview(activityIndicator)
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                if image != nil{
                    self.image = image
                } else {
                    self.image = UIImage(named: "DemoFlag")
                }
                activityIndicator.removeFromSuperview()
            })
        }).resume()
    }
    
    func setImageColor(color: UIColor) {
       let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
       self.image = templateImage
       self.tintColor = color
     }
}

//MARK: //////    UIViewcontroller  ////////
extension UIViewController {
    
 
   
    func dismissViewController(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func popViewController(animate:Bool=true){
        self.navigationController?.popViewController(animated: animate)
    }
    

    
    func hideNavigationBar(){
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar(){
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func isValidPassword(password: String) -> Bool {
        //Minimum 6 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
        let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func showAlertWithTitle(title:String, message:String, okButton:String, cancelButton:String, okSelectorName:Selector?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if okSelectorName != nil {
            let OKAction = UIAlertAction(title: okButton, style: .default) { (action:UIAlertAction!) in
                self.perform(okSelectorName)
            }
            alertController.addAction(OKAction)
        } else {
            let OKAction = UIAlertAction(title: okButton, style: .default, handler: nil)
            alertController.addAction(OKAction)
        }
        
        if cancelButton != "" {
            let cancleAction = UIAlertAction(title: cancelButton, style: .destructive) { (action:UIAlertAction!) in
                print("cancel")
            }
            alertController.addAction(cancleAction)
        }
        self.present(alertController, animated: true, completion:nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

func setShadowRadius(view:UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    view.layer.shadowOpacity = 0.8
    view.layer.shadowRadius = 9.0
    view.layer.cornerRadius = 20
    //view.layer.masksToBounds = true
}

func setShadowatBottom (view: UIView, color: UIColor, shadowRadius: CGFloat) {
    
    view.layer.shadowColor = color.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = shadowRadius
    view.layer.shadowOffset = CGSize(width: 0, height: shadowRadius)
    view.layer.masksToBounds = false
    view.layoutIfNeeded()
}

func setBorder (view: UIView, color: UIColor, width: CGFloat) {
    
    view.layer.borderColor = color.cgColor
    view.layer.borderWidth = width
}


func ShowAlert(AlertTitle: String,AlertDisc: String, View:UIViewController)
   {
       print(AlertTitle)
       let alert = UIAlertController(title: AlertTitle, message: AlertDisc, preferredStyle: UIAlertController.Style.alert)
       alert.addAction(UIAlertAction(title:"Ok", style: UIAlertAction.Style.default, handler: nil))
       View.present(alert, animated: true, completion: nil)
   }
