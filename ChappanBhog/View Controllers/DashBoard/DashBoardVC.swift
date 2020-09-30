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

var bannerImageBaseURL = "http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com"

class DashBoardVC: UIViewController {
    
    var bannerArr = [BannersdashBoard]()
    var categoriesArr = [categories]()
    var toppicsArr = [TopPics]()
    
    
    var message:String = ""
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
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
                self.navigationController?.pushViewController(vc, animated: true)
                UserDefaults.standard.set(false, forKey: "ISUSERLOGGEDIN")
                GIDSignIn.sharedInstance().signOut()
                
            }
            
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuClicked))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
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
    
    @IBAction func cartButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func searchTFAction(_ sender: UITextField) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "searchRecordVC") as! searchRecordVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK:- TABLEVIEW METHODS
extension DashBoardVC:UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toppicsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopPicsTableCell") as! TopPicsTableCell
        
        cell.productIMG.sd_setImage(with: URL(string: toppicsArr[indexPath.row].image![1] ), placeholderImage: UIImage(named: "placeholder.png"))
        cell.productNameLBL.text = toppicsArr[indexPath.row].title
        cell.priceLBL.text = "\(toppicsArr[indexPath.row].price ?? 0)"
        cell.totalReviewsLBL.text = "\(toppicsArr[indexPath.row].reviews ?? 0) Reviews"
       // cell.quantityLBL.text = "\(toppicsArr[indexPath.row].available_quantity ?? 0)"
        
    
        DispatchQueue.main.async {
            self.topPicsTableConstants.constant = self.topPicsTable.contentSize.height
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
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
            
            // let bannerImage = bannerArr[indexPath.row].image ?? ""
            
            // bannerImage = bannerImage == "" ? "": (bannerImageBaseURL + bannerImage)
            
            //  cell.bannerIMG.loadImageUsingCacheUrlString(urlString: bannerImage)

            cell.bannerIMG.sd_setImage(with: URL(string: "http://ec2-52-66-236-44.ap-south-1.compute.amazonaws.com/" + bannerArr[indexPath.row].image!), placeholderImage: UIImage(named: "placeholder.png"))
  
            return cell
        }
        else {
            let cell = productsCatCollection.dequeueReusableCell(withReuseIdentifier: "DashboardProdutsCatCollectionCell", for: indexPath) as! DashboardProdutsCatCollectionCell
            let baseUrl = ""
//            cell.productIMG.sd_setImage(with: URL(string: baseUrl  + categoriesArr[indexPath.row].image!), placeholderImage: UIImage(named: "placeholder.png"))
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
         
}

//MARK:- API
extension DashBoardVC {
    
    func API_GET_DASHBOARD_DATA() {
        
        IJProgressView.shared.showProgressView()
        let bannersUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_DASHBOARD_DATA
        AFWrapperClass.requestGETURL(bannersUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)
            
            let response = dict["data"] as? NSDictionary ?? NSDictionary()
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                
                self.message = dict["message"] as? String ?? ""
                showAlert(self.message)
                
            }else {
                
                let banners = response["banners"] as? NSArray ?? NSArray()
                let topPicks = response["topPicks"] as? NSArray ?? NSArray()
                let categori = response["categories"] as? NSArray ?? NSArray()
                print(banners)
                
                self.bannerArr.removeAll()
                self.toppicsArr.removeAll()
                self.categoriesArr.removeAll()
                
                for i in 0..<banners.count {
                    self.bannerArr.append(BannersdashBoard(dict: banners.object(at: i) as! [String:Any]))
                }
                for i in 0..<topPicks.count {
                    self.toppicsArr.append(TopPics(dict: topPicks.object(at: i) as! [String:Any]))
                }
                for i in 0..<categori.count  {
                    self.categoriesArr.append(categories(dict: categori.object(at: i) as! [String:Any]))
                }
            }
            self.topPageCollection.reloadData()
            self.topPicsTable.reloadData()
            self.productsCatCollection.reloadData()
            
        }) { (error) in
            
            IJProgressView.shared.hideProgressView()
            
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
