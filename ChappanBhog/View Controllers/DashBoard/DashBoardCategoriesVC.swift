//
//  DashBoardCategoriesVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class DashBoardCategoriesVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
  
 
    
    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var catCollection: UICollectionView!
    @IBOutlet weak var cartLBL: UILabel!
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = catCollection?.collectionViewLayout as? PinterestLayout {
          layout.delegate = self
        }
        if let patternImage = UIImage(named: "Pattern") {
          view.backgroundColor = UIColor(patternImage: patternImage)
        }
        catCollection?.backgroundColor = .clear
        catCollection?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        catCollection.delegate = self
        catCollection.dataSource = self
        
        setAppearnace()

    }
    
    override func viewWillLayoutSubviews() {
        setGradientBackground(view: self.gradientView)
    }
    
    //MARK:- FUNCTIONS
    func setAppearnace() {
        DispatchQueue.main.async {
            
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.masksToBounds = true
            self.cartLBL.layer.cornerRadius = self.cartLBL.layer.frame.height/2
            
        }
    }
    
    
    
    //MARK:- ACTIONS
    @IBAction func openMenu(_ sender: UIButton) {
        
    }
    
}

//MARK:- COLLECTIONVIEW METHODS
extension DashBoardCategoriesVC: UICollectionViewDelegateFlowLayout {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 15
  }
  
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    
    let cell = catCollection.dequeueReusableCell(withReuseIdentifier: "DashboardCategCollCell", for: indexPath as IndexPath) as! DashboardCategCollCell
        //  cell.imageView.image = UIImage(named: photosArray[indexPath.row])
   // rgb(255, 203, 156)
    if seconArra.contains(indexPath.row) {
       // cell.backView.backgroundColor = .lightGray
//        cell.bottomLBL.numberOfLines = 0
//        cell.bottomLBL.isHidden = true
     //   cell.bottomLBLconstant.constant = 0
       // cell.imgView.image = UIImage(named: "yellow")
//
        cell.backView.backgroundColor = #colorLiteral(red: 1, green: 0.7960784314, blue: 0.6117647059, alpha: 0.7991759418)
    }else {
         //   cell.backView.backgroundColor = .red
//        cell.topLBL.numberOfLines = 0
//        cell.topLBL.isHidden = true
        cell.backView.backgroundColor = .white
      //  cell.topLBLConstant.constant = 0
     //   cell.imgView.image = UIImage(named: "white")
    }
    return cell
    
    
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
    return CGSize(width: itemSize, height: itemSize)
  }
}

extension DashBoardCategoriesVC: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    
    if seconArra.contains(indexPath.row)  {
      return 220
    }
    return 180
    
  }
  
}



//collectionCell
class DashboardCategCollCell: UICollectionViewCell {
    
    @IBOutlet weak var bottomLBLconstant: NSLayoutConstraint!
    @IBOutlet weak var topLBLConstant: NSLayoutConstraint!
    @IBOutlet weak var bottomLBL: UILabel!
    @IBOutlet weak var topLBL: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
         //   self.backView.clipsToBounds = true
            self.backView.cornerRadius = 20
        }
       
    }
    
}
