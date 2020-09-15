//
//  DashBoardVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class DashBoardVC: UIViewController {


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
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(menuClicked))
              swipeRight.direction = UISwipeGestureRecognizer.Direction.right
              self.view.addGestureRecognizer(swipeRight)
        
        // Do any additional setup after loading the view.
        SetUI()
       
    }
    
    func SetUI() {
        DispatchQueue.main.async {
            self.cartLBL.layer.masksToBounds = true
            setGradientBackground(view: self.view)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.searchBackView.cornerRadius = self.searchBackView.frame.height/2
            self.alertHeightConstant.constant = 0
            self.cartLBL.cornerRadius = self.cartLBL.frame.height/2
            self.alertIMG.isHidden = true
            
        }
    }
    
    
    @objc func menuClicked() {
          openMenuPanel(self)
      }
    @IBAction func cartButtonClicked(_ sender: UIButton) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func openMenu(_ sender: UIButton) {
        
     openMenuPanel(self)
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
            return CGSize(width: productsCatCollection.frame.height, height: productsCatCollection.frame.height)
        }
    }


}


class DashboardPageCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var bannerIMG: UIImageView!
    override func awakeFromNib() {
        setShadowRadius(view: bannerIMG)
    }
}

class DashboardProdutsCatCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var backShadowView: UIView!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var productIMG: UIImageView!
    
    override func awakeFromNib() {
      
        setShadowRadius(view: backShadowView)
        DispatchQueue.main.async {
            self.backShadowView.layer.cornerRadius = self.backShadowView.frame.height/2
               self.productIMG.layer.cornerRadius = self.backShadowView.frame.height/2
        }
    }
}
