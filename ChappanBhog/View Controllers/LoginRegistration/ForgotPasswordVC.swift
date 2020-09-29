//
//  ForgotPasswordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 15/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var gradientView: UIView!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAppearance()
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view:self.gradientView )
        }
    }

  //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
