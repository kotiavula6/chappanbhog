//
//  AboutVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var enquiryBTN: UIButton!
    @IBOutlet weak var messageTV: UITextView!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var enquiryContainer: UIView!
    var enquiryView:EnquirlyFormVC?
    
    //MARK:- APPLICAITON LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SetAppearance()
        
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.view.layoutIfNeeded()
            //            self.nameTF.setLeftPaddingPoints(10)
            //            self.nameTF.layer.masksToBounds = true
            //
            //            self.emailTF.setLeftPaddingPoints(10)
            //            self.emailTF.layer.masksToBounds = true
            
        }
    }
    
    override func viewWillLayoutSubviews() {
        setGradientBackground(view: self.gradientView)
    }
    
    //MARK:- FUCNCTIONS
    func SetAppearance() {
        self.backView.layer.cornerRadius = 30
        self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        self.scrollview.layer.cornerRadius = 30
        self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
    
    //MARK:- SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnquirlyFormVC" {
            enquiryView = segue.destination as? EnquirlyFormVC
            enquiryView?.EnquiryAction = {
                
            }
        }
    }
    
    
    //MARK:- ACTIONS
    @IBAction func enquiryNowButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        AppDelegate.shared.showHomeScreen()
       // self.navigationController?.popViewController(animated: true)
    }
}
