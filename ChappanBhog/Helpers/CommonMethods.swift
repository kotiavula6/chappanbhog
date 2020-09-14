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


func openMenuPanel(_ viewController: UIViewController) {
    
    let vc: SidMenuVC = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "SidMenuVC") as! SidMenuVC
    vc.modalPresentationStyle = .overFullScreen;
    vc.view.backgroundColor = UIColor.init(white: 0/255.0, alpha: 0.5)
    vc.completionHandler = {
        value in
        print(value)
        
      //  AppUtil.PushController(value:value, View:viewController)
    }
    viewController.present(vc, animated: false, completion: {})
}
