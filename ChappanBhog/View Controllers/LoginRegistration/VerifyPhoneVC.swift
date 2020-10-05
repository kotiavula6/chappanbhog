//
//  VerifyPhoneVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class VerifyPhoneVC: UIViewController {
    
    var message:String = ""
    //MARK:- OUTLETS
    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF1: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    //http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com/api/verify_account
    
    //MARK:- ACTIONS
    
    @IBAction func ResendAction(_ sender: UIButton) {
        
    }
    
    @IBAction func verifyClicked(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "Home") as! UITabBarController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
extension VerifyPhoneVC {
func API_GET_DASHBOARD_DATA() {
    
    IJProgressView.shared.showProgressView()
    let bannersUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_VERIFY_ACCOUNT
    let params:[String:Any] = ["":""]
    
    AFWrapperClass.requestPOSTURL(bannersUrl, params: params, success: { (dict) in
        IJProgressView.shared.hideProgressView()
        print(dict)
        
        let response = dict["data"] as? NSDictionary ?? NSDictionary()
        let success = dict["success"] as? Int ?? 0
        
        if success == 0 {
            
            self.message = dict["message"] as? String ?? ""
            alert("ChappanBhog", message: self.message, view: self)
            
        }else {
            
         
        }
 
        
    }) { (error) in
        
        IJProgressView.shared.hideProgressView()
        
    }
}
}
