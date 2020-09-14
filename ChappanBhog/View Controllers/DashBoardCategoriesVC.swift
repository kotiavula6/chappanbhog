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

    @IBAction func openMenu(_ sender: UIButton) {
        
    }
}

extension DashBoardCategoriesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = catCollection.dequeueReusableCell(withReuseIdentifier: "DashboardCategCollCell", for: indexPath) as! DashboardCategCollCell
        
        if indexPath.row%3 == 0 {
            
            cell.backView.backgroundColor = .systemPink
            cell.topViewHeightConstraint.constant = 200
        }else {
            cell.backView.backgroundColor = .green
            cell.topViewHeightConstraint.constant = 150
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: catCollection.frame.width/2.3, height: catCollection.frame.height/2)
    }
    
    
    
}

//collectionCell
class DashboardCategCollCell: UICollectionViewCell {
    
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
 
    @IBOutlet weak var backView: UIView!
    
}
