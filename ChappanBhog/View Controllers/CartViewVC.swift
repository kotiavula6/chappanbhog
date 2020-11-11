//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import Alamofire

class CartViewVC: UIViewController, UITextFieldDelegate {
    
    // MARK:- OUTLETS
    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var itemsLeftLBL: UILabel!
    @IBOutlet weak var btnPay: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    let lblNote: UILabel = UILabel(frame: CGRect(x: 15, y: 10, width: UIScreen.main.bounds.width - 30, height: 30))
    let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
    
    var currentIndexPath: IndexPath?
    var isFromSideMenu = false
    var saveAction: UIAlertAction?
    
    /*var environment: String = PayPalEnvironmentSandbox {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnect(withEnvironment: newEnvironment)
            }
        }
    }
    var payPalConfig = PayPalConfiguration()*/
    
    // MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // configurePaypal()
        footerView.backgroundColor = .white
        lblNote.backgroundColor = .clear
        footerView.addSubview(lblNote)
        lblNote.text = "Orders placed after 09:15 PM will be delivered tomorrow."
        lblNote.textAlignment = .center
        lblNote.numberOfLines = 0
        
        setAppearance()
        
        IJProgressView.shared.showProgressView()
        CartHelper.shared.syncAddress { (success, message) in
            IJProgressView.shared.hideProgressView()
            self.updateNoteLabel()
            self.reloadTable()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
        updateNoteLabel()
        self.reloadTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
        //PayPalMobile.preconnect(withEnvironment: environment)
        
        /*if AppDelegate.shared.isFromSaveUserSata {
            AppDelegate.shared.isFromSaveUserSata = false
            paymentButton(btnPay)
        }*/
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
            self.lblNote.font = UIFont(name: "BrandonGrotesque-Regular", size: 12.0)
            self.lblNote.textColor = .black
        }
    }
    
    @objc func updateCartCount() {
        let data = CartHelper.shared.cartItems
        if data.count == 0 {
            btnPay.isHidden = true
        }
        else {
            btnPay.isHidden = false
        }
        updateCartCountInText()
    }
    
    func updateCartCountInText() {
        let itemStr = (CartHelper.shared.cartItems.count == 1) ? "item" : "items"
        self.itemsLeftLBL.text = "You have \(CartHelper.shared.cartItems.count) \(itemStr) in your cart"
    }
    
    func updateNoteLabel() {
        DispatchQueue.main.async {
            if self.isAfter9_15PM() && CartHelper.shared.manageAddress.city.lowercased() == "lucknow" && CartHelper.shared.manageAddress.country.lowercased() == "india" {
                self.listTable.tableFooterView = self.footerView
                self.listTable.sectionFooterHeight = 50
            }
            else {
                self.listTable.tableFooterView = nil
                self.listTable.sectionFooterHeight = 0
            }
        }
    }
    
    func isAfter9_15PM() -> Bool {
        CartHelper.shared.df.dateFormat = "HH"
        let time24Hours = Int(CartHelper.shared.df.string(from: Date())) ?? 0
        CartHelper.shared.df.dateFormat = "mm"
        let timeMinutes = Int(CartHelper.shared.df.string(from: Date())) ?? 0
        return time24Hours >= 21 && timeMinutes >= 15
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
    
    @IBAction func homeAction(_ sender: UIButton) {
        AppDelegate.shared.showHomeScreen()
    }
    
    @IBAction func paymentButton(_ sender: UIButton) {
        // pay()
        // return
        
        
        let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
        if loginNeeded { return }
        
        if CartHelper.shared.manageAddress.shipping_zip.isEmpty {
            alert("ChhappanBhog", message: "Please add your address.", view: self)
            return
        }
        
        /*if CartHelper.shared.manageAddress.email.isEmpty || CartHelper.shared.manageAddress.name.isEmpty || CartHelper.shared.manageAddress.phone.isEmpty {
            showAlertWithTitle(title: "ChhappanBhog", message: "We need your name, phone number and email to place the order. Please fill the all details.", okButton: "Ok", cancelButton: "Cancel", okSelectorName: #selector(fillDetails))
            return
        }*/
        
        let email = CartHelper.shared.manageAddress.email
        if email.isEmpty || !validateEmail(email) {
            showTextFieldAlert { (alert) in
                let text = alert.textFields![0].text ?? ""
                self.API_SAVE_USER_EMAIL(params: ["user_email": text]) { (success) in
                    if success {
                        self.paymentButton(self.btnPay)
                    }
                }
            }
            return
        }
        
        let weightInfo = CartHelper.shared.calculateTotalWeight()
        if weightInfo.isInPcs {
            // Make sure shipping is in Lucknow area
            if CartHelper.shared.manageAddress.shipping_country.lowercased() == "india" && CartHelper.shared.manageAddress.shipping_city.lowercased() == "lucknow" {
                askForShippingTiming()
            }
            else {
                // We don't ship item in pcs outside lucknow
                alert("ChhappanBhog", message: "Unfortunately we can't ship your order. Please refine the cart.", view: self)
            }
        }
        else {
            askForShippingTiming()
        }
    }
    
    @objc func addAddress() {
        
        let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
        if loginNeeded { return }
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func fillDetails() {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProfileDetailsVC") as! ProfileDetailsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showTextFieldAlert(saveBlock: @escaping (_ alert: UIAlertController) -> Void) {
        
        let alert = UIAlertController(title:"ChhappanBhog", message: "Email address is mandatory to place the order. Please enter your email.", preferredStyle:UIAlertController.Style.alert)

        alert.addTextField { (textField : UITextField!) in
            textField.placeholder = "Email"
            textField.delegate = self
            textField.keyboardType = .emailAddress
            textField.addTarget(self, action: #selector(self.textFieldDidEditingChange(_:)), for: UIControl.Event.editingChanged)
        }

        let save = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { saveAction -> Void in
            saveBlock(alert)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })

        alert.addAction(save)
        alert.addAction(cancel)
        
        save.isEnabled = false
        self.saveAction = save
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidEditingChange(_ textField: UITextField) {
        let text = textField.text ?? ""
        if !text.isEmpty && validateEmail(text) {
            textField.textColor = .black
            saveAction?.isEnabled = true
        }
        else {
            textField.textColor = .red
            saveAction?.isEnabled = false
        }
    }
    
    func askForShippingTiming() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ShippingWebVC") as! ShippingWebVC
        vc.url = "https://www.chhappanbhog.com/shipping/"
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.acceptBlock = {
            // Remove this vc from the stack
            // And call proceed to payment
            let model = self.getPaymentModel()
            IJProgressView.shared.showProgressView()
            self.proceedToPlaceOrder(shipping: model.shipping, paymentMethod: "payu_in", paymentMethodTitle: "PayUmoney") { (success, orderId) in
                if !success {
                    IJProgressView.shared.hideProgressView()
                    alert("ChhappanBhog", message: "Unfortunately, your payment didn't go through. Please try again.", view: self)
                    return
                }
                
                self.proceedToPaymentForOrder(orderId: orderId, paymentModel: model)
            }
        }
    }
    
    func getPaymentModel() -> PayUHelperModel {
        let price = CartHelper.shared.calculateTotal()
        var shipping = 150.0
        let weightInfo = CartHelper.shared.calculateTotalWeight()
        if weightInfo.weight > 0 {
            shipping = CartHelper.shared.calculateShipping(totalWeight: weightInfo.weight, isInPcs: weightInfo.isInPcs)
        }
        
        let amount = price + shipping
        
        // Overwrite amount for testing purpose
        // amount = 20
        
        let model: PayUHelperModel = PayUHelperModel()
        model.shipping = String(format: "%.2f", shipping)
        model.amount = String(format: "%.2f", amount)
        model.customerName = CartHelper.shared.manageAddress.firstName
        model.email = CartHelper.shared.manageAddress.email
        model.merchantDisplayName = "ChhappanBhog"
        model.phone = CartHelper.shared.manageAddress.phone
        model.productName = "App"
        model.details = CartHelper.shared.generateOrderDetails()
        return model
    }
    
    func proceedToPaymentForOrder(orderId: String, paymentModel: PayUHelperModel) {
        
        let model = paymentModel

        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/payu.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let params: [String: String] = ["firstname": model.customerName, "email": model.email, "amount": model.amount, "type": "request"]
        
        AF.request(urlwithPercentEscapes!, method: .put, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                   // print(value)
                    if let data = value as? [String : String] {
                        model.requestHash = data["hash"] ?? ""
                        model.txnId = data["txnid"] ?? ""
                    }
                    
                    if model.requestHash.isEmpty || model.txnId.isEmpty {
                        IJProgressView.shared.hideProgressView()
                        alert("ChhappanBhog", message: "Unfortunately, your payment didn't go through. Please try again.", view: self)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        if var controllers = self.navigationController?.viewControllers {
                            for index in 0..<controllers.count {
                                let controller = controllers[index]
                                if controller is ShippingWebVC {
                                    controllers.remove(at: index)
                                    self.navigationController?.viewControllers = controllers
                                    break;
                                }
                            }
                        }
                        
                        IJProgressView.shared.hideProgressView()
                        PayUHelper.sharedInstance().presentPaymentScreen(from: self, for: model) { (response, error, extra) in
                            if let error = error {
                                alert("ChhappanBhog", message: error.localizedDescription, view: self)
                                return
                            }
                            
                            IJProgressView.shared.showProgressView()
                            if let response = response as? [String: Any] {
                                // print(response)
                                let status  = response["status"] as? Int ?? 1
                                if status == 0 {
                                    let result = response["result"] as? [String: Any] ?? [:]
                                    let paymentResponseHash = result["hash"] as? String ?? "paymentResponseHash"
                                    
                                    var paymentId = result["paymentId"] as? String ?? ""
                                    if paymentId.isEmpty {
                                        let id = result["paymentId"] as? Int ?? 0
                                        paymentId = "\(id)"
                                    }
                                    
                                    // let localResponseHash = PayUHelper.sharedInstance().getResponseHashForPaymentParams()
                                    
                                    // Fetch hash value from server
                                    let responseParams = ["firstname": model.customerName, "email": model.email, "amount": model.amount, "txnid": model.txnId, "status": "success", "type": "response"]
                                    AF.request(urlwithPercentEscapes!, method: .put, parameters: responseParams, encoding: JSONEncoding.default, headers:header).responseJSON { (response) in
                                        switch response.result {
                                            case .success(let value):
                                                // print(value)
                                                var responseHash = "hash"
                                                if let data = value as? [String : String] {
                                                    responseHash = data["hash"] ?? "hash"
                                                }
                                            
                                                if paymentResponseHash == responseHash {
                                                    self.proceedToPlaceOrder2(orderId: orderId, transactionId: paymentId)
                                                }
                                                else {
                                                    // Response hash values do not match
                                                    alert("ChhappanBhog", message: "Unfortunately, your order didn't go through. Please try again or contact support if payment is debited.", view: self)
                                                    IJProgressView.shared.hideProgressView()
                                                }
                                            case .failure(let error):
                                                let error : NSError = error as NSError
                                                alert("ChhappanBhog", message: error.localizedDescription, view: self)
                                                IJProgressView.shared.hideProgressView()
                                        }
                                    }
                                }
                                else {
                                    // Payment failed
                                    let message = response["message"] as? String ?? "Unfortunately, your payment didn't go through. Please try again with another card."
                                    alert("ChhappanBhog", message: message, view: self)
                                    IJProgressView.shared.hideProgressView()
                                }
                            }
                            else {
                                // Payment failed
                                let message = "Unfortunately, your order didn't go through. Please try again or contact support if payment is debited."
                                alert("ChhappanBhog", message: message, view: self)
                                IJProgressView.shared.hideProgressView()
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

    
    
    func proceedToPlaceOrder(shipping: String, paymentMethod: String, paymentMethodTitle: String, completion: @escaping (_ success: Bool, _ orderId: String) -> Void) {
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
            "set_paid": false,
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
                    "total": shipping
                ]
            ]
        ]
        
        // print(params)
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/postorder.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                IJProgressView.shared.hideProgressView()
                switch response.result {
                case .success(let value):
                    let data = value as? [String: Any] ?? [:]
                    let orderIdInt = data["order_id"] as? Int ?? 0
                    let orderIdStr = data["order_id"] as? String ?? ""
                    if orderIdInt == 0 && orderIdStr.isEmpty {
                        alert("ChhappanBhog", message: "Unfortunately, your order didn't go through. Please try again or contact support if payment is debited.", view: self)
                        completion(false, "")
                        return
                    }
                    
                    let orderId = orderIdInt > 0 ? "\(orderIdInt)" : orderIdStr
                    completion(true, orderId)
                    
                    
                    
                    /*showAlertMessage(title: "Order Id: \(orderId)", message: "Your order has been placed successfully. You can track your order in your order history.", okButton: "Ok", controller: self) {
                        self.backButton(self.btnBack)
                    }
                    
                    CartHelper.shared.clearCart()
                    AppDelegate.shared.notifyCartUpdate()*/
                    
                case .failure(let error):
                    alert("ChhappanBhog", message: error.localizedDescription, view: self)
                    completion(false, "")
                }
        }
    }
    
    func proceedToPlaceOrder2(orderId: String, transactionId: String) {
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) ?? ""
        let params: [String: Any] = ["user_id": userID,
                                     "order_id": orderId,
                                     "transaction_id": transactionId,
                                     "set_paid": 1]
        
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "http://3.7.199.43/restapi/example/postorder2.php"
        let urlwithPercentEscapes = strURL.addingPercentEncoding( withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
        AF.request(urlwithPercentEscapes!, method: .post, parameters: params, encoding: JSONEncoding.default, headers:header)
            .responseJSON { (response) in
                IJProgressView.shared.hideProgressView()
                switch response.result {
                case .success(let value):
                    // print(value)
                    let data = value as? [String: Any] ?? [:]
                    let result = data["data"] as? [String: Any] ?? [:]
                    let status = result["status"] as? String ?? ""
                    if status != "processing" {
                        alert("ChhappanBhog", message: "Unfortunately, your order didn't go through. Please try again or contact support if payment is debited.", view: self)
                        return
                    }
                    
                    showAlertMessage(title: "Order Id: \(orderId)", message: "Your order has been placed successfully. You can track your order in your order history.", okButton: "Ok", controller: self) {
                        self.backButton(self.btnBack)
                    }
                    
                    CartHelper.shared.clearCart()
                    DispatchQueue.main.async {
                        AppDelegate.shared.notifyCartUpdate()
                    }
                    
                case .failure(let error):
                    alert("ChhappanBhog", message: error.localizedDescription, view: self)
                }
        }
    }
}

//MARK:- TABLEVIEW METHODS
extension CartViewVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if CartHelper.shared.cartItems.count == 0 { return 0}
        return CartHelper.shared.cartItems.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < CartHelper.shared.cartItems.count {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell
            cell.selectionStyle = .none
            let cartItem = CartHelper.shared.cartItems[indexPath.row]
            cartItem.item.performAvailabilityCheck()
            
            let image = cartItem.item.image.first ?? ""
            cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: PlaceholderImage.Category)
            
            if cartItem.item.meta.sub_title.isEmpty {
                cell.productName.text = cartItem.item.title
            }
            else {
                cell.productName.attributedText = cartItem.item.fullTitleAttributedText(titleFont: cell.productName.font)
            }
            
            cell.PriceLBL.text = String(format: "%.0f", cartItem.item.totalPriceWithoutQuantity).prefixINR
            
            let option = cartItem.item.selectedOption()
            if  option.id > 0 {
                cell.weightLBL.text = option.name
                cell.layoutConstraintWeightWidth.constant = min(80 + (cell.shadowView.frame.size.width - 285), 150)
                cell.layoutConstraintPriceLading.constant = 5
            }
            else {
                cell.weightLBL.text = " "
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
                
                let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
                if loginNeeded { return }
                
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
        
        if CartHelper.shared.manageAddress.shipping_zip.isEmpty {
            shipping = 50.0
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


extension CartViewVC {
    func API_SAVE_USER_EMAIL(params: [String: Any], completion: @escaping (_ success: Bool) -> Void) {
        print(params)
        IJProgressView.shared.showProgressView()
        let saveUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_SAVE_USER
        AFWrapperClass.requestPOSTURLWithHeader(saveUrl, params: params, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            let message = dict["message"] as? String ?? ""
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                alert("ChhappanBhog", message: message, view: self)
                completion(false)
            } else {
                let data = dict["data"] as? [String:Any] ?? [:]
                let email = data["email"] as? String ?? ""
                UserDefaults.standard.set(email, forKey: Constants.EmailID)
                CartHelper.shared.manageAddress.email = email
                completion(true)
            }
            
        }) { (error) in
            alert("ChhappanBhog", message: error.localizedDescription, view: self)
            completion(false)
        }
    }
}

// MARK:- Paypal
/*extension CartViewVC: PayPalPaymentDelegate {

    func configurePaypal() {
        payPalConfig.acceptCreditCards = false
        payPalConfig.merchantName = "ChhappanBhog" //Give your company name here.
        payPalConfig.merchantPrivacyPolicyURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/privacy-full")
        payPalConfig.merchantUserAgreementURL = URL(string: "https://www.paypal.com/webapps/mpp/ua/useragreement-full")
        //This is the language in which your paypal sdk will be shown to users.
        payPalConfig.languageOrLocale = Locale.preferredLanguages[0]
        //Here you can set the shipping address. You can choose either the address associated with PayPal account or different address. We’ll use .both here.
        payPalConfig.payPalShippingAddressOption = .both;
    }

    func pay() {
        //These are the items choosen by user, for example
        let item1 = PayPalItem(name: "Old jeans with holes", withQuantity: 2, withPrice: NSDecimalNumber(string: "84.99"), withCurrency: "USD", withSku: "Hip-0037")
        let item2 = PayPalItem(name: "Free rainbow patch", withQuantity: 1, withPrice: NSDecimalNumber(string: "0.00"), withCurrency: "USD", withSku: "Hip-00066")
        let item3 = PayPalItem(name: "Long-sleeve plaid shirt (mustache not included)", withQuantity: 1, withPrice: NSDecimalNumber(string: "37.99"), withCurrency: "USD", withSku: "Hip-00291")
        let items = [item1, item2, item3]
        let subtotal = PayPalItem.totalPrice(forItems: items) //This is the total price of all the items
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "5.99")
        let tax = NSDecimalNumber(string: "2.50")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        let total = subtotal.adding(shipping).adding(tax) //This is the total price including shipping and tax
        let payment = PayPalPayment(amount: total, currencyCode: "USD", shortDescription: "ChhappanBhog", intent: .sale)
        payment.items = items
        payment.paymentDetails = paymentDetails

        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            present(paymentViewController!, animated: true, completion: nil)
        }
        else {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn’t be processable, and you’d want
            // to handle that here.
            print("Payment not processalbe: (payment)")
        }
    }

    // MARK:- PayPalPaymentDelegate
    func payPalPaymentDidCancel(_ paymentViewController: PayPalPaymentViewController) {
        print("PayPal Payment Cancelled")
        paymentViewController.dismiss(animated: true, completion: nil)
    }

    func payPalPaymentViewController(_ paymentViewController: PayPalPaymentViewController, didComplete completedPayment: PayPalPayment) {
        print("PayPal Payment Success !")
        paymentViewController.dismiss(animated: true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:nn(completedPayment.confirmation)nnSend this to your server for confirmation and fulfillment.")
        })
    }
}*/
