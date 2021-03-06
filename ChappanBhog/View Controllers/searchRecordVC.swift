//
//  searchRecordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 13/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import STRatingControl

class searchRecordVC: UIViewController {
    
    var categoryArr = [Categores]()
    var iscomeFrom = ""
    var searchedText = ""
    
    // MARK:- OUTLETS
    @IBOutlet weak var totalRecordsLBL: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var recordsCollection: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var cartLBL: UILabel!
    
    var currentIndexPath: IndexPath?
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTF.delegate = self
        searchTF.returnKeyType = .search
        
        setAppearance()
        if searchedText != "" {
            searchTF.text = searchedText
            API_GET_SEARCH_DATA()
        }
        else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.searchTF.becomeFirstResponder()
            }
        }
        recordsCollection.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
        reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    // MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.searchView.cornerRadius = self.searchView.frame.height/2
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.masksToBounds = true
            self.cartLBL.cornerRadius = self.cartLBL.frame.height/2
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.recordsCollection.reloadData()
        }
    }
    
    func updateCounts() {
        DispatchQueue.main.async {
            self.totalRecordsLBL.text = "\(self.categoryArr.count) \(self.categoryArr.count == 1 ? "RECORD" : "RECORDS") FOUND"
        }
    }
    
    @objc func updateCartCount() {
        let data = CartHelper.shared.cartItems
        if data.count == 0 {
            cartLBL.text = "0"
            cartLBL.isHidden = true
        }
        else {
            cartLBL.text = "\(data.count)"
            cartLBL.isHidden = false
        }
    }
    
    // MARK:- ACTIONS
    @IBAction func searchAction(_ sender: UITextField) {
        /*let TF = searchTF.text ?? ""
        if TF.count > 3 {
            API_GET_SEARCH_DATA()
            recordsCollection.reloadData()
        }*/
    }
    
    @IBAction func ClearButtonClicked(_ sender: UIButton) {
        categoryArr.removeAll()
        recordsCollection.reloadData()
        updateCounts()
    }
    
    @IBAction func clearBTN(_ sender: UIButton) {
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        AppDelegate.shared.showHomeScreen()
    }
}

extension searchRecordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let text = textField.text ?? ""
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 { return true }
        API_GET_SEARCH_DATA()
        return true
    }
}

