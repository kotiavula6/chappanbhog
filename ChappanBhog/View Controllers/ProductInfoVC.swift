//
//  ProductInfoVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import SDWebImage
import STRatingControl

class ProductInfoVC: UIViewController {
    
    var quantity:Int = 1
    var imageArry:[String] = []
    var optionsArr = [[String:Any]]()
    var message:String = ""
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var available_quantity:Int = 0
    
    @IBOutlet weak var favroteBTN: UIButton!
    @IBOutlet weak var deliveryTimeLBL: UILabel!
    @IBOutlet weak var totalReviewsLBL: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var productBacView: UIView!
    //MARK:- OUTLETS
    @IBOutlet weak var descriptionLBL: UILabel!
    @IBOutlet weak var weightLBL: UILabel!
    @IBOutlet weak var productImageCollection: UICollectionView!
    @IBOutlet weak var payBTN: UIButton!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        
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
    
    //MARK:- ACTIONS
    @IBAction func weightButtonAction(_ sender: UIButton) {
        
        
    }
    
    @IBAction func increseBTN(_ sender: UIButton) {
        if quantity > available_quantity {
            print(available_quantity)
            message = "MaxQuantity is \(available_quantity)"
            alert("ChhappanBhog", message: self.message, view: self)
        }else {
            quantity += 1
            quantityLBL.text = "\(quantity)"
        }
        
    }
    
    @IBAction func decreaseBTN(_ sender: UIButton) {
        if quantity >= 2 {
            quantity -= 1
            quantityLBL.text = "\(quantity)"
        }
        
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func payButtonClicked(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favroteButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func openPicker() {
        picker = UIPickerView.init()
        picker.delegate = self
        picker.backgroundColor = UIColor.white
        picker.setValue(UIColor.black, forKey: "textColor")
        picker.autoresizingMask = .flexibleWidth
        picker.contentMode = .center
        picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(picker)

        toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        toolBar.barStyle = .blackTranslucent
        toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(toolBar)

    }
    
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
    }
    

    
}

//MARK:- COLLECTION VIEW METHODS
extension ProductInfoVC: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productImageCollection.dequeueReusableCell(withReuseIdentifier: "productDetailImageCollection", for: indexPath) as! productDetailImageCollection
        cell.productIMG.sd_setImage(with: URL(string: imageArry[indexPath.row] ), placeholderImage: UIImage(named: "placeholder.png"))
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
            print(dict)
            
            let response = dict["data"] as? NSDictionary ?? NSDictionary()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: response as! [String: Any], self)
            if isTokenExpired {
                return
            }
            
            let status = dict["status"] as? Int ?? 0
            
            if status == 200 {
                
                let title = response["title"] as? String ?? ""
                let description = response["description"] as? String ?? ""
                if let options = response["options"] as? [[String:Any]] {
                    self.optionsArr.append(contentsOf: options)
                }
                // print(self.optionsArr)
                self.imageArry = response["image"] as? [String] ?? []
                
                let ratings = response["ratings"] as? Double ?? 0
                let reviews = response["reviews"] as? Int ?? 0
                let favorite = response["favorite"] as? Int ?? 0
                let price = response["price"] as? String ?? ""
                self.available_quantity = response["available_quantity"] as? Int ?? 0
                self.ratingView.rating = Int(ratings)
                self.productNameLBL.text = title
                let rupee = "\u{20B9}"
                self.productPrice.text = "\(rupee) \(price)"
                self.descriptionLBL.text = description
                //r   self.quantityLBL.text = "\(self.quantity)"
                self.weightLBL.text = "250GM"
                //     self.deliveryTimeLBL.text = t
                self.totalReviewsLBL.text = "rupee\(reviews) Reviews"
                
                if let option = self.optionsArr.first {
                    self.productPrice.text = "\(option["price"] as? Int ?? 0)"
                }
                
            } else {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
                
            }
            self.productImageCollection.reloadData()
            
        }) { (error) in
            self.message = error.localizedDescription
            alert("ChhappanBhog", message: self.message, view: self)
            
        }
        
    }
    
}

extension ProductInfoVC : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return optionsArr.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsArr[row]["name"] as? String
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        quantity = YOUR_DATA_ARRAY[row]
    }
    
}


//collectionview cell top
class productDetailImageCollection: UICollectionViewCell {
    
    @IBOutlet weak var productIMG: UIImageView!
}


