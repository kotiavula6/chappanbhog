//
//  AboutVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    @IBOutlet weak var enquiryBTN: UIButton!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
            self.nameTF.setLeftPaddingPoints(10)
            self.nameTF.layer.masksToBounds = true
            
            self.emailTF.setLeftPaddingPoints(10)
            self.emailTF.layer.masksToBounds = true
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.scrollview.layer.cornerRadius = 30
            self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        }
        
    }
    
    @IBAction func enquiryNowButtonAction(_ sender: UIButton) {
        
    }
    
}
