//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CartViewVC: UIViewController {
    
    //MARK:- OUTLETS
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
        
        let itemStr = (CartHelper.shared.cartItems.count == 1) ? "item" : "items"
        self.itemsLeftLBL.text = "You have \(CartHelper.shared.cartItems.count) \(itemStr) in your cart"
        if CartHelper.shared.cartItems.count < 1 {
            self.cartLBL.text = ""
        } else {
            self.cartLBL.text = "\(CartHelper.shared.cartItems.count)"
        }
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
    @IBAction func backButton(_ sender: Any) {
        
        if isFromProduct {
          self.navigationController?.popViewController(animated: true)
        } else {
            AppDelegate.shared.showHomeScreen()
        }
        
       //
    }
}

//MARK:- TABLEVIEW METHODS
extension CartViewVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CartHelper.shared.cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell
        let cartItem = CartHelper.shared.cartItems[indexPath.row]
        
        if let image = cartItem.item.image.first {
            cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: "placeholder.png"))
        }
        
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
        
        cell.quantityIncBlock = {
            let cartItem = CartHelper.shared.cartItems[indexPath.row]
            cartItem.item.quantity += 1
            cell.quantityLBL.text = "\(cartItem.item.quantity)"
        }
        
        cell.quantityDecBlock = {
            let cartItem = CartHelper.shared.cartItems[indexPath.row]
            cartItem.item.quantity -= 1
            if cartItem.item.quantity < 1 { cartItem.item.quantity = 1}
            cell.quantityLBL.text = "\(cartItem.item.quantity)"
        }
        
        cell.chooseOptioncBlock = {
            self.currentIndexPath = indexPath
            self.showOptions(indexPath: indexPath)
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cartItem = CartHelper.shared.cartItems[indexPath.row]
        let id = cartItem.item.id ?? 0
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
                item.selectedOptionId = option.id
                listTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}
