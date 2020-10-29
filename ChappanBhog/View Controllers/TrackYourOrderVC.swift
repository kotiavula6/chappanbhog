//
//  TrackYourOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import Alamofire

class TrackYourOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var trackOrderBTN: UIButton!
    @IBOutlet weak var amountLBL: UILabel!
    @IBOutlet weak var deliveryAddressLBL: UILabel!
    @IBOutlet weak var estimatedTimeLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var orderIDTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
    }
    
    //MARK:-FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        orderIDTF.setLeftPaddingPoints(10)
    }
    
    func showOrderTrackingDetails(orderId: String, trackingURL: String) {
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderTrackVC") as! OrderTrackVC
            vc.titleText = "Order Id: #\(orderId)"
            vc.url = trackingURL
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func trackOrderButtonAction(_ sender: UIButton) {
        let orderId = orderIDTF.text ?? ""
        if orderId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            ValidateData(strMessage: "Please enter order id.")
            return
        }
        
        orderIDTF.resignFirstResponder()
        IJProgressView.shared.showProgressView()
        getTrackingURL(orderId: orderId) { (trackingURL) in
            IJProgressView.shared.hideProgressView()
        }
    }
}


// MARK:- APIs
extension TrackYourOrderVC {
    func getTrackingURL(orderId: String, completion: @escaping (_ trackingURL: String) -> Void) {
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/trackorder.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let params = ["order_id": orderId]
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                IJProgressView.shared.hideProgressView()
                switch response.result {
                case .success(let value):
                    
                    let data = value as? [String: Any] ?? [:    ]
                    let status = data["status"] as? Bool ?? false
                    let msg = data["msg"] as? String ?? "No Shipping information found."
                    let url = data["url"] as? String ?? "url"
                    
                    if !status {
                        alert("ChhappanBhog", message: msg, view: self)
                        return
                    }
                    
                    // Show order details
                    self.showOrderTrackingDetails(orderId: orderId, trackingURL: url)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    let error : NSError = error as NSError
                    alert("ChhappanBhog", message: error.localizedDescription, view: self)
                }
        }
    }
}
