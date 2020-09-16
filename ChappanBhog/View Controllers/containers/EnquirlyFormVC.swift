//
//  EnquirlyFormVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class EnquirlyFormVC: UIViewController {
    
    @IBOutlet weak var contactInformationView: UIView!
    @IBOutlet weak var EnquireBTN: UIButton!
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var messageTextView: UITextView!
    var EnquiryAction:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EmailTF.setLeftPaddingPoints(10)
        self.NameTF.setLeftPaddingPoints(10)
        
        
        
    }
    
    func setAppearance() {
        
        DispatchQueue.main.async {
            self.NameTF.clipsToBounds = true
            self.EmailTF.clipsToBounds = true
            self.NameTF.layer.masksToBounds = true
            self.EmailTF.layer.masksToBounds = true
            self.messageTextView.clipsToBounds = true
        
        }
        
    }
    
    
    @IBAction func enquiryButtonAction(_ sender: UIButton) {
        
        if let action = EnquiryAction {
            action()
            
        }
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.view.sendSubviewToBack(self.contactInformationView)
        }else {
            self.view.bringSubviewToFront(self.contactInformationView)
        }
        
    }
    
}