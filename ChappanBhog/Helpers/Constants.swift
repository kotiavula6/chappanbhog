//
//  Constants.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit






//MARK:- BACKGROUND GRADIENT COLOR

func setGradientBackground(view: UIView) {
    let colorTop =  UIColor(red: 252.0/255.0, green: 167.0/255.0, blue: 51.0/255.0, alpha: 1.0).cgColor
    let colorBottom = UIColor(red: 229/255.0, green: 112.0/255.0, blue: 28.0/255.0, alpha: 1.0).cgColor
                
    let gradientLayer = CAGradientLayer()
    gradientLayer.colors = [colorTop, colorBottom]
    gradientLayer.locations = [0.0, 1.0]
    gradientLayer.frame = view.bounds
            
   view.layer.insertSublayer(gradientLayer, at:0)
}
