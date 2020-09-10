//
//  PaymentVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class PaymentVC: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var banksCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    
}


//collection view cell

class BanksCollectionCell: UICollectionViewCell {
    
}
