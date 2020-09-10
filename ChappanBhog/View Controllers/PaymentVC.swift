//
//  PaymentVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var banksCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        DispatchQueue.main.async {
                setGradientBackground(view: self.gradientView)
                
                self.backView.layer.cornerRadius = 30
                self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//                
//                self.scrollview.layer.cornerRadius = 30
//                self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                
                //  scrollview
            }
    }
    

   
}
extension PaymentVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = banksCollection.dequeueReusableCell(withReuseIdentifier: "BanksCollectionCell", for: indexPath) as! BanksCollectionCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: banksCollection.frame.width, height: banksCollection.frame.height)
    }
    
}


//collection view cell

class BanksCollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var shadowView: UIView!
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
        
    }
   
}
