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


//func openMenuPanel(_ viewController: UIViewController) {
//    
//    let vc: SidMenuVC = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "SidMenuVC") as! SidMenuVC
//    vc.modalPresentationStyle = .overFullScreen;
//    vc.view.backgroundColor = UIColor.init(white: 0/255.0, alpha: 0.5)
//    vc.completionHandler = {
//        value in
//        print(value)
//        
//      //  AppUtil.PushController(value:value, View:viewController)
//    }
//    viewController.present(vc, animated: false, completion: {})
//}

//func getDefaultCountryDetailsOfDevice(fillCountryCode: String = "") -> NSDictionary {
//    
//    if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
//        print(countryCode)
//        
//        let countryCodesArray = (countryDictionary["All Countries"] as? NSArray ?? NSArray())
//        
//        #if DEDEBUG
//        print(countryCodesArray)
//        #endif
//
//        // Put your key in predicate that is "Name"
//        var searchPredicate = NSPredicate(format: "code CONTAINS[C] %@", fillCountryCode.count == 0 ? countryCode.uppercased() : fillCountryCode.uppercased())
//        
//        if fillCountryCode.count > 0 {
//            if fillCountryCode.contains("+") {
//                searchPredicate = NSPredicate(format: "dialCode CONTAINS[C] %@", fillCountryCode.count == 0 ? countryCode.uppercased() : fillCountryCode)
//            }
//        }
//        
//        
//        
//        let array = countryCodesArray.filtered(using: searchPredicate)
//
//        #if DEDEBUG
//        print ("array = \(array)")
//        #endif
//
//        return (array.count > 0 ? array[0] as? NSDictionary : NSDictionary())!
//        
//    }
//    
//    return NSDictionary()
//}
