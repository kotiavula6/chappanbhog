//
//  CategoryAndItemsVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 06/10/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import STRatingControl

class CategoryAndItemsVC: UIViewController {
    
    @IBOutlet weak var topCollectionHeight: NSLayoutConstraint!
    var message:String = ""
    
    var categoryArr = [Categores]()
    var currentIndexPath: IndexPath!
    
    //MARK:- OUTLETS
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var topCategoryCollection: UICollectionView!
    @IBOutlet weak var itemsCollection: UICollectionView!
    @IBOutlet weak var layoutConstaintItemtTop: NSLayoutConstraint!
    @IBOutlet weak var tFSearch: UITextField!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
    var isFromNavgation = false
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        // Do any additional setup after loading the view.
        tFSearch.returnKeyType = .search
        tFSearch.delegate = self
        topCollectionHeight.constant = 0
        itemsCollection.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        
        //layoutConstaintItemtTop.constant = 0
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setGradientBackground(view: self.gradientView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        updateCartCount()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
        
        // Check if its from tabbar
        if let controllers = self.navigationController?.viewControllers, let controller = controllers.first, controller is UITabBarController, controllers.count == 1 {
            // For tabbar, Hide back button and load favourites
            GET_FAVOURTIE_ITEMS()
            btnBack.isHidden = true
            lblTitle.isHidden = false
            searchView.isHidden = true
            lblNoData.text = "We could not find anything added to your favorites"
            btnHome.isHidden = true
        }
        else {
            lblNoData.text = "No items found"
            lblTitle.isHidden = true
            searchView.isHidden = false
            btnHome.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK:- UI SETUP
    func setAppearance() {
        DispatchQueue.main.async {
            /*self.searchView.cornerRadius = self.searchView.frame.height/2
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            //self.scrollView.layer.cornerRadius = 30
            //self.scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]*/
            self.searchView.layer.cornerRadius = self.searchView.frame.size.height / 2
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.cartLBL.layer.cornerRadius = self.cartLBL.frame.height/2
            self.cartLBL.layer.masksToBounds = true
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.itemsCollection.reloadData()
            if self.categoryArr.count == 0 {
                self.itemsCollection.isHidden = true
                self.lblNoData.isHidden = false
            }
            else {
                self.itemsCollection.isHidden = false
                self.lblNoData.isHidden = true
            }
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
    
    func updateHeight() {
        /*DispatchQueue.main.async {
            self.itemsHeightConstraint.constant = self.itemsCollection.collectionViewLayout.collectionViewContentSize.height
            self.view.layoutIfNeeded()
        }*/
    }
    
    //MARK:- ACTIONS
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

extension CategoryAndItemsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        let text = textField.text ?? ""
        if text.trimmingCharacters(in: .whitespacesAndNewlines).count == 0 { return true }
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "searchRecordVC") as! searchRecordVC
        vc.iscomeFrom = "search"
        vc.searchedText = text
        self.navigationController?.pushViewController(vc, animated: true)
        textField.text = ""
        return true
    }
}

//MARK:- COLLECTIONVIEW METHODS
extension CategoryAndItemsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == topCategoryCollection {
            let cell = topCategoryCollection.dequeueReusableCell(withReuseIdentifier: "topCatCollectionCell", for: indexPath) as! topCatCollectionCell
            return cell
        } else {
            let cell = itemsCollection.dequeueReusableCell(withReuseIdentifier: "itemsCollectionCell", for: indexPath) as! itemsCollectionCell
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
            
            let image = categoryArr[indexPath.row].image.first ?? ""
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
                let width = (self.itemsCollection.frame.size.width/(CartHelper.shared.isRunningOnIpad ? 4 : 2)) - 30
                cell.layoutConstraintWeightWidth.constant = width - 35 - 50 // Padding + Max Label width
                cell.layoutConstraintWeightTrailing.constant = 5
            }
            else {
                cell.weightLBL.text = " "
                cell.priceLBL.text = String(format: "%.0f", data.meta.totalPrice).prefixINR
                cell.layoutConstraintWeightWidth.constant = 0
                cell.layoutConstraintWeightTrailing.constant = 0
            }
            
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
            
            cell.layoutIfNeeded()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCategoryCollection {
            return CGSize(width: topCategoryCollection.frame.height/1.5, height: topCategoryCollection.frame.height)
        } else {
            
            if CartHelper.shared.isRunningOnIpad {
                let width = (self.itemsCollection.frame.size.width/4)-30
                return CGSize(width: width, height: 270)
            }
            
            let width = (self.itemsCollection.frame.size.width/2)-30
            return CGSize(width: width, height: 270)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCategoryCollection { return }
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


//MARK:- API'S
extension CategoryAndItemsVC {
    
    func GET_CATEGORY_ITEMS(ItemId: Int) {
    
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        let getCat = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ITEMS + "/\(userID ?? 0)" + "/\(ItemId)" + "/\(AppDelegate.shared.isLucknow ? 1 : 0)"
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURL(getCat ,success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            print(dict)

            if let result = dict as? [String: Any] {
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
            }
            
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
                self.updateHeight()
            } else {
                let msg = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            let msg = error.localizedDescription
            alert("ChhappanBhog", message: msg, view: self)
        }
    }
    
    func GET_FAVOURTIE_ITEMS() {
    
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        let getCat = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_FAVOURITES + "/\(userID ?? 0)"
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURL(getCat ,success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
          //  print(dict)

            if let result = dict as? [String: Any] {
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
            }
            
            let response = dict["data"] as? NSArray ?? NSArray()
            let success = dict["success"] as? Bool ?? false
            if success {
                self.categoryArr.removeAll()
                for i in 0..<response.count {
                    self.categoryArr.append(Categores(dict: response.object(at: i) as! [String:Any]))
                }
                self.reloadData()
                self.updateHeight()
            } else {
                let msg = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            let msg = error.localizedDescription
            alert("ChhappanBhog", message: msg, view: self)
        }
    }
}


// MARK:- PickerView
extension CategoryAndItemsVC: PickerViewDelegate {
    
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
                itemsCollection.reloadItems(at: [indexPath])
            }
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}


class topCatCollectionCell: UICollectionViewCell {
    @IBOutlet weak var catIMG: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    
}

class itemsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var addToCartBTN: UIButton!
    @IBOutlet weak var weightLBL: UILabel!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var increaseBTN: UIButton!
    @IBOutlet weak var decreaseBTN: UIButton!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet weak var favBTN: UIButton!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    
    @IBOutlet weak var lblShelfLife: UILabel!
    @IBOutlet weak var lblAvailabilityText: UILabel!
    
    @IBOutlet weak var layoutConstraintWeightWidth: NSLayoutConstraint!
    @IBOutlet weak var layoutConstraintWeightTrailing: NSLayoutConstraint!
    
    var cartBlock: SimpleBlock?
    var quantityIncBlock: SimpleBlock?
    var quantityDecBlock: SimpleBlock?
    var chooseOptioncBlock: SimpleBlock?
    var favouriteBlock: SimpleBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nameLBL.numberOfLines = 2
        priceLBL.numberOfLines = 1
        addToCartBTN.addTarget(self, action: #selector(cartAction(_:)), for: UIControl.Event.touchUpInside)
        increaseBTN.addTarget(self, action: #selector(qtyIncAction(_:)), for: UIControl.Event.touchUpInside)
        decreaseBTN.addTarget(self, action: #selector(qtyDecAction(_:)), for: UIControl.Event.touchUpInside)
        weightBTN.addTarget(self, action: #selector(optionAction(_:)), for: UIControl.Event.touchUpInside)
        favBTN.addTarget(self, action: #selector(favouriteAction), for: UIControl.Event.touchUpInside)
        
        lblShelfLife.superview?.layer.cornerRadius = 10
        lblShelfLife.superview?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        lblAvailabilityText.superview?.layer.cornerRadius = 10
        lblAvailabilityText.superview?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    @objc func cartAction(_ sender: UIButton) {
        if let block = cartBlock {
            block()
        }
    }
    
    @objc func qtyIncAction(_ sender: UIButton) {
        if let block = quantityIncBlock {
            block()
        }
    }
    
    @objc func qtyDecAction(_ sender: UIButton) {
        if let block = quantityDecBlock {
            block()
        }
    }
    
    @objc func optionAction(_ sender: UIButton) {
        if let block = chooseOptioncBlock {
            block()
        }
    }
    
    @objc func favouriteAction(_ sender: UIButton) {
        if let block = favouriteBlock {
            block()
        }
    }
}
