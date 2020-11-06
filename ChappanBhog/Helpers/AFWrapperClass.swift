//
//  AFWrapperClass.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 24/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import NVActivityIndicatorView


class AFWrapperClass{
    
    class func requestPOSTURL(_ strURL : String, params : Parameters, success:@escaping ([String: Any]) -> Void, failure:@escaping (NSError) -> Void){
        let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Authorization":"Bearer \(token)","Content-Type":"application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        success(JSON)
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
    class func requestUrlEncodedPOSTURL(_ strURL : String, params : Parameters, success:@escaping ([String: Any]) -> Void, failure:@escaping (NSError) -> Void){
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: URLEncoding.default, headers: ["Content-Type":"application/x-www-form-urlencoded"])
               .responseJSON { (response) in
                   switch response.result {
                   case .success(let value):
                       if let JSON = value as? [String: Any] {
                        if response.response?.statusCode == 200{
                           success(JSON)
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
    
    class func requestPOSTURLWithHeader(_ strURL : String, params : Parameters, success:@escaping ([String: Any]) -> Void, failure:@escaping (NSError) -> Void){
        
        let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        let header:HTTPHeaders = ["Authorization":"Bearer \(token)","Content-Type": "application/json"]
        
          let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
          AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers: header)
              .responseJSON { (response) in
                  switch response.result {
                  case .success(let value):
                      if let JSON = value as? [String: Any] {
                          success(JSON)
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
    
    
    
    class func requestGETURLWithoutToken(_ strURL: String, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) {
        
        
           let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
             AF.request(urlwithPercentEscapes!, method: .get,encoding: JSONEncoding.default, headers:nil)
                 .responseJSON { (response) in
                     switch response.result {
                     case .success(let value):
                         if let JSON = value as? Any {
                             success(JSON as AnyObject)
                            // print(JSON)
                         }
                     case .failure(let error):
                         let error : NSError = error as NSError
                         //print(error)
                         failure(error)
                         //print(failure)
                     }
             }
    }
    
    
    
    class func requestGETURL(_ strURL: String, success:@escaping (AnyObject) -> Void, failure:@escaping (NSError) -> Void) -> DataRequest {
        
        
        let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
        
        let header:HTTPHeaders = ["Authorization":"Bearer \(token)","Content-Type": "application/json"]

        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return AF.request(urlwithPercentEscapes!, method: .get,encoding: JSONEncoding.default, headers:header)
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
    
    
   class func uploadPhoto(_ url: String, image: UIImage?, params: [String : Any], completion: @escaping (AnyObject) -> (), failure:@escaping (NSError) -> Void) {
        
    
    let token = UserDefaults.standard.value(forKey: Constants.access_token) as? String ?? ""
    
    let header:HTTPHeaders = ["Authorization":"Bearer \(token)","Content-Type": "application/json"]
    
            
        AF.upload(multipartFormData: { multiPart in
            for p in params {
                multiPart.append("\(p.value)".data(using: String.Encoding.utf8)!, withName: p.key)
            }
            if let selectedImage = image {
                multiPart.append(selectedImage.jpegData(compressionQuality: 0.6)!, withName: "image", fileName: "file.jpg", mimeType: "image/jpg")
            }
        }, to: url, method: .post, headers: header) .uploadProgress(queue: .main, closure: { progress in
           // print("Upload Progress: \(progress.fractionCompleted)")
        }).responseJSON(completionHandler: { data in
            print("upload finished: \(data)")
        }).response { (response) in
            switch response.result {
            case .success(let resut):
                if let data = resut {
                    do {
                        let obj = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        completion(obj as AnyObject)
                    } catch let error {
                        failure(error as NSError)
                    }
                }
            case .failure(let err):
                let error : NSError = err as NSError
                failure(error)
            }
        }
    }
    
    class func handle401Error(dict: [String: Any], _ controller: UIViewController) -> Bool {
        if let status = dict["status"] as? Int, status == 401 {
            let message = dict["message"] as? String ?? "Your sessions has been expired. Please login again."
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "ChhappanBhog", message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                    AppDelegate.shared.logout()
                }))
                controller.present(alert, animated: true, completion: nil)
            }
            return true
        }
        return false
    }
        
    class func svprogressHudShow(title:String,view:UIViewController) -> Void {
        SVProgressHUD.show(withStatus: title)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        //SVProgressHUD.setForegroundColor(#colorLiteral(red: 0.7164155841, green: 0.08018933982, blue: 0.427012682, alpha: 1))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setRingThickness(5)
        DispatchQueue.main.async {
            view.view.isUserInteractionEnabled = false;
        }
    }
    
    class func svprogressHudDismiss(view:UIViewController) -> Void {
        SVProgressHUD.dismiss();
        view.view.isUserInteractionEnabled = true;
    }
}



