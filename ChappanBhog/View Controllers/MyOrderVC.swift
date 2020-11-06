//
//  MyOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

enum CBOrderStatus: String {
    case pending    = "pending"
    case processing = "processing"
    case shipped    = "shipped"
    case completed  = "completed"
    case cancelled  = "cancelled"
}

class MyOrderVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var myOrdersTable: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
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
            if let dataObj = self.orderDataObj, dataObj.data.count > 0 {
                self.myOrdersTable.isHidden = false
                self.lblNoData.isHidden = true
            }
            else {
                self.myOrdersTable.isHidden = true
                self.lblNoData.isHidden = false
            }
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
            
            var createdDateStr = dataObj.data[indexPath.row].createdAt // 2020-10-27T13:36:13Z
            CartHelper.shared.df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let createdDate = CartHelper.shared.df.date(from: createdDateStr) {
                CartHelper.shared.df.dateFormat = "yyyy-MM-dd hh:mm a"
                createdDateStr = CartHelper.shared.df.string(from: createdDate)
            }
            cell.lblCurrentDate.text = createdDateStr
            
            var itemText = dataObj.data[indexPath.row].lineItems[0].name.uppercased()
            let itemCount = dataObj.data[indexPath.row].lineItems.count
            if itemCount > 1 {
                itemText += " AND \(itemCount - 1) MORE"
            }
            cell.productNameLBL.text = itemText

            let status = dataObj.data[indexPath.row].status
            cell.lblItemStatus.text = status.capitalized
            if status.lowercased().contains("cancel") {
                cell.iVStatus.image = #imageLiteral(resourceName: "cancel_order")
                cell.shadowView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.6352941176, blue: 0.662745098, alpha: 1)
            }
            else if status.lowercased().contains("complete") {
                cell.iVStatus.image = #imageLiteral(resourceName: "delivered")
                cell.shadowView.backgroundColor = .white
            }
            else {
                cell.iVStatus.image = #imageLiteral(resourceName: "pending")
                cell.shadowView.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.7176470588, blue: 0.462745098, alpha: 1)
            }
            
            cell.viewDetailsBlock = {
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
                vc.dataObj = dataObj.data[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
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
    @IBOutlet weak var btnViewDetails: UIButton!
    
    var viewDetailsBlock: SimpleBlock?
    
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
        btnViewDetails.addTarget(self, action: #selector(viewDetailsAction(_:)), for: UIControl.Event.touchUpInside)
    }
    
    @objc func viewDetailsAction(_ sender: UIButton) {
        if let block = viewDetailsBlock {
            block()
        }
    }
}


extension MyOrderVC {
    func getMyOrders() {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) ?? ""
        let ordersUrl = "http://3.7.199.43/restapi/example/getorder.php?customer_id=\(userID)"
        //let ordersUrl = "http://3.7.199.43/restapi/example/getorder.php?customer_id=44918"
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURLWithoutToken(ordersUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            if let result = dict as? Dictionary<String, Any> {
                print(result)
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
    
    var numberOnly: String {
        if self.isEmpty { return "" }
        let set = CharacterSet(charactersIn: "0123456789")
        return self.components(separatedBy: set.inverted).joined()
    }
    
    var doubleValue: Double {
        return Double(self) ?? 0
    }
    
    var boolValue: Bool {
        return ["yes", "1", "true"].contains(self.lowercased())
    }
    
    mutating func parseHTML() {
        guard let data = self.data(using: .utf8) else { return }
        do {
            let str = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil).string
            self = str
        }
        catch _ {
            
        }
    }
}


extension UIButton {
    func appEnabled(_ enable: Bool) {
        self.isUserInteractionEnabled = enable
        self.alpha = enable ? 1.0 : 0.4
    }
}
