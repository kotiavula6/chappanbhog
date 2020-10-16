//
//  PaymentVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var banksCollection: UICollectionView!
    @IBOutlet weak var cartLBL: UILabel!
    
    @IBOutlet weak var orderTotaLBL: UILabel!
    
    @IBOutlet weak var deliveryChargeLBL: UILabel!
    @IBOutlet weak var totalPriceLBL: UILabel!
    @IBOutlet weak var makePaymentBTN: UIButton!
    
    @IBOutlet weak var acountHolderNameTF: UITextField!
    @IBOutlet weak var cardNumberTF: UITextField!
    
    @IBOutlet weak var CVVTF: UITextField!
    @IBOutlet weak var yearTF: UITextField!
    @IBOutlet weak var monthTF: UITextField!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setAppearance()
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
            
            
            
            self.cartLBL.layer.masksToBounds = true
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.cornerRadius = self.cartLBL.frame.height/2
            self.cartLBL.layer.masksToBounds = true
            
            //
            //                self.scrollview.layer.cornerRadius = 30
            //                self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            //  scrollview
        }
        
        self.acountHolderNameTF.setLeftPaddingPoints(10)
        self.cardNumberTF.setLeftPaddingPoints(10)
        
    }
    
    @objc func updateCartCount() {
        let data = CartHelper.shared.cartItems
        if data.count == 0 {
            cartLBL.text = ""
        }
        else {
            cartLBL.text = "\(data.count)"
        }
    }
    
    //MARK:- ACTIONS
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func makePaymentButtonClicked(_ sender: Any) {
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

//MARK:- COLLECTIONVIEW METHODS
extension PaymentVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = banksCollection.dequeueReusableCell(withReuseIdentifier: "BanksCollectionCell", for: indexPath) as! BanksCollectionCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: banksCollection.frame.width-50, height: banksCollection.frame.height)
    }
    
}


//collection view cell

class BanksCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            self.shadowView.layer.masksToBounds = true
            self.shadowView.layer.cornerRadius = 20
        }
        
    }
    
}
