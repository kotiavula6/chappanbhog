//
//  UpdatePasswordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class UpdatePasswordVC: UIViewController {

    @IBOutlet weak var updatePasswordBTN: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       setAppearence()
    }
    
    func setAppearence() {
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
           
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.phoneTF.setLeftPaddingPoints(10)
            self.oldPasswordTF.setLeftPaddingPoints(10)
            self.newPasswordTF.setLeftPaddingPoints(10)
            
            
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func updatePasswordButtonAction(_ sender: UIButton) {
        
    }
    
}
