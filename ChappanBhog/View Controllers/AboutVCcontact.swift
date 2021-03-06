//
//  AboutVCcontact.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class AboutVCcontact: UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var gradientView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.scrollview.layer.cornerRadius = 30
            self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            //  scrollview
        }
        
    }
    


}
