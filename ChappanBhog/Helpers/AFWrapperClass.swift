//
//  AFWrapperClass.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 24/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import NVActivityIndicatorView


class AFWrapperClass{
    
    class func requestPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
         let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(token)","Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON as NSDictionary)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                  //   print("hhhjjh",error)
                    
                    let message:String = error.localizedDescription
                    IJProgressView.shared.hideProgressView()
              
                    failure(error)
                   // print(failure)
                
                }
        }
    }
    class func requestUrlEncodedPOSTURL(_ strURL : String, params : Parameters, success:@escaping (NSDictionary) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"])
               .responseJSON { (response) in
                   switch response.result {
                   case .success(let value):
                       if let JSON = value as? [String: Any] {
                        if response.response?.statusCode == 200{
                           success(JSON as NSDictionary)
                        }else if response.response?.statusCode == 400{

                            let error : NSError = NSError(domain: "invalid user details", code: 400, userInfo: [:])
                            failure(error)
                            print(failure)
                       }
                    }
                   case .failure(let error):
                       let error : NSError = error as NSError
                        print(error)
                       failure(error)
                    print(failure)
                   }
           }
       }
    
    
    
    class func requestGETURLWithParams(_ strURL: String,params:Parameters , success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        
        
        let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        
        let header:HTTPHeaders = ["Authorization":"Bearer \(token)","Content-Type": "application/json"]

        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get, parameters:params  ,encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? Any {
                        success(JSON as AnyObject)
                        print(JSON)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print(error)
                    failure(error)
                    print(failure)
                }
        }
    }
    
    
    
    class func requestGETURL(_ strURL: String, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        
        
        let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        
        let header:HTTPHeaders = ["Authorization":"Bearer \(token)","Content-Type": "application/json"]

        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .get,encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? Any {
                        success(JSON as AnyObject)
                        print(JSON)
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print(error)
                    failure(error)
                    print(failure)
                }
        }
    }
    class func svprogressHudShow(title:String,view:UIViewController) -> Void
    {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        //SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.7164155841, green: 0.08018933982, blue: 0.427012682, alpha: 1))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingThickness(5)
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = false;
        }
    }
    class func svprogressHudDismiss(view:UIViewController) -> Void
    {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }
}



