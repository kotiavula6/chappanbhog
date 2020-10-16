//
//  UIViewX.swift
//  Vowla
//
//  Created by Dheeraj Chauhan on 22/04/20.
//  Copyright © 2020 RocknEvents. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = layer as! CAGradientLayer
        let color1 = UIColor(displayP3Red: 249/255, green: 202/255, blue: 71/255, alpha: 1.0)
        let color2 = UIColor(displayP3Red: 242/255, green: 136/255, blue: 59/255, alpha: 1.0)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
}


