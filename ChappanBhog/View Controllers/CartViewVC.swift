//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class CartViewVC: UIViewController {
    
    // MARK:- OUTLETS
    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var itemsLeftLBL: UILabel!
    
    var currentIndexPath: IndexPath?
    var isFromProduct = false
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        
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
            cartLBL.text = "0"
            cartLBL.superview?.isHidden = true
        }
        else {
            cartLBL.text = "\(data.count)"
            cartLBL.superview?.isHidden = false
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
    @IBAction func backButton(_ sender: Any) {
        if isFromProduct {
            self.navigationController?.popViewController(animated: true)
        } else {
            AppDelegate.shared.showHomeScreen()
        }
    }
    
    @IBAction func paymentButton(_ sender: Any) {
        
    }
    
    @objc func addAddress() {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
        self.navigationController?.pushViewController(vc, animated: true)
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
            }
            else {
                cell.weightLBL.text = " "
                cell.PriceLBL.text = "0".prefixINR
            }
            
            cell.quantityLBL.text = "\(cartItem.item.quantity)"
            cell.quantityIncBlock = {
                let cartItem = CartHelper.shared.cartItems[indexPath.row]
                cartItem.item.quantity += 1
                cell.quantityLBL.text = "\(cartItem.item.quantity)"
                CartHelper.shared.save()
            }
            
            cell.quantityDecBlock = {
                let cartItem = CartHelper.shared.cartItems[indexPath.row]
                cartItem.item.quantity -= 1
                if cartItem.item.quantity < 1 { cartItem.item.quantity = 1 }
                cell.quantityLBL.text = "\(cartItem.item.quantity)"
                CartHelper.shared.save()
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
        let shipping = CartHelper.shared.calculateShipping(totalWeight: 2) // 2kg
        
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
