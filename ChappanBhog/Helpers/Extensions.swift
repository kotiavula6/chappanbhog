//
//  Extensions.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 14/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

extension String {
    var floatValue: Float
    {
        return (self as NSString).floatValue
    }
    var decodeEmoji: String{
        let data = self.data(using: String.Encoding.utf8);

        let decodedStr = NSString(data: data!, encoding: String.Encoding.nonLossyASCII.rawValue)
        if let str = decodedStr
        {
            return str as String
        }

        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var encodeEmoji: String
    {

        if let encodeStr = NSString(cString: self.cString(using: .nonLossyASCII)!, encoding: String.Encoding.utf8.rawValue)
        {
            return encodeStr as String
        }
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func emojiToImage() -> UIImage? {
        let size = CGSize(width: 30, height: 35)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.white.set()
        let rect = CGRect(origin: CGPoint(), size: size)
        UIRectFill(rect)
        (self as NSString).draw(in: rect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
