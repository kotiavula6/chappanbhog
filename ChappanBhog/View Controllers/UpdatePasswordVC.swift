//
//  UpdatePasswordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class UpdatePasswordVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            setShadowRadius(view: self.shadowView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            //
            //                self.scrollview.layer.cornerRadius = 30
            //                self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            //  scrollview
        }

        
        
    }
    
}
