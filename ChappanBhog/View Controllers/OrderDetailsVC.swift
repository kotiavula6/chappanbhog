//
//  OrderDetailsVC.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 22/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController {
    
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var itemsLeftLBL: UILabel!
    @IBOutlet weak var btnBack: UIButton!

    var dataObj : Datum!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAppearance()
        let text = "Order Id: #\(dataObj.id) (\(dataObj.status.capitalized))"
        itemsLeftLBL.text = text
    }
    

    //MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.subTitleView.layer.cornerRadius = 30
            self.subTitleView.layer.masksToBounds = true
            self.subTitleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.cornerRadius = self.cartLBL.frame.height/2
            self.cartLBL.layer.masksToBounds = true
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TABLEVIEW METHODS
extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataObj.lineItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < dataObj.lineItems.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrderDetailsTableCell") as! OrderDetailsTableCell
            cell.selectionStyle = .none
            let item = dataObj.lineItems[indexPath.row]
            
            let image = ""
            cell.productIMG.image = PlaceholderImage.Category
            //cell.productIMG.sd_setImage(with: URL(string: image), placeholderImage: PlaceholderImage.Category)
            
            var name = item.name.uppercased()
            if item.quantity > 1 {
                name += " x \(item.quantity)"
            }
            cell.productName.text = name
            
            var price = item.total.prefixINR
            if dataObj.currency.lowercased() != "inr" {
                price = dataObj.currency + " " + item.total
            }
            cell.PriceLBL.text = price
            
            return cell
        }
        
        let addressCell = tableView.dequeueReusableCell(withIdentifier: "CartFinalAddressCell") as! CartFinalAddressCell
        addressCell.selectionStyle = .none
        addressCell.lblAddress.text = dataObj.shippingAddress.fullAddress
        addressCell.btnChangeAddress.isHidden = true
        
        var orderPrice = dataObj.subtotal.prefixINR
        if dataObj.currency.lowercased() != "inr" {
            orderPrice = dataObj.currency + " " + dataObj.subtotal
        }
        
        var totalPrice = dataObj.total.prefixINR
        if dataObj.currency.lowercased() != "inr" {
            totalPrice = dataObj.currency + " " + dataObj.total
        }
        
        var shippingPrice = dataObj.totalShipping.prefixINR
        if dataObj.currency.lowercased() != "inr" {
            shippingPrice = dataObj.currency + " " + dataObj.totalShipping
        }
        
        addressCell.lblOrderPrice.text = orderPrice
        addressCell.lblShippingPrice.text = shippingPrice
        addressCell.lblTotalPrice.text = totalPrice
        return addressCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// Tableview cell
class OrderDetailsTableCell: UITableViewCell {
    
    @IBOutlet weak var PriceLBL: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var shadowView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
