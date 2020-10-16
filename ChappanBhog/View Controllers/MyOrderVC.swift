//
//  MyOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
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
    
    //MRAK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        }
    }
    
    
    func getMyOrders() {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) ?? ""
        let ordersUrl = "https://www.chhappanbhog.com/restapi/example/getorder.php?customer_id=\(44918)"
        AFWrapperClass.requestGETURLWithoutToken(ordersUrl, success: { (dict) in
            if let result = dict as? Dictionary<String, Any>{
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: result , options: .prettyPrinted)
                    do {
                        let jsonDecoder = JSONDecoder()
                        let orderDetail = try jsonDecoder.decode(MyOrderModel.self, from: jsonData)
                       print(orderDetail)
                        self.orderDataObj = orderDetail
                        self.myOrdersTable.reloadData()
                       // print(countryStateObj)
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
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
//MARK:- TABLEVIEW METHODS
extension MyOrderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataObj = self.orderDataObj {
            return dataObj.data.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myOrdersTable.dequeueReusableCell(withIdentifier: "MyordreTableCell") as! MyordreTableCell
        if let dataObj = self.orderDataObj {
            cell.lblPrice.text = "\(dataObj.data[indexPath.row].currency) \(dataObj.data[indexPath.row].total)"
            cell.productNameLBL.text = dataObj.data[indexPath.row].lineItems[0].name
            cell.lblItemStatus.text = dataObj.data[indexPath.row].status
            cell.lblCurrentDate.text = dataObj.data[indexPath.row].createdAt
        }
            
        return cell
    }
    
    
}


//Tableview cell
class MyordreTableCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblItemStatus: UILabel!
    @IBOutlet weak var lblCurrentDate: UILabel!
    
    
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
    }
    
}
