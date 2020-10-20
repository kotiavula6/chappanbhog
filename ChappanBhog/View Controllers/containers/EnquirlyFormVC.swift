//
//  EnquirlyFormVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class EnquirlyFormVC: UIViewController {
    var message:String = ""
    
    //MARK:- OUTLETS
    @IBOutlet weak var contactInformationView: UIView!
    @IBOutlet weak var fieldsView: UIView!
    @IBOutlet weak var EnquireBTN: UIButton!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var layoutConstaintButtonTop: NSLayoutConstraint!
    fileprivate let lblPlaceHolder: UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
    
    var EnquiryAction:(()->())?
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactInformationView.isHidden = false
        self.fieldsView.isHidden = true
        layoutConstaintButtonTop.constant = -30
        setAppearance()
        messageTextView.delegate = self
        setUpPlaceholder()
        clear()
        EmailTF.keyboardType = .emailAddress
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
        
        if !self.contactInformationView.isHidden {
            self.contactInformationView.isHidden = true
            self.fieldsView.isHidden = false
            layoutConstaintButtonTop.constant = 2
            self.view.layoutIfNeeded()
            return
        }
        
        let validate = validates()
        if validate {
            API_ENQUIRY()
        }
    }
    
    // MARK:- Methods
    func validates() -> Bool {
        let name  = NameTF.text ?? ""
        let email = EmailTF.text ?? ""
        let message = messageTextView.text ?? ""

        if name.isEmpty {
            ValidateData(strMessage: "Please enter your name.")
            return false
        }
        
        if email.isEmpty {
            ValidateData(strMessage: "Please enter your email.")
            return false
        }
        
        if !isValidEmail(email: email) {
            ValidateData(strMessage: "Enter a valid email.")
            return false
        }
        
        if message.isEmpty {
            ValidateData(strMessage: "Please enter a message.")
            return false
        }
        
        return true
    }
    
    fileprivate func setUpPlaceholder() {
        self.lblPlaceHolder.text = "Message..."
        self.lblPlaceHolder.textColor = UIColor.lightGray
        self.lblPlaceHolder.font = self.messageTextView.font
        self.lblPlaceHolder.sizeToFit()
        var rect = self.lblPlaceHolder.frame
        rect.origin.x = 4.0
        rect.origin.y = 8.0
        self.lblPlaceHolder.frame = rect
        self.messageTextView.addSubview(self.lblPlaceHolder)
    }
    
    fileprivate func showHidePlaceholder() {
        let text = messageTextView.text
        lblPlaceHolder.isHidden = text?.count ?? 0 > 0
    }
    
    fileprivate func clear() {
        DispatchQueue.main.async {
            self.NameTF.text = ""
            self.EmailTF.text = ""
            self.messageTextView.text = ""
        }
    }
}

//MARK:- API
extension EnquirlyFormVC {
    
    func API_ENQUIRY() {
        
        IJProgressView.shared.showProgressView()
        let EnuiryUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ENQUIRY
        
        let parms : [String:Any] = ["name": NameTF.text ?? "","email":EmailTF.text ?? "","message": messageTextView.text ?? ""]
        AFWrapperClass.requestPOSTURL(EnuiryUrl, params: parms, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            self.message = dict["message"] as? String ?? ""
            let success = dict["success"] as? Int ?? 0
            
            if success == 1 {
                self.clear()
                alert("ChhappanBhog", message: self.message, view: self)
            } else {
                alert("ChhappanBhog", message: self.message, view: self)
            }
            
        }) { (error) in
            self.message = error.localizedDescription
            alert("ChhappanBhog", message: self.message, view: self)
        }
        
    }
    
}


extension EnquirlyFormVC: UITextViewDelegate {
    // MARK:- TextView Delegates
    func textViewDidChange(_ textView: UITextView) {
        showHidePlaceholder()
    }
}
