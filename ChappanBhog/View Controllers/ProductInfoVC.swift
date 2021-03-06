//
//  ProductInfoVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import SDWebImage
import STRatingControl

class ProductInfoVC: UIViewController {
    
    @IBOutlet weak var favroteBTN: UIButton!
    @IBOutlet weak var deliveryTimeLBL: UILabel!
    @IBOutlet weak var totalReviewsLBL: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var lblShelfLife: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var productBacView: UIView!
    
    // MARK:- OUTLETS
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var weightLBL: UILabel!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var viewWeightContainer: UIView!
    @IBOutlet weak var layoutConstraintWeightTraling: NSLayoutConstraint!
    
    var item: Categores = Categores()
    
    // MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddToCart.setTitle("ADD TO CART", for: .normal)
        setAppearance()
        fillData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
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
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.scrollView.layer.cornerRadius = 30
            self.scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.cartLBL.layer.masksToBounds = true
            self.cartLBL.layer.cornerRadius = self.cartLBL.layer.frame.height/2
        }
    }
    
    func fillData() {
        
        DispatchQueue.main.async {
            self.ratingView.rating = self.item.ratings
            if self.item.meta.sub_title.isEmpty {
                self.productNameLBL.text = self.item.title
            }
            else {
                self.productNameLBL.attributedText = self.item.fullTitleAttributedText(titleFont: self.productNameLBL.font)
            }
            
            // self.productPrice.text = String(format: "%.0f", self.item.totalPriceWithoutQuantity).prefixINR
            let option = self.item.selectedOption()
            if  option.id > 0 {
                self.weightLBL.text = option.name
                self.viewWeightContainer.isHidden = false
                self.layoutConstraintWeightTraling.constant = 15
            }
            else {
                self.weightLBL.text = " "
                self.viewWeightContainer.isHidden = true
                self.layoutConstraintWeightTraling.constant = -30
            }
            
            self.favroteBTN.tintColor = self.item.isFavourite ? .red : .lightGray
            self.quantityLBL.text = "\(self.item.quantity)"
            self.totalReviewsLBL.text = "\(self.item.reviews) \(self.item.reviews == 1 ? "review" : "reviews")"
            
            // Add to Cart button
            self.btnAddToCart.appEnabled(self.item.canAddToCart)
            
            // Shelf life
            self.lblShelfLife.superview?.layer.cornerRadius = 10
            self.lblShelfLife.superview?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            let shelfLife = self.item.meta.shelf_life
            if shelfLife.isEmpty {
                self.lblShelfLife.superview?.isHidden = true
            }
            else {
                self.lblShelfLife.superview?.isHidden = false
                self.lblShelfLife.text = "Shelf Life: " + shelfLife
            }
            
            // Availability text
            if self.item.isAvailable {
                self.descriptionLBL.text = self.item.desc
                self.descriptionLBL.textColor = .black
                self.descriptionLBL.textAlignment = .left
                self.btnAddToCart.isHidden = false
            }
            else {
                self.descriptionLBL.text = self.item.meta.availabilitytext
                self.descriptionLBL.textColor = self.lblShelfLife.superview!.backgroundColor
                self.descriptionLBL.textAlignment = .center
                self.btnAddToCart.isHidden = true
            }
            
            self.updatePrice()
            //self.updatePayButtonTitle()
            self.view.layoutIfNeeded()
        }
    }
    
    func reloadImages() {
        DispatchQueue.main.async {
            self.productImageCollection.reloadData()
        }
    }
    
    /*func updatePayButtonTitle() {
        let option = self.item.selectedOption()
        if  option.id > 0 {
            let price = option.price * Double(self.item.quantity)
            let priceText = "PAY " + String(format: "%.0f", price).prefixINR
            payBTN.setTitle(priceText, for: .normal)
        }
        else {
            let price = self.item.price * Double(self.item.quantity)
            let priceText = "PAY " + String(format: "%.0f", price).prefixINR
            payBTN.setTitle(priceText, for: .normal)
        }
    }*/
    
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
    
    func updatePrice() {
        self.productPrice.text = String(format: "%.0f", self.item.totalPrice).prefixINR
        
        /*let option = self.item.selectedOption()
        if  option.id > 0 {
            let price = Double(self.item.quantity) * option.price
            self.productPrice.text = String(format: "%.0f", price).prefixINR
        }
        else {
            let price = Double(self.item.quantity) * self.item.price
            self.productPrice.text = String(format: "%.0f", price).prefixINR
        }*/
    }
    
    //MARK:- ACTIONS
    @IBAction func weightButtonAction(_ sender: UIButton) {
        if self.item.options.count == 0 {
            return
        }
        showOptions()
    }
    
    @IBAction func increseBTN(_ sender: UIButton) {
        /*if self.item.quantity >= self.item.available_quantity {
            alert("ChhappanBhog", message: "Maximum quantities exceeded.", view: self)
            return
        }*/
        
        self.item.quantity += 1
        self.quantityLBL.text = "\(self.item.quantity)"
        updatePrice()
        CartHelper.shared.vibratePhone()
        
        //self.updatePayButtonTitle()
    }
    
    @IBAction func decreaseBTN(_ sender: UIButton) {
        self.item.quantity -= 1
        if self.item.quantity <= 0 {
            self.item.quantity = 1
        }
        self.quantityLBL.text = "\(self.item.quantity)"
        updatePrice()
        CartHelper.shared.vibratePhone()
        
        //self.updatePayButtonTitle()
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToCartButtonClicked(_ sender: UIButton) {
    
        //let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        //self.navigationController?.pushViewController(vc, animated: true)
        let cartItem = CartItem(item: self.item)
        CartHelper.shared.addToCart(cartItem: cartItem)
        AppDelegate.shared.notifyCartUpdate()
        CartHelper.shared.vibratePhone()
        
        /*let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    @IBAction func favroteButtonClicked(_ sender: UIButton) {
        
        let loginNeeded = AppDelegate.shared.checkNeedLoginAndShowAlertInController(self)
        if loginNeeded { return }
        
        let favourite = !item.isFavourite
        sender.isUserInteractionEnabled = false
        item.markFavourite(favourite) { (success) in
            DispatchQueue.main.async {
                sender.isUserInteractionEnabled = true
                sender.tintColor = self.item.isFavourite ? .red : .lightGray
            }
        }
    }
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        AppDelegate.shared.showHomeScreen()
    }
}

//MARK:- COLLECTION VIEW METHODS
extension ProductInfoVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if item.image.count == 0 { return 1}
        return item.image.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productImageCollection.dequeueReusableCell(withReuseIdentifier: "productDetailImageCollection", for: indexPath) as! productDetailImageCollection
        var image = ""
        if indexPath.row < item.image.count {
            image = item.image[indexPath.row]
        }
        cell.productIMG.sd_setImage(with: URL(string: image), placeholderImage: PlaceholderImage.Category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productImageCollection.frame.width, height: productImageCollection.frame.height)
    }
}


//MARK:-  API Get product Details
extension ProductInfoVC {
    
    func GET_PRODUCT_DETAILS(ItemId:Int){
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        IJProgressView.shared.showProgressView()
        
        let productDetailAPI = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ITEM_DETAILS + "/\(userID ?? 0)" + "/\(ItemId)"
        print(productDetailAPI)
        AFWrapperClass.requestGETURL(productDetailAPI ,success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let response = dict["data"] as? NSDictionary ?? NSDictionary()
            let isTokenExpired = AFWrapperClass.handle401Error(dict: response as! [String: Any], self)
            if isTokenExpired {
                return
            }
            
            let success = dict["success"] as? Bool ?? false
            if success {
                if let data = dict["data"] as? [String: Any] {
                    let oldQuantity = self.item.quantity
                    self.item.setDict(data)
                    if oldQuantity > 1 {
                        self.item.quantity = oldQuantity
                    }
                    // Availability Check
                    self.item.performAvailabilityCheck()
                    self.fillData()
                    self.reloadImages()
                }
            } else {
                let msg = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: msg, view: self)
            }
            
        }) { (error) in
            let msg = error.localizedDescription
            alert("ChhappanBhog", message: msg, view: self)
        }
    }
}

// MARK:- PickerView
extension ProductInfoVC: PickerViewDelegate {
    
    func showOptions() {
        
        PickerView.shared.delegate = self
        PickerView.shared.type = .Picker
        
        let data = self.item.options.map {$0.name}
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
        let result = self.item.options.filter{$0.name == option}
        if let option = result.first {
            item.selectedOptionId = option.id
            self.fillData()
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}

//collectionview cell top
class productDetailImageCollection: UICollectionViewCell {
    @IBOutlet weak var productIMG: UIImageView!
}