// MARK:-  COLLECTIONVIEW METHODS
extension searchRecordVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recordsCollection.dequeueReusableCell(withReuseIdentifier: "itemsCollectionCell", for: indexPath) as! itemsCollectionCell
        let data = categoryArr[indexPath.row]
        data.performAvailabilityCheck()
        
        // Add to Cart button
        cell.addToCartBTN.appEnabled(data.canAddToCart)
        
        // Shelf life
        let shelfLife = data.meta.shelf_life
        if shelfLife.isEmpty {
            cell.lblShelfLife.superview?.isHidden = true
        }
        else {
            cell.lblShelfLife.superview?.isHidden = false
            cell.lblShelfLife.text = "Shelf Life: " + shelfLife
        }
        
        // Availability text
        if data.isAvailable {
            cell.lblAvailabilityText.superview?.isHidden = true
        }
        else {
            cell.lblAvailabilityText.text = data.meta.availabilitytext
            cell.lblAvailabilityText.superview?.isHidden = false
        }

        let image = data.image.first ?? ""
        cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: PlaceholderImage.Category)
        
        if data.meta.sub_title.isEmpty {
            cell.nameLBL.text = data.title
        }
        else {
            cell.nameLBL.attributedText = data.fullTitleAttributedText(titleFont: cell.nameLBL.font)
        }
        
        cell.ratingView.rating = data.ratings
        cell.quantityLBL.text = "\(data.quantity)"
        cell.priceLBL.text = String(format: "%.0f", data.totalPriceWithoutQuantity).prefixINR
        
        let option = data.selectedOption()
        if  option.id > 0 {
            cell.weightLBL.text = option.name
            let width = (self.recordsCollection.frame.size.width/(CartHelper.shared.isRunningOnIpad ? 4 : 2)) - 30
            cell.layoutConstraintWeightWidth.constant = width - 35 - 50 // Padding + Max Label width
            cell.layoutConstraintWeightTrailing.constant = 5
        }
        else {
            cell.weightLBL.text = " "
            cell.layoutConstraintWeightWidth.constant = 0
            cell.layoutConstraintWeightTrailing.constant = 0
        }
        cell.layoutIfNeeded()
        
        cell.favBTN.tintColor = data.isFavourite ? .red : .lightGray
        cell.favouriteBlock = {
            
            let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
            if loginNeeded { return }
            
            let item = self.categoryArr[indexPath.row]
            let favourite = !item.isFavourite
            cell.favBTN.isUserInteractionEnabled = false
            item.markFavourite(favourite) { (success) in
                DispatchQueue.main.async {
                    cell.favBTN.isUserInteractionEnabled = true
                    cell.favBTN.tintColor = item.isFavourite ? .red : .lightGray
                }
            }
        }

        cell.cartBlock = {
            let item = self.categoryArr[indexPath.row]
            let cartItem = CartItem(item: item)
            CartHelper.shared.addToCart(cartItem: cartItem)
            AppDelegate.shared.notifyCartUpdate()
            CartHelper.shared.vibratePhone()
        }
        
        cell.quantityIncBlock = {
            let item = self.categoryArr[indexPath.row]
            item.quantity += 1
            cell.quantityLBL.text = "\(item.quantity)"
            CartHelper.shared.vibratePhone()
        }
        
        cell.quantityDecBlock = {
            let item = self.categoryArr[indexPath.row]
            item.quantity -= 1
            if item.quantity < 1 { item.quantity = 1}
            cell.quantityLBL.text = "\(item.quantity)"
            CartHelper.shared.vibratePhone()
        }
        
        cell.chooseOptioncBlock = {
            let item = self.categoryArr[indexPath.row]
            if item.options.count == 0 {
                return
            }
            self.currentIndexPath = indexPath
            self.showOptions(indexPath: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        if CartHelper.shared.isRunningOnIpad {
            let width = (self.recordsCollection.frame.size.width/4)-30
            return CGSize(width: width, height: 270)
        }
        
        let width = (self.recordsCollection.frame.size.width/2)-30
        /*var height: CGFloat = 325
        if UIScreen.main.bounds.width < 375 {
            height = 375
        }*/
        return CGSize(width: width, height: 270)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < categoryArr.count {
            let data = categoryArr[indexPath.row]
            let itemId = data.id
            if itemId == 0 { return }
            
            let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
            vc.item = data
            //vc.GET_PRODUCT_DETAILS(ItemId: itemId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension searchRecordVC {
    
    func API_GET_SEARCH_DATA() {
        
        let Url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_SEARCH
        let userId = UserDefaults.standard.value(forKey: Constants.UserId)
        let searchData = searchTF.text ?? ""
        let params: [String:Any] = ["user_id":userId ?? 0, "keyword": searchData, "lucknow": AppDelegate.shared.isLucknow ? 1 : 0]
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestPOSTURLWithHeader(Url, params: params, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            let response = dict["data"] as? [[String: Any]] ?? []
            let success = dict["success"] as? Bool ?? false
            if success {
                self.categoryArr.removeAll()
                for dict in response {
                    // Availability Check
                    let item = Categores(dict: dict)
                    item.performAvailabilityCheck()
                    if item.canShow {
                        self.categoryArr.append(item)
                    }
                }
                self.reloadData()
                self.updateCounts()
                
            } else {
                let msg = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            let msg = error.localizedDescription
            alert("ChhappanBhog", message: msg, view: self)
            IJProgressView.shared.hideProgressView()
        }
    }
}


// MARK:- PickerView
extension searchRecordVC: PickerViewDelegate {
    
    func showOptions(indexPath: IndexPath) {
        
        PickerView.shared.delegate = self
        PickerView.shared.type = .Picker
        
        let item = self.categoryArr[indexPath.row]
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
            let item = categoryArr[indexPath.row]
            let result = item.options.filter{$0.name == option}
            if let option = result.first {
                item.selectedOptionId = option.id
                recordsCollection.reloadItems(at: [indexPath])
            }
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}
