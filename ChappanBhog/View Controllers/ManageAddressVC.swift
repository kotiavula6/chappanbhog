//
//  ManageAddressVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class ManageAddressVC: UIViewController {

    @IBOutlet weak var updateAddressBTN: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

             DispatchQueue.main.async {
                setGradientBackground(view: self.gradientView)
                setShadowRadius(view: self.shadowView)
                self.backView.layer.cornerRadius = 30
                self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            
        }
    }
    

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
