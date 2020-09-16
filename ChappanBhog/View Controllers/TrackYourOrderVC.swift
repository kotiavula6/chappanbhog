//
//  TrackYourOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class TrackYourOrderVC: UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var trackOrderBTN: UIButton!
    
    @IBOutlet weak var deliveryAddressLBL: UILabel!
    @IBOutlet weak var estimatedTimeLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var orderIDTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        orderIDTF.setLeftPaddingPoints(10)
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
 
        }
    }
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func trackOrderButtonAction(_ sender: UIButton) {
        
    }
}
