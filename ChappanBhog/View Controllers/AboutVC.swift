//
//  AboutVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
        }
        
    }
    

}
