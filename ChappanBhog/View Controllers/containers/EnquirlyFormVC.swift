//
//  EnquirlyFormVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class EnquirlyFormVC: UIViewController {
    var message:String = ""
    
    //MARK:- OUTLETS
    @IBOutlet weak var contactInformationView: UIView!
    @IBOutlet weak var EnquireBTN: UIButton!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    var EnquiryAction:(()->())?
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        self.view.sendSubviewToBack(self.contactInformationView)
    }
    //MARK:- FUNCTIONS
    func setAppearance() {
        
        DispatchQueue.main.async {
            self.NameTF.clipsToBounds = true
            self.EmailTF.clipsToBounds = true
            self.NameTF.layer.masksToBounds = true
            self.EmailTF.layer.masksToBounds = true
            self.messageTextView.clipsToBounds = true
            
        }
        self.EmailTF.setLeftPaddingPoints(10)
        self.NameTF.setLeftPaddingPoints(10)
        
    }
    
    //MARK:- ACTIONS
    @IBAction func enquiryButtonAction(_ sender: UIButton) {
        API_ENQUIRY()
        //        if let action = EnquiryAction {
        //            action()
        //
        //        }
        //        sender.isSelected = !sender.isSelected
        //        if sender.isSelected {
        //            self.view.sendSubviewToBack(self.contactInformationView)
        //        }else {
        //            self.view.bringSubviewToFront(self.contactInformationView)
        //        }
        //
    }
    
}

//MARK:- API
extension EnquirlyFormVC {
    
    func API_ENQUIRY() {
        
        IJProgressView.shared.showProgressView()
        let EnuiryUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ENQUIRY
        
        let parms : [String:Any] = ["name": NameTF.text ?? "","email":EmailTF.text ?? "","message":messageTextView.text ?? ""]
        AFWrapperClass.requestPOSTURL(EnuiryUrl, params: parms, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            
            if let result = dict as? [String:Any]{
                print(result)
                
                self.message = result["message"] as? String ?? ""
                let success = result["success"] as? Int ?? 0
                
                if success == 0{
                    alert("ChappanBhog", message: self.message, view: self)
                }else{
                    alert("ChappanBhog", message: self.message, view: self)
                    
                }
            }
        }) { (error) in
            self.message = error.localizedDescription
            alert("ChappanBhog", message: self.message, view: self)
        }
        
    }
    
}
