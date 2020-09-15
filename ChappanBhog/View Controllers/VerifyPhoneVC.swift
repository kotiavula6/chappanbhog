//
//  VerifyPhoneVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class VerifyPhoneVC: UIViewController {

    @IBOutlet weak var TF4: UITextField!
    @IBOutlet weak var TF3: UITextField!
    @IBOutlet weak var TF2: UITextField!
    @IBOutlet weak var TF1: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func ResendAction(_ sender: UIButton) {
        
    }
    
    @IBAction func verifyClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "DashBoardVC") as! DashBoardVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
