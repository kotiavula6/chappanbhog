//
//  DashBoardVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import GoogleSignIn
import SDWebImage
//import TwitterKit
import STRatingControl
import Alamofire

var bannerImageBaseURL = "http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com"

class DashBoardVC: UIViewController {
    
    var YOUR_DATA_ARRAY = ["one","two","three"]
    
    var senderTag = Int()
    var quantity:String = ""
    @IBOutlet weak var ratingView: STRatingControl!
    var bannerArr = [BannersdashBoard]()
    var categoriesArr = [categories]()
    var toppicsArr = [Categores]()
    var options = [optionss]()
    
    var totalCartItems:Int = 1
    var message:String = ""
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    
    //MARK:- OUTLETS
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var alertHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var topPicsTableConstants: NSLayoutConstraint!
    @IBOutlet weak var topPicsTable: UITableView!
    @IBOutlet weak var searchBackView: UIView!
    @IBOutlet weak var topPageCollection: UICollectionView!
    @IBOutlet weak var productsCatCollection: UICollectionView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLBL: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var alertIMG: UIImageView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var categorySearchBar: UISearchBar!
    
    var sidemenu:sideMenu!
    var currentIndexPath: IndexPath?
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categorySearchBar.setTextField(color: UIColor.white.withAlphaComponent(1.0))
        self.categorySearchBar.delegate = self
        setAppearence()

        CartHelper.shared.syncCarts()
        
        /*let phone = "7017777239"
        let code = "+91"
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "VerifyPhoneVC") as! VerifyPhoneVC
        vc.phone = phone
        vc.code = code
        self.navigationController?.pushViewController(vc, animated: true)*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
        reloadTable()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
        API_GET_DASHBOARD_DATA()
        API_GET_DASHBOARD_IMAGES()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        self.sidemenu.view.removeFromSuperview()
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
    }
    
    //MARK:- UI APPEARENCE
    func setAppearence() {
        
        DispatchQueue.main.async {
            
            self.cartLBL.layer.masksToBounds = true
            setGradientBackground(view: self.view)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.searchBackView.cornerRadius = self.searchBackView.frame.height/2
            self.alertHeightConstant.constant = 0
            self.cartLBL.cornerRadius = self.cartLBL.frame.height/2
            self.alertIMG.isHidden = true
            
            self.sidemenu = sideMenu(nibName: "sideMenu", bundle: nil)
            self.sidemenu.closeMenu = {
                self.sidemenu.view.removeFromSuperview()
            }
            self.sidemenu.ShopAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "OurMenuVC") as! OurMenuVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.sidemenu.myAccountAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
                vc.isFromSideMenu = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.sidemenu.settingsAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
                vc.isFromSideMenu = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.sidemenu.cartAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.sidemenu.aboutAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
            self.sidemenu.logoutAction = {
                
                /*let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                 self.navigationController?.pushViewController(vc, animated: true)
                 UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                 GIDSignIn.sharedInstance().signOut()
                 let store = TWTRTwitter.sharedInstance().sessionStore
                 
                 if let userID = store.session()?.userID {
                 store.logOutUserID(userID)
                 }*/
                
