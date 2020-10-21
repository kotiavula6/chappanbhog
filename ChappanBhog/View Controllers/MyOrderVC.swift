//
//  MyOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class MyOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var myOrdersTable: UITableView!
    
    var orderDataObj : MyOrderModel?
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        getMyOrders()
    }
    
    // MRAK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.myOrdersTable.reloadData()
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- TABLEVIEW METHODS
extension MyOrderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataObj = self.orderDataObj {
            return dataObj.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myOrdersTable.dequeueReusableCell(withIdentifier: "MyordreTableCell") as! MyordreTableCell
        cell.clipsToBounds = false
        cell.contentView.clipsToBounds = false
        cell.selectionStyle = .none
        if let dataObj = self.orderDataObj {
            cell.lblPrice.text = "\(dataObj.data[indexPath.row].currency) \(dataObj.data[indexPath.row].total)".remove00IfInt.replceINRWithR
            cell.productNameLBL.text = dataObj.data[indexPath.row].lineItems[0].name.uppercased()
            cell.lblCurrentDate.text = dataObj.data[indexPath.row].createdAt
            
            let status = dataObj.data[indexPath.row].status.capitalized
            cell.lblItemStatus.text = status
            if status.contains("Cancel") {
                cell.iVStatus.image = #imageLiteral(resourceName: "cancel_order")
            }
            else {
                cell.iVStatus.image = #imageLiteral(resourceName: "delivered")
            }
        }
        return cell
    }
}

// Tableview cell
class MyordreTableCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemStatus: UILabel!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var iVStatus: UIImageView!
    
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
    }
}


extension MyOrderVC {
    func getMyOrders() {
        // let userID = UserDefaults.standard.value(forKey: Constants.UserId) ?? ""
        let ordersUrl = "https://www.chhappanbhog.com/restapi/example/getorder.php?customer_id=44918"
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURLWithoutToken(ordersUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            if let result = dict as? Dictionary<String, Any> {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result , options: .prettyPrinted)
                    do {
                        let jsonDecoder = JSONDecoder()
                        let orderDetail = try jsonDecoder.decode(MyOrderModel.self, from: jsonData)
                        self.orderDataObj = orderDetail
                        self.reloadTable()
                    }  catch {
                        print("Unexpected error: \(error).")
                        alert("ChhappanBhog", message: error.localizedDescription, view: self)
                    }
                    
                } catch {
                    print("Unexpected error: \(error).")
                }
            } else {
                
            }
        }) { (error) in
            // IJProgressView.shared.hideProgressView()
            print("Unexpected error: \(error).")
        }
    }
    
}


extension String {
    var remove00IfInt: String {
        if self.contains(".00") {
            return self.replacingOccurrences(of: ".00", with: "")
        }
        if self.contains(".0") {
            return self.replacingOccurrences(of: ".0", with: "")
        }
        return self
    }
    
    var replceINRWithR: String {
        return self.replacingOccurrences(of: "INR", with: "₹")
    }
    
    func defaultIfEmpty(_ str: String) -> String {
        if self.isEmpty { return str}
        return self
    }
}
