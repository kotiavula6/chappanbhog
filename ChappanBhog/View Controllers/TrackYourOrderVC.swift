//
//  TrackYourOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class TrackYourOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var trackOrderBTN: UIButton!
    @IBOutlet weak var amountLBL: UILabel!
    @IBOutlet weak var deliveryAddressLBL: UILabel!
    @IBOutlet weak var estimatedTimeLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var orderIDTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    //MARK:-FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
   
        }
        orderIDTF.setLeftPaddingPoints(10)
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func trackOrderButtonAction(_ sender: UIButton) {
        
    }
}
