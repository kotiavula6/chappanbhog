//
//  CategoryAndItemsVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 06/10/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CategoryAndItemsVC: UIViewController {
    
    @IBOutlet weak var topCollectionHeight: NSLayoutConstraint!
    var message:String = ""
    
    var categoryArr = [Categores]()
    var optionArr = [Options]()
    var currentIndexPath: IndexPath!
    
    //MARK:- OUTLETS
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var topCategoryCollection: UICollectionView!
    @IBOutlet weak var itemsCollection: UICollectionView!
    @IBOutlet weak var itemsHeightConstraint: NSLayoutConstraint!
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        // Do any additional setup after loading the view.
        topCollectionHeight.constant = 0
    }
    
    override func viewWillLayoutSubviews() {
        setGradientBackground(view: self.gradientView)
    }
    
    //MARK:- UI SETUP
    func setAppearance() {
        DispatchQueue.main.async {
            self.searchView.cornerRadius = self.searchView.frame.height/2
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.scrollView.layer.cornerRadius = 30
            self.scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            if let imgAr = categoryArr[indexPath.row].image {
                if imgAr.count > 0 {
                    cell.productIMG.sd_setImage(with: URL(string: imgAr[0] ), placeholderImage: UIImage(named: "placeholder.png"))
                }
            }
            
            cell.nameLBL.text = data.title
            let option = data.selectedOption()
            if  option.id > 0 {
                cell.weightLBL.text = option.name
                cell.priceLBL.text = String(format: "%.0f", option.price).prefixINR
            }
            else {
                cell.weightLBL.text = " "
                cell.priceLBL.text = "0".prefixINR
            }
            
            DispatchQueue.main.async {
                self.itemsHeightConstraint.constant = self.itemsCollection.contentSize.height
            }
            
            cell.cartBlock = {
                let item = self.categoryArr[indexPath.row]
                let cartItem = CartItem(item: item)
                CartHelper.shared.addToCart(cartItem: cartItem)
            }
            
            cell.quantityIncBlock = {
                let item = self.categoryArr[indexPath.row]
                item.quantity += 1
                cell.quantityLBL.text = "\(item.quantity)"
            }
            
            cell.quantityDecBlock = {
                let item = self.categoryArr[indexPath.row]
                item.quantity -= 1
                if item.quantity < 1 { item.quantity = 1}
                cell.quantityLBL.text = "\(item.quantity)"
            }
            
            cell.chooseOptioncBlock = {
                self.currentIndexPath = indexPath
                self.showOptions(indexPath: indexPath)
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == topCategoryCollection {
            return CGSize(width: topCategoryCollection.frame.height/1.5, height: topCategoryCollection.frame.height)
        }else {
            let width = (self.itemsCollection.frame.size.width/2)-20
            return CGSize(width: width, height: 220)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topCategoryCollection { return }
        if indexPath.row < categoryArr.count {
            let data = categoryArr[indexPath.row]
            let itemId = data.id ?? 0
            if itemId == 0 { return }
            
            let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
            vc.GET_PRODUCT_DETAILS(ItemId: itemId)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


//MARK:- API'S
extension CategoryAndItemsVC {
    
    func GET_CATEGORY_ITEMS(ItemId:Int){
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        
        IJProgressView.shared.showProgressView()
        
        let getCat = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ITEMS + "/\(userID ?? 0)" + "/\(ItemId)"
        
        //        let getCat = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ITEMS + "/\(userID ?? 0)"
        AFWrapperClass.requestGETURL(getCat ,success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            print(dict)
            
            
            
            if let result = dict as? [String: Any] {
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
            }
            
            let response = dict["data"] as? NSArray ?? NSArray()
            let status = dict["status"] as? Int ?? 0
            
            if status == 200 {
                self.categoryArr.removeAll()
                for i in 0..<response.count {
                    
                    self.categoryArr.append(Categores(dict: response.object(at: i) as! [String:Any]))
                    
                }
                // self.topCategoryCollection.reloadData()
                self.itemsCollection.reloadData()
                
                
                // let rupee = "\u{20B9}"
            }else {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
                
            }
            
        }) { (error) in
            self.message = error.localizedDescription
            alert("ChhappanBhog", message: self.message, view: self)
            
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
    
    var cartBlock: SimpleBlock?
    var quantityIncBlock: SimpleBlock?
    var quantityDecBlock: SimpleBlock?
    var chooseOptioncBlock: SimpleBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addToCartBTN.addTarget(self, action: #selector(cartAction(_:)), for: UIControl.Event.touchUpInside)
        increaseBTN.addTarget(self, action: #selector(qtyIncAction(_:)), for: UIControl.Event.touchUpInside)
        decreaseBTN.addTarget(self, action: #selector(qtyDecAction(_:)), for: UIControl.Event.touchUpInside)
        weightBTN.addTarget(self, action: #selector(optionAction(_:)), for: UIControl.Event.touchUpInside)
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
}
