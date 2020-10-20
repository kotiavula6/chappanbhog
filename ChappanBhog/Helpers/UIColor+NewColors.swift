//
//  UIColor+NewColors.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat)
    {
        self.init(red:r/255 ,green: g/255,blue: b/255, alpha: 1.0)
    }
    
    public class func headerColor () -> UIColor
    {
        let headerColor = UIColor(red: 231.0/255.0, green: 235.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        return headerColor
    }
    
    public class func leftColor () -> UIColor
    {
        let leftColor = UIColor(red: 228/255.0, green: 123/255.0, blue: 92/255.0, alpha: 1.0)
        return leftColor
    }
    
    public class func rightColor () -> UIColor
    {
        let rightColor = UIColor(red: 244.0/255.0, green: 160.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        return rightColor
    }
    
    public class func greenColor () -> UIColor
    {
        let rightColor = UIColor(red: 91.0/255.0, green: 199.0/255.0, blue: 82.0/255.0, alpha: 1.0)
        return rightColor
    }
    
    public class func grayLeftColor () -> UIColor
    {
        let leftColor = UIColor(red: 145.0/255.0, green: 145.0/255.0, blue: 145.0/255.0, alpha: 1.0)
        return leftColor
    }
    
    public class func grayRightColor () -> UIColor
    {
        let rightColor = UIColor(red: 187.0/255.0, green: 187.0/255.0, blue: 187.0/255.0, alpha: 1.0)
        return rightColor
    }
    
    public class func blueLeftColor () -> UIColor
    {
        let leftColor = UIColor(red: 90/255.0, green: 136/255.0, blue: 213/255.0, alpha: 1.0)
        return leftColor
    }
    
    public class func blueRightColor () -> UIColor
    {
        let rightColor = UIColor(red: 121.0/255.0, green: 177.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        return rightColor
    }
    
    public class func appColor () -> UIColor
    {
        let appColor = UIColor(red: 236/255.0, green: 160/255.0, blue: 36/255.0, alpha: 1.0)
        return appColor
    }
    
    public class func statusBarBackgroundColor () -> UIColor
    {
        let statusBarBackgroundColor = UIColor(red: 168/255.0, green: 168/255.0, blue: 168/255.0, alpha: 1.0)
        return statusBarBackgroundColor
    }
    
    public class func appBackgroundColor () -> UIColor
    {
        let appBackgroundColor = UIColor(red: 236/255.0, green: 160/255.0, blue: 36/255.0, alpha: 1.0)
        return appBackgroundColor
    }
    
    public class func barIconAndTextColor () -> UIColor
    {
        let barIconAndTextColor = UIColor(red: 209/255.0, green: 209/255.0, blue: 209/255.0, alpha: 1.0)
        return barIconAndTextColor
    }
    
    public class func unSelectedTabItemTextColor () -> UIColor
    {
        let applicationTextColor = UIColor(red: 125.0/255.0, green: 125.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        return applicationTextColor
    }
    
    public class func itemNameColor () -> UIColor
    {
        let textFieldBorderColor1 = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
        return textFieldBorderColor1
    }
    
    public class func textFieldBorderColor () -> UIColor
    {
        let textFieldBorderColor1 = UIColor(red: 203.0/255.0, green: 205.0/255.0, blue: 245.0/255.0, alpha: 0.2)
        return textFieldBorderColor1
    }
    
    public class func hexCode(_ hexString: String) -> UIColor {
        
        var cString:String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
    }

}
