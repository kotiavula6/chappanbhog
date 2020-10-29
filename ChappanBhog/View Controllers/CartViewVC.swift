//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import Alamofire

class CartViewVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var itemsLeftLBL: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    var currentIndexPath: IndexPath?
    var isFromSideMenu = false
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        cartLBL.isHidden = true
        btnCart.isHidden = true
        
        IJProgressView.shared.showProgressView()
        CartHelper.shared.syncAddress { (success, message) in
            IJProgressView.shared.hideProgressView()
            self.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
        self.reloadTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.reloadTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func updateCartCount() {
        let data = CartHelper.shared.cartItems
        if data.count == 0 {
            //cartLBL.text = "0"
            //cartLBL.isHidden = true
            //btnCart.isHidden = true
            btnPay.isHidden = true
        }
        else {
            //cartLBL.text = "\(data.count)"
            //cartLBL.isHidden = false
            //btnCart.isHidden = false
            btnPay.isHidden = false
        }
        updateCartCountInText()
    }
    
    func updateCartCountInText() {
        let itemStr = (CartHelper.shared.cartItems.count == 1) ? "item" : "items"
        self.itemsLeftLBL.text = "You have \(CartHelper.shared.cartItems.count) \(itemStr) in your cart"
    }
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.listTable.reloadData()
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func backButton(_ sender: UIButton) {
        if isFromSideMenu {
            AppDelegate.shared.showHomeScreen()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func paymentButton(_ sender: Any) {
        
        if CartHelper.shared.manageAddress.shipping_zip.isEmpty {
            alert("ChhappanBhog", message: "Please add your address.", view: self)
            return
        }
        
        let weightInfo = CartHelper.shared.calculateTotalWeight()
        if weightInfo.isInPcs {
            // Make sure shipping is in Lucknow area
            if CartHelper.shared.manageAddress.shipping_country.lowercased() == "india" && CartHelper.shared.manageAddress.shipping_city.lowercased() == "lucknow" {
                proceedToPayment()
            }
            else {
                // We don't ship item in pcs outside lucknow
                alert("ChhappanBhog", message: "Unfortunately we can't ship your order. Please refine the cart.", view: self)
            }
        }
        else {
            proceedToPayment()
        }
    }
    
    @objc func addAddress() {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func proceedToPayment() {
        
        IJProgressView.shared.showProgressView()
        
        let price = CartHelper.shared.calculateTotal()
        var shipping = 150.0
        let weightInfo = CartHelper.shared.calculateTotalWeight()
        if weightInfo.weight > 0 {
            shipping = CartHelper.shared.calculateShipping(totalWeight: weightInfo.weight, isInPcs: weightInfo.isInPcs)
        }
        let amount = price + shipping
        
        let model: PayUHelperModel = PayUHelperModel()
        model.amount = String(format: "%.2f", amount)
        model.customerName = CartHelper.shared.manageAddress.firstName
        model.email = CartHelper.shared.manageAddress.email
        model.merchantDisplayName = "ChhappanBhog"
        model.phone = CartHelper.shared.manageAddress.phone
        model.productName = "App"
        model.details = CartHelper.shared.generateOrderDetails()
        
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/payu.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let params: [String: String] = ["firstname": model.customerName, "email": model.email, "amount": model.amount, "type": "request"]
        
        AF.request(urlwithPercentEscapes!, method: .put, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    print(value)
                    if let data = value as? [String : String] {
                        model.requestHash = data["hash"] ?? ""
                        model.txnId = data["txnid"] ?? ""
                    }
                    
                    if model.requestHash.isEmpty || model.txnId.isEmpty {
                        IJProgressView.shared.hideProgressView()
                        return
                    }
                    
                    DispatchQueue.main.async {
                        PayUHelper.sharedInstance().presentPaymentScreen(from: self, for: model) { (response, error, extra) in
                            if let error = error {
                                alert("ChhappanBhog", message: error.localizedDescription, view: self)
                                IJProgressView.shared.hideProgressView()
                                return
                            }
                            
                            if let response = response as? [String: Any] {
                                // print(response)
                                let status  = response["status"] as? Int ?? 1
                                if status == 0 {
                                    let result = response["result"] as? [String: Any] ?? [:]
                                    let paymentResponseHash = result["hash"] as? String ?? ""
                                    // let localResponseHash = PayUHelper.sharedInstance().getResponseHashForPaymentParams()
                                    
                                    // Fetch hash value from server
                                    let responseParams = ["firstname": model.customerName, "email": model.email, "amount": model.amount, "txnid": model.txnId, "status": "success", "type": "response"]
                                    AF.request(urlwithPercentEscapes!, method: .put, parameters: responseParams, encoding: JSONEncoding.default, headers:header).responseJSON { (response) in
                                        switch response.result {
                                            case .success(let value):
                                                // print(value)
                                                var responseHash = ""
                                                if let data = value as? [String : String] {
                                                    responseHash = data["hash"] ?? ""
                                                }
                                            
                                                if paymentResponseHash == responseHash {
                                                    self.proceedToPlaceOrder(shipping: shipping, paymentMethod: "payu_in", paymentMethodTitle: "PayUmoney")
                                                }
                                                else {
                                                    // Response hash values do not match
                                                    alert("ChhappanBhog", message: "Some error occured.", view: self)
                                                    IJProgressView.shared.hideProgressView()
                                                }
                                            case .failure(let error):
                                                let error : NSError = error as NSError
                                                print(error.localizedDescription)
                                                alert("ChhappanBhog", message: "Some error occured.", view: self)
                                                IJProgressView.shared.hideProgressView()
                                        }
                                    }
                                }
                                else {
                                    // Payment failed
                                    let message = response["message"] as? String ?? "Payment failed"
                                    alert("ChhappanBhog", message: message, view: self)
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                        }
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    alert("ChhappanBhog", message: error.localizedDescription, view: self)
                    IJProgressView.shared.hideProgressView()
                }
        }
    }

    
    
    func proceedToPlaceOrder(shipping: Double, paymentMethod: String, paymentMethodTitle: String) {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) ?? ""
        var lineItems: [[String: Any]] = []
        for cartItem in CartHelper.shared.cartItems {
            let productId = cartItem.item.selectedOption().id > 0 ? cartItem.item.selectedOption().id : cartItem.item.id
            lineItems.append(["product_id": productId, "quantity": cartItem.item.quantity])
        }
        
        let params: [String: Any] = [
            "payment_method": paymentMethod,
            "payment_method_title": paymentMethodTitle,
            "customer_id": userID,
            "set_paid": true,
            "billing" : [
                "first_name": CartHelper.shared.manageAddress.firstName,
                "last_name": CartHelper.shared.manageAddress.lastName,
                "address_1": CartHelper.shared.manageAddress.address,
                "address_2": "",
                "city": CartHelper.shared.manageAddress.city,
                "state": CartHelper.shared.manageAddress.state,
                "postcode": CartHelper.shared.manageAddress.zip,
                "country": CartHelper.shared.manageAddress.country,
                "email": CartHelper.shared.manageAddress.email,
                "phone":CartHelper.shared.manageAddress.phone
            ],
            "shipping" : [
                "first_name": CartHelper.shared.manageAddress.firstName,
                "last_name": CartHelper.shared.manageAddress.lastName,
                "address_1": CartHelper.shared.manageAddress.shipping_address,
                "address_2": "",
                "city": CartHelper.shared.manageAddress.shipping_city,
                "state": CartHelper.shared.manageAddress.shipping_state,
                "postcode": CartHelper.shared.manageAddress.shipping_zip,
                "country": CartHelper.shared.manageAddress.shipping_country,
            ],
            "line_items": lineItems,
            "shipping_lines":[
                [
                    "method_id": "flat_rate",
                    "method_title": "Flat Rate",
                    "total": "\(shipping)"
                ]
            ]
        ]
        
        print(params)
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/postorder.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                IJProgressView.shared.hideProgressView()
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    let data = value as? [String: Any] ?? [:]
                    let orderIdInt = data["order_id"] as? Int ?? 0
                    let orderIdStr = data["order_id"] as? String ?? ""
                    if orderIdInt == 0 && orderIdStr.isEmpty {
                        alert("ChhappanBhog", message: "Some error occured.", view: self)
                        return
                    }
                    
                    let orderId = orderIdInt > 0 ? "\(orderIdInt)" : orderIdStr
                    showAlertMessage(title: "Order Id: \(orderId)", message: "Your order has been placed successfully. You can track your order in your order history.", okButton: "Ok", controller: self) {
                        CartHelper.shared.clearCart()
                        AppDelegate.shared.notifyCartUpdate()
                        self.backButton(self.btnBack)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    let error : NSError = error as NSError
                    alert("ChhappanBhog", message: error.localizedDescription, view: self)
                }
        }
    }
}

//MARK:- TABLEVIEW METHODS
extension CartViewVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartHelper.shared.cartItems.count == 0 { return 0 }
        return CartHelper.shared.cartItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < CartHelper.shared.cartItems.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell
            cell.selectionStyle = .none
            let cartItem = CartHelper.shared.cartItems[indexPath.row]
            
            let image = cartItem.item.image.first ?? ""
            cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: PlaceholderImage.Category)
            
            let name = cartItem.item.title
            cell.productName.text = name
            
            let option = cartItem.item.selectedOption()
            if  option.id > 0 {
                cell.weightLBL.text = option.name
                cell.PriceLBL.text = String(format: "%.0f", option.price).prefixINR
                cell.layoutConstraintWeightWidth.constant = min(80 + (cell.shadowView.frame.size.width - 285), 150)
                cell.layoutConstraintPriceLading.constant = 5
            }
            else {
                cell.weightLBL.text = " "
                cell.PriceLBL.text = String(format: "%.0f", cartItem.item.price).prefixINR
                cell.layoutConstraintWeightWidth.constant = 0
                cell.layoutConstraintPriceLading.constant = 0
            }
            
            cell.layoutIfNeeded()
            cell.quantityLBL.text = "\(cartItem.item.quantity)"
            cell.quantityIncBlock = {
                let cartItem = CartHelper.shared.cartItems[indexPath.row]
                cartItem.item.quantity += 1
                cell.quantityLBL.text = "\(cartItem.item.quantity)"
                CartHelper.shared.save()
                self.listTable.reloadRows(at: [IndexPath(row: CartHelper.shared.cartItems.count, section: 0)], with: .automatic)
                CartHelper.shared.vibratePhone()
            }
            
            cell.quantityDecBlock = {
                let cartItem = CartHelper.shared.cartItems[indexPath.row]
                cartItem.item.quantity -= 1
                if cartItem.item.quantity < 1 { cartItem.item.quantity = 1 }
                cell.quantityLBL.text = "\(cartItem.item.quantity)"
                CartHelper.shared.save()
                self.listTable.reloadRows(at: [IndexPath(row: CartHelper.shared.cartItems.count, section: 0)], with: .automatic)
                CartHelper.shared.vibratePhone()
            }
            
            cell.chooseOptioncBlock = {
                self.currentIndexPath = indexPath
                self.showOptions(indexPath: indexPath)
            }
            
            cell.deleteBlock = {
                let cartItem = CartHelper.shared.cartItems[indexPath.row]
                CartHelper.shared.deleteFromCart(cartItem: cartItem)
                self.reloadTable()
                AppDelegate.shared.notifyCartUpdate()
            }
            
            cell.favBTN.setImage(cartItem.item.isFavourite ? #imageLiteral(resourceName: "red_heart") : #imageLiteral(resourceName: "heart-1"), for: .normal)
            cell.favouriteBlock = {
                let item = CartHelper.shared.cartItems[indexPath.row].item
                let favourite = !item.isFavourite
                cell.favBTN.isUserInteractionEnabled = false
                item.markFavourite(favourite) { (success) in
                    DispatchQueue.main.async {
                        cell.favBTN.isUserInteractionEnabled = true
                        cell.favBTN.setImage(cartItem.item.isFavourite ? #imageLiteral(resourceName: "red_heart") : #imageLiteral(resourceName: "heart-1"), for: .normal)
                    }
                }
            }
            
            return cell
        }
        
        let addressCell = tableView.dequeueReusableCell(withIdentifier: "CartFinalAddressCell") as! CartFinalAddressCell
        addressCell.selectionStyle = .none
        addressCell.lblAddress.text = CartHelper.shared.manageAddress.fullShippingAddress.defaultIfEmpty("-")
        addressCell.btnChangeAddress.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        if CartHelper.shared.manageAddress.fullShippingAddress.isEmpty {
            addressCell.btnChangeAddress.setTitle("Add", for: .normal)
        }
        else {
            addressCell.btnChangeAddress.setTitle("Change", for: .normal)
        }
        
        let price = CartHelper.shared.calculateTotal()
        var shipping = 150.0
        let weightInfo = CartHelper.shared.calculateTotalWeight()
        if weightInfo.weight > 0 {
            shipping = CartHelper.shared.calculateShipping(totalWeight: weightInfo.weight, isInPcs: weightInfo.isInPcs)
        }
        
        addressCell.lblOrderPrice.text = "\(price)".prefixINR.remove00IfInt
        addressCell.lblShippingPrice.text = "\(shipping)".prefixINR.remove00IfInt
        addressCell.lblTotalPrice.text = "\(price + shipping)".prefixINR.remove00IfInt
        return addressCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= CartHelper.shared.cartItems.count { return }
        let cartItem = CartHelper.shared.cartItems[indexPath.row]
        let id = cartItem.item.id
        if id == 0 { return }
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
        vc.GET_PRODUCT_DETAILS(ItemId: id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK:- PickerView
extension CartViewVC: PickerViewDelegate {
    
    func showOptions(indexPath: IndexPath) {
        
        PickerView.shared.delegate = self
        PickerView.shared.type = .Picker
        
        let cartItem = CartHelper.shared.cartItems[indexPath.row]
        let item = cartItem.item
        let data = item.options.map {$0.name}
        PickerView.shared.options = data
        PickerView.shared.tag = 1

        let option = item.selectedOption()
        if let index = PickerView.shared.options.firstIndex(where: {$0 == option.name}) {
            PickerView.shared.picker.selectRow(index, inComponent: 0, animated: false)
        }
        else {
            PickerView.shared.picker.selectRow(0, inComponent: 0, animated: false)
        }
        PickerView.shared.showIn(view: self.view)
    }
    
    func pickerDidSelectOption(_ option: String, picker: PickerView) {
        if let indexPath = currentIndexPath {
            let cartItem = CartHelper.shared.cartItems[indexPath.row]
            let item = cartItem.item
            let result = item.options.filter{$0.name == option}
            if let option = result.first {
                // Remove this item and add it again to perform calculation
                CartHelper.shared.deleteFromCart(cartItem: cartItem)
                item.selectedOptionId = option.id
                CartHelper.shared.addToCart(cartItem: cartItem)
                self.reloadTable()
                AppDelegate.shared.notifyCartUpdate()
            }
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}


class CartFinalAddressCell: UITableViewCell {
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblOrderPrice: UILabel!
    @IBOutlet weak var lblShippingPrice: UILabel!
    @IBOutlet weak var lblTotalPrice: UILabel!
    @IBOutlet weak var btnChangeAddress: UIButton!
}
