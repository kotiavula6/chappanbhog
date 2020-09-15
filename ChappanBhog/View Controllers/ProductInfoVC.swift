//
//  ProductInfoVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class ProductInfoVC: UIViewController {
    
    
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    var quantity:Int = 1
    @IBOutlet weak var cartLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.masksToBounds = true
            self.cartLBL.layer.cornerRadius = self.cartLBL.layer.frame.height/2
        }
        
    }
    
    @IBAction func increseBTN(_ sender: UIButton) {
        quantity += 1
        quantityLBL.text = "\(quantity)"
    }
    
    @IBAction func decreaseBTN(_ sender: UIButton) {
        if quantity >= 2 {
            quantity -= 1
            quantityLBL.text = "\(quantity)"
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
                       self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
