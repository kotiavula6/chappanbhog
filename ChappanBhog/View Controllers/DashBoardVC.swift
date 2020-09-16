//
//  DashBoardVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class DashBoardVC: UIViewController {
    
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
        
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuClicked))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
        setAppearence()
        
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
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.sidemenu.view.removeFromSuperview()
    }
    
    
    @objc func menuClicked() {
        //openMenuPanel(self)
        self.view.addSubview(sidemenu.view)
    }
    
    //MARK:- Actions
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openMenu(_ sender: UIButton) {
        
        self.view.addSubview(sidemenu.view)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopPicsTableCell") as! TopPicsTableCell
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
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == topPageCollection {
            let cell = topPageCollection.dequeueReusableCell(withReuseIdentifier: "DashboardPageCollectionCell", for: indexPath) as! DashboardPageCollectionCell
            return cell
        }
        else {
            let cell = productsCatCollection.dequeueReusableCell(withReuseIdentifier: "DashboardProdutsCatCollectionCell", for: indexPath) as! DashboardProdutsCatCollectionCell
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
