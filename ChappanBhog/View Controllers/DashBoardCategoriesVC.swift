//
//  DashBoardCategoriesVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class DashBoardCategoriesVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var catCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
                 setGradientBackground(view: self.gradientView)
    
                 self.backView.layer.cornerRadius = 30
                 self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
             }
        // Do any additional setup after loading the view.
    }

}

extension DashBoardCategoriesVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catCollection.dequeueReusableCell(withReuseIdentifier: "DashboardCategCollCell", for: indexPath) as! DashboardCategCollCell
        
        if indexPath.row%2 == 0 {
            cell.bottomViewHeightConstraint.constant = 0
            cell.topViewHeightConstraint.constant = 150
        }else {
            cell.topViewHeightConstraint.constant = 0
            cell.bottomViewHeightConstraint.constant = 100
        }
        catCollection.layoutIfNeeded()
        return cell
    }
    
    
}

//collectionCell
class DashboardCategCollCell: UICollectionViewCell {
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
}
