//
//  Uiview+IBinspectable.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

/*:
 
 #Overview
 
 This is for extentions of UIImageView saving loaded image in cache.
 
 */

let imageCache1 = NSCache<NSString, UIImage>()

class DropDownTextField: UITextField {
    @IBInspectable var rightImage : UIImage?{
        didSet{
            self.rightView = UIImageView(image: rightImage)
            // select mode -> .never .whileEditing .unlessEditing .always
            self.rightViewMode = .always
        }
    }
}

extension UITextField
{
    
//    @IBInspectable var rightImage : UIImage?{
//        didSet{
//            self.rightView = UIImageView(image: rightImage)
//            // select mode -> .never .whileEditing .unlessEditing .always
//            self.rightViewMode = .always
//        }
//    }
    
    enum Direction {
        case Left
        case Right
    }
    
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor, isNeedCornerRadius: Bool, imageColor: UIColor = UIColor.black ){
        
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mainView.isUserInteractionEnabled = false
//        applyCornerRadius(tempButton: mainView)
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        view.backgroundColor = UIColor.clear
        view.clipsToBounds = true
//        applyCornerRadius(tempButton: view)
//        view.layer.borderWidth = CGFloat(0.5)
//        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 10.0, y: (view.frame.size.height/2) - 10, width: 20.0, height: 20.0)
        imageView.backgroundColor = UIColor.clear
        view.addSubview(imageView)
        
        if direction == .Right {
            imageView.frame = CGRect(x: 10.0, y: (view.frame.size.height/2) - 7.5, width: 15.0, height: 15.0)
            imageView.alpha = 0.6
        }
        
        
        imageView.setImageColor(color: imageColor)
        
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor.clear
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        seperatorView.backgroundColor = UIColor.clear
        
//        self.layer.borderColor = colorBorder.cgColor
//        self.layer.borderWidth = CGFloat(0.5)
        
//        if isNeedCornerRadius == true {
//            applyCornerRadius(tempButton: self)
//        }
    }
    
    
    func textWithTrimmiedWhiteSpeace() -> String?
    {
        text = (text?.trimmingCharacters(in: CharacterSet.whitespaces))!
        return text
    }
    
    @IBInspectable var paddingLeft: CGFloat {
        get {
            return (leftView?.frame.width)!
        }
        set {
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            leftViewMode = .always
        }
    }
    
    @IBInspectable var paddingRight: CGFloat {
        get {
            return (rightView?.frame.width) ?? 0
        }
        set {
            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: 0))
            rightViewMode = .always
        }
    }
    
    @IBInspectable var bottomLineColor : UIColor {
        get {
            return UIColor.clear
        }set {
            let border: CALayer = CALayer()
            border.borderColor = newValue.cgColor
        }
    }
    
    @IBInspectable var bottomLineWidth : CGFloat {
        
        get {
            return 0
        }
        set{
            let border: CALayer = CALayer()
            border.borderColor = UIColor.darkGray.cgColor
            self.frame = CGRect(x: 0, y: self.frame.size.height - bottomLineWidth, width: self.frame.size.width, height: self.frame.size.height)
           // border.borderWidth = borderWidth
            self.layer.addSublayer(border)
            self.layer.masksToBounds = true
            
            
        }
    }
}

extension UIImageView
{
    
//    func setImageColor(color: UIColor) {
//        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
//        self.image = templateImage
//        self.tintColor = color
//    }
    
    /**
     To load the image
     
     #1. Check image is avaialble in cache or not.
     A. If not Download the image from URL and save in cache.
     B. If the image is avaible in cache then direct pass the image to imageview.
     
     
     - parameters:
      - urlString: The urlString in the Image URL, cannot be empty
     
 */
    func loadImageUsingCacheUrlString(urlString: String)
    {
        if self.image == UIImage(named: "pic") {
            //self.image = #imageLiteral(resourceName: "hdfc_logo")
        }
        else {
          //  self.image = #imageLiteral(resourceName: "cashew")
        }
        
                
        var urlStr = urlString.replacingOccurrences(of: " ", with: "%20")
        
        urlStr = urlStr.replacingOccurrences(of: "\\", with: "/")
        
        #if DEDEBUG
        print(urlStr)
        #endif
        
        //Check cache for image first
        if let cachedImage = imageCache1.object(forKey: urlStr as NSString)
        {
            self.image = cachedImage
            return
        }
        let url = NSURL(string: urlStr)
        if url != nil
        {
            URLSession.shared.dataTask(with: url! as URL){
                data,response,error  in
                
                if error != nil
                {
                    DispatchQueue.main.async {
//                      self.image = #imageLiteral(resourceName: "Top_background")
                        self.backgroundColor = UIColor.gray
                    }
                                        
                    print("fail to download Image from FB with error: \(String(describing: error?.localizedDescription))")
                    return
                }
                
                DispatchQueue.main.async {
                    
                    if let downloadedImage = UIImage(data: data!)
                    {
                        imageCache1.setObject(downloadedImage, forKey: urlStr as NSString)
                        self.backgroundColor = UIColor.white
                        self.image = downloadedImage
                    }
                   }
                }.resume()
        }
    }
}
