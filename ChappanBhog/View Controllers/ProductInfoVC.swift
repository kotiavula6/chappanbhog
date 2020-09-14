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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
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
    
}