               // self.showAlertWithTitle(title: "", message: "Are you sure you want to logout?", okButton: "Yes", cancelButton: "No", okSelectorName: #selector(self.logout))
            }
            
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuClicked))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    
    
    @objc func cartButtonClickedd(sender: UIButton) {
        if totalCartItems > 1 {
            cartLBL.text = "\(totalCartItems)"
        }
    }
    
    @objc func openPicker(sender:UIButton) {
        print(sender.tag)
        senderTag = sender.tag
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
    
    func reloadTable() {
        DispatchQueue.main.async {
            self.topPicsTable.reloadData()
        }
    }
    
    func reloadTopPageCollection() {
        DispatchQueue.main.async {
            self.topPageCollection.reloadData()
        }
    }
    
    func reloadProductsCollection() {
        DispatchQueue.main.async {
            self.productsCatCollection.reloadData()
        }
    }
    
    //OPEN SIDE MENU
    @objc func menuClicked() {
        //openMenuPanel(self)
        self.view.addSubview(sidemenu.view)
    }
    
    //MARK:- ACTIONS
    @IBAction func cartButtonClicked(_ sender: UIButton) {

        /*let model: PayUHelperModel = PayUHelperModel()
        model.amount = "200"
        model.customerName = "Vakul"
        model.email = "vakul@enacteservices.com"
        model.merchantDisplayName = "ChhappanBhog"
        model.phone = "9090900909"
        model.productName = "Kaju Katli - 500gm"
        model.details = CartHelper.shared.generateOrderDetails()
        
        let header: HTTPHeaders = ["Content-Type": "application/json", "APIKEY": "Y2hoYXBwYW5iaG9nOk9RaDRZRXQ="]
        let strURL = "https://www.chhappanbhog.com/restapi/example/payu.php"
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
                    
                    if model.requestHash.isEmpty || model.txnId.isEmpty { return }
                    DispatchQueue.main.async {
                        PayUHelper.sharedInstance().presentPaymentScreen(from: self, for: model) { (response, error, extra) in
                            if let error = error {
                                print(error)
                                return
                            }
                            
                            if let response = response {
                                print(response)
                            }
                            
                            if let extra = extra {
                                print(extra)
                            }
                        }
                    }
                case .failure(let error):
                    let error : NSError = error as NSError
                    print(error)
                }
        }
        return;*/
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openMenu(_ sender: UIButton) {
         AppDelegate.shared.sideMenuViewController.toggleLeft()
        //        UIView.animate(withDuration: 3, animations: {
        //
       // self.view.addSubview(self.sidemenu.view)
        //                self.view.layoutIfNeeded()
        //
        //        }, completion: nil)
        
        // openMenuPanel(self)
    }
    
    
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func searchTFAction(_ sender: UITextField) {
        
        
    }
    
    @IBAction func searchButtonAction(_ sender: UIButton) {
//        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "searchRecordVC") as! searchRecordVC
//        vc.iscomeFrom = "search"
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension DashBoardVC:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        quantity = YOUR_DATA_ARRAY[row]
    }
}

//MARK:- TABLEVIEW METHODS
extension DashBoardVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppicsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopPicsTableCell") as! TopPicsTableCell
    
        let data = toppicsArr[indexPath.row]
        if let image = toppicsArr[indexPath.row].image.first {
            cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: PlaceholderImage.Category)
        }
        
        cell.productNameLBL.text = data.title
        cell.totalReviewsLBL.text = "\(data.reviews) \(data.reviews == 1 ? "review" : "reviews")"
        cell.starRating.rating = data.ratings
        
        let option = data.selectedOption()
        if  option.id > 0 {
            cell.weightLBL.text = option.name
            cell.priceLBL.text = String(format: "%.0f", option.price).prefixINR
            cell.layoutConstraintWeightWidth.constant = 60
            cell.layoutConstraintWeightTrailing.constant = 10
        }
        else {
            cell.weightLBL.text = " "
            cell.priceLBL.text = String(format: "%.0f", data.price).prefixINR
            cell.layoutConstraintWeightWidth.constant = 0
            cell.layoutConstraintWeightTrailing.constant = 0
        }
        cell.layoutIfNeeded()
        
        cell.favButton.tintColor = data.isFavourite ? .red : .lightGray
        cell.favouriteBlock = {
            let item = self.toppicsArr[indexPath.row]
            let favourite = !item.isFavourite
            cell.favButton.isUserInteractionEnabled = false
            item.markFavourite(favourite) { (success) in
                DispatchQueue.main.async {
                    cell.favButton.isUserInteractionEnabled = true
                    cell.favButton.tintColor = item.isFavourite ? .red : .lightGray
                }
            }
        }
        
        cell.cartBlock = {
            let item = self.toppicsArr[indexPath.row]
            let cartItem = CartItem(item: item)
            CartHelper.shared.addToCart(cartItem: cartItem)
            AppDelegate.shared.notifyCartUpdate()
        }
        
        cell.quantityIncBlock = {
            let item = self.toppicsArr[indexPath.row]
            item.quantity += 1
            cell.quantityLBL.text = "\(item.quantity)"
        }
        
        cell.quantityDecBlock = {
            let item = self.toppicsArr[indexPath.row]
            item.quantity -= 1
            if item.quantity < 1 { item.quantity = 1}
            cell.quantityLBL.text = "\(item.quantity)"
        }
        
        cell.chooseOptioncBlock = {
            
            let item = self.toppicsArr[indexPath.row]
            if item.options.count == 0 {
                return
            }
            
            self.currentIndexPath = indexPath
            self.showOptions(indexPath: indexPath)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
        vc.item = self.toppicsArr[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
//MARK:- COLLECTIONVIEW METHODS
extension DashBoardVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == topPageCollection {
            return bannerArr.count
        }else {
            return categoriesArr.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topPageCollection {
            let cell = topPageCollection.dequeueReusableCell(withReuseIdentifier: "DashboardPageCollectionCell", for: indexPath) as! DashboardPageCollectionCell
            
            let baseUrl = "http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com/"
            cell.bannerIMG.sd_setImage(with: URL(string: baseUrl + bannerArr[indexPath.row].image!), placeholderImage: PlaceholderImage.Category)
            
            return cell
        }
        else {
            let cell = productsCatCollection.dequeueReusableCell(withReuseIdentifier: "DashboardProdutsCatCollectionCell", for: indexPath) as! DashboardProdutsCatCollectionCell
            
            cell.productIMG.sd_setImage(with: URL(string: categoriesArr[indexPath.row].image ?? ""), placeholderImage: PlaceholderImage.Category)
            
            cell.productNameLBL.text = categoriesArr[indexPath.row].name
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == topPageCollection {
            return CGSize(width: topPageCollection.frame.width, height: topPageCollection.frame.height)
        }else {
            return CGSize(width: productsCatCollection.frame.height/1.3, height: productsCatCollection.frame.height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == topPageCollection {
            
            let type = bannerArr[indexPath.row].type
            if type == 0 {
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CategoryAndItemsVC") as! CategoryAndItemsVC
                vc.isFromNavgation = true
                let id = bannerArr[indexPath.row].id ?? 0
                vc.GET_CATEGORY_ITEMS(ItemId: id)
                self.navigationController?.pushViewController(vc, animated: true)
                
            } else if type == 1 {
                
                let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
                let itemId = bannerArr[indexPath.row].id ?? 0
                vc.GET_PRODUCT_DETAILS(ItemId: itemId)
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
            
        } else {
            
            let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CategoryAndItemsVC") as! CategoryAndItemsVC
            vc.isFromNavgation = true
            let id = categoriesArr[indexPath.row].id ?? 0
            vc.GET_CATEGORY_ITEMS(ItemId: id)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

extension DashBoardVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "searchRecordVC") as! searchRecordVC
        vc.iscomeFrom = "search"
        vc.searchedText = searchBar.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- API
extension DashBoardVC {
    func API_GET_DASHBOARD_DATA() {
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        IJProgressView.shared.showProgressView()
        let bannersUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_DASHBOARD_DATA + "/\(userID ?? 0)"
        AFWrapperClass.requestGETURL(bannersUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            if let result = dict as? [String : Any] {
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
            }
            
            //print(bannersUrl)
            //print(dict)
            
            let response = dict["data"] as? NSDictionary ?? NSDictionary()
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                self.message = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
            } else {
                
                let banners = response["banners"] as? NSArray ?? NSArray()
                let topPicks = response["topPicks"] as? [[String: Any]] ?? []
                
                self.bannerArr.removeAll()
                self.toppicsArr.removeAll()
                self.options.removeAll()
                
                for i in 0..<banners.count {
                    self.bannerArr.append(BannersdashBoard(dict: banners.object(at: i) as! [String:Any]))
                }
                
                for value in topPicks {
                    let item = Categores(dict: value)
                    self.toppicsArr.append(item)
                }
            }
            self.topPageCollection.reloadData()
            self.topPicsTable.reloadData()
            
            
        }) { (error) in
            
            IJProgressView.shared.hideProgressView()
            
        }
    }
    
    //MARK:- GET CATEGORIES
    func API_GET_DASHBOARD_IMAGES() {
        
        IJProgressView.shared.showProgressView()
        let bannersUrl = "https://www.chhappanbhog.com/restapi/example/getcategories.php"
        AFWrapperClass.requestGETURL(bannersUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            //print(bannersUrl)
            //print(dict)
            
            if let result = dict as? [String : Any] {
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
            }
            
            let response = dict["data"] as? NSArray ?? NSArray()
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
                
            }else {
                self.categoriesArr.removeAll()
                for i in 0..<response.count {
                    self.categoriesArr.append(categories(dict: response.object(at: i) as! [String:Any]))
                    
                }
            }
            self.productsCatCollection.reloadData()
            
        }) { (error) in
            self.message = error.localizedDescription
            alert("ChhappanBhog", message: self.message, view: self)
            
        }
    }
}


// MARK:- PickerView
extension DashBoardVC: PickerViewDelegate {
    
    func showOptions(indexPath: IndexPath) {
        
        PickerView.shared.delegate = self
        PickerView.shared.type = .Picker
        
        let item = self.toppicsArr[indexPath.row]
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
            let item = toppicsArr[indexPath.row]
            let result = item.options.filter{$0.name == option}
            if let option = result.first {
                item.selectedOptionId = option.id
                topPicsTable.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func pickerDidSelectDate(_ date: Date, picker: PickerView) {
        
    }
}



//COLLECTION CELLS
class DashboardPageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerIMG: UIImageView!
    
    override func awakeFromNib() {
        // setShadowRadius(view: bannerIMG)
    }
}

class DashboardProdutsCatCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backShadowView: UIView!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    
    override func awakeFromNib() {
        
        // setShadowRadius(view: backShadowView)
        DispatchQueue.main.async {
            self.backShadowView.layer.cornerRadius = self.backShadowView.frame.height/2
            self.productIMG.layer.cornerRadius = self.productIMG.frame.height/2
        }
    }
}


