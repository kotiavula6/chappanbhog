//
//  CommonMethods.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 14/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit


struct AppConstant
{
    static let APP_DELEGATES = UIApplication.shared.delegate as! AppDelegate
    static let APP_STOREBOARD: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    static let LOGIN_STOREBOARD: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    
}


func showAlert(_ alertMessage: String) {
    
    DispatchQueue.main.async(execute: {
        
        let alert = UIAlertView(title: "", message: alertMessage, delegate: nil, cancelButtonTitle: "Dismiss")
        alert.tintColor = UIColor.darkGray
        alert.show()

        
//        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//        alert.addAction(okAction)
//        appDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
    })
}
