//
//  HelperMethods.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 24/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

func validateEmail(_ email:String)->Bool
{
    let emailRegex="[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,7}"
    let emailTest=NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with:email)
}
func validateBirthDate(_ date:String)->Bool
{
    let dateRegEx = "^(0[1-9]|[12][0-9]|3[01])[- \\.](0[1-9]|1[012])[- \\.](19|20)\\d\\d$"
    let dateTest=NSPredicate(format:"SELF MATCHES %@", dateRegEx)
    return dateTest.evaluate(with:date)
}


 func alert(_ title : String, message : String, view:UIViewController)
{
    let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
    view.present(alert, animated: true, completion: nil)
}
func showMessage(title: String, message: String, okButton: String, cancelButton: String, controller: UIViewController, okHandler: (() -> Void)?, cancelHandler: @escaping (() -> Void)) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    let cancelAction = UIAlertAction(title: cancelButton, style: UIAlertAction.Style.default) {
        (action) -> Void in
        cancelHandler()
    }
    
    alertController.addAction(dismissAction)
    alertController.addAction(cancelAction)

  //  UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
            controller.present(alertController, animated: true, completion: nil)
}
func showAlertMessage(title: String, message: String, okButton: String, controller: UIViewController, okHandler: (() -> Void)?){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let dismissAction = UIAlertAction(title: okButton, style: UIAlertAction.Style.default) { (action) -> Void in
        if okHandler != nil {
            okHandler!()
        }
    }
    alertController.addAction(dismissAction)
   // UIApplication.shared.windows[0].rootViewController?.present(alertController, animated: true, completion: nil)
    controller.present(alertController, animated: true, completion: nil)

}

func showErrorMessageWithYesNo(message: String, yesTitle: String, noTitle: String, image: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?){
    //whenever update the pod all preoperties will be default. for change the icon size and background circle size change go to pods->SCLAlertView->SCLAlerView.swift-> change the kCircleIconHeight and kCircleHeight
    let appearance = SCLAlertView.SCLAppearance(
        showCloseButton: false, buttonsLayout: SCLAlertButtonLayout.horizontal
    )
    let alertView = SCLAlertView(appearance: appearance)
   
    let alertViewIcon = UIImage(named: image)
    
    alertView.addButton(noTitle, backgroundColor: #colorLiteral(red: 0.6398667693, green: 0.7262453437, blue: 0.9006753564, alpha: 1), textColor: UIColor.white) {
        // print("no")
        if cancelHandler != nil {
            cancelHandler!()
        }
    }
    alertView.addButton(yesTitle, backgroundColor: #colorLiteral(red: 0.3960784314, green: 0.5411764706, blue: 0.8352941176, alpha: 1), textColor: UIColor.white, action: {
        if okHandler != nil {
            okHandler!()
        }
    })
//    alertView.showInfo("", subTitle: message, closeButtonTitle: "OK", colorStyle: 0x658AD5, circleIconImage: alertViewIcon)
   // alertView.showCustom("", subTitle: message, color: #colorLiteral(red: 0.3960784314, green: 0.5411764706, blue: 0.8352941176, alpha: 1), icon: alertViewIcon!)
    alertView.showError("", subTitle: message, closeButtonTitle: "Ok", colorStyle: 0x658AD5, circleIconImage: alertViewIcon)
    
}
extension String{
    var trimWhiteSpace: String{
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var htmlStripped : String{
        let tagFree = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return tagFree.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
    }
}

extension UIViewController{

    func hideKeyboardTappedAround(){

        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)

    }

    @objc func dismissKeyboard(){

        view.endEditing(true)

    }

}
extension UIViewController {
    
    func ValidateData(strMessage: String)
    {
        let alert = UIAlertController(title: "ChappanBhog", message: strMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
      

