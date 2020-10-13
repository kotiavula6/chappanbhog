//
//  DashBoardVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import GoogleSignIn
import SDWebImage
import TwitterKit
import STRatingControl

var bannerImageBaseURL = "http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com"

class DashBoardVC: UIViewController {
    
    var YOUR_DATA_ARRAY = ["one","two","three"]

    
    var quantity:String = ""
    @IBOutlet weak var ratingView: STRatingControl!
    var bannerArr = [BannersdashBoard]()
    var categoriesArr = [categories]()
    var toppicsArr = [TopPics]()
    
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
    
    var sidemenu:sideMenu!
    
    //MARK:- APPLICATION LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(bannerArr)
        setAppearence()
        API_GET_DASHBOARD_DATA()
        API_GET_DASHBOARD_IMAGES()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.sidemenu.view.removeFromSuperview()
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
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.sidemenu.settingsAction = {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
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
                AppDelegate.shared.logout()
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
    
    
    //OPEN SIDE MENU
    @objc func menuClicked() {
        //openMenuPanel(self)
        self.view.addSubview(sidemenu.view)
    }
    
    //MARK:- ACTIONS
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openMenu(_ sender: UIButton) {
        //        UIView.animate(withDuration: 3, animations: {
        //
        self.view.addSubview(self.sidemenu.view)
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
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "searchRecordVC") as! searchRecordVC
        vc.iscomeFrom = "search"
          self.navigationController?.pushViewController(vc, animated: true)
  
    }
    
}

extension DashBoardVC:UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return YOUR_DATA_ARRAY.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return YOUR_DATA_ARRAY[row]
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
        
        if let imgAr = toppicsArr[indexPath.row].image {
            if imgAr.count > 0 {
                cell.productIMG.sd_setImage(with: URL(string: imgAr[0] ), placeholderImage: UIImage(named: "placeholder.png"))
            }
            
        }
        
        cell.productNameLBL.text = toppicsArr[indexPath.row].title
        cell.priceLBL.text = "\(toppicsArr[indexPath.row].price ?? 0)"
        cell.totalReviewsLBL.text = "\(toppicsArr[indexPath.row].reviews ?? 0) Reviews"
        // cell.quantityLBL.text = "\(toppicsArr[indexPath.row].available_quantity ?? 0)"
        cell.starRating.rating = toppicsArr[indexPath.row].ratings ?? 0
        DispatchQueue.main.async {
            self.topPicsTableConstants.constant = self.topPicsTable.contentSize.height
        }
        cell.increaseBTN.tag = indexPath.row
        cell.decreaseBTN.tag = indexPath.row
        cell.weightBTN.tag = indexPath.row
        cell.tag = indexPath.row
        
        cell.addTocartButton.addTarget(self, action: #selector(cartButtonClickedd(sender:)) , for: .touchUpInside)
        cell.weightBTN.addTarget(self, action: #selector(openPicker(sender:)), for: .touchUpInside)
      

        cell.increase = {
            cell.quantity += 1
            cell.quantityLBL.text = "\(cell.quantity)"
        }
        
        cell.decrease = {
            if cell.quantity > 1 {
                cell.quantity -= 1
                cell.quantityLBL.text = "\(cell.quantity)"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
        let itemId = toppicsArr[indexPath.row].id ?? 0
        vc.GET_PRODUCT_DETAILS(ItemId: itemId)
        
        
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
            cell.bannerIMG.sd_setImage(with: URL(string: baseUrl + bannerArr[indexPath.row].image!), placeholderImage: UIImage(named: "placeholder.png"))
            
            return cell
        }
        else {
            let cell = productsCatCollection.dequeueReusableCell(withReuseIdentifier: "DashboardProdutsCatCollectionCell", for: indexPath) as! DashboardProdutsCatCollectionCell
            
            cell.productIMG.sd_setImage(with: URL(string: categoriesArr[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
            
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
            let id = categoriesArr[indexPath.row].id ?? 0
             vc.GET_CATEGORY_ITEMS(ItemId: id)
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
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
            
            print(dict)
            
            let response = dict["data"] as? NSDictionary ?? NSDictionary()
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChhappanBhog", message: self.message, view: self)
            }else {
                
                let banners = response["banners"] as? NSArray ?? NSArray()
                let topPicks = response["topPicks"] as? NSArray ?? NSArray()
                let categori = response["categories"] as? NSArray ?? NSArray()
                print(banners)
                
                self.bannerArr.removeAll()
                self.toppicsArr.removeAll()
                
                for i in 0..<banners.count {
                    self.bannerArr.append(BannersdashBoard(dict: banners.object(at: i) as! [String:Any]))
                }
                for i in 0..<topPicks.count {
                    self.toppicsArr.append(TopPics(dict: topPicks.object(at: i) as! [String:Any]))
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
            print(dict)
            
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
