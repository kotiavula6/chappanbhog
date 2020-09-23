//
//  searchRecordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 13/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class searchRecordVC: UIViewController {
    
    
    //MARK:- OUTLETS
    @IBOutlet weak var recordsCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var categoryCollHeight: NSLayoutConstraint!
    @IBOutlet weak var totalRecordsLBL: UILabel!
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var recordsCollection: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var cartLBL: UILabel!
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAppearance()
        
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.searchView.cornerRadius = self.searchView.frame.height/2
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.masksToBounds = true
            self.cartLBL.cornerRadius = self.cartLBL.frame.height/2
        }
    }
    
    //MARK:- ACTIONS
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func ClearButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func clearBTN(_ sender: UIButton) {
        
        
    }
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:-  COLLECTIONVIEW METHODS
extension searchRecordVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollection {
            let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "searchCategoryCollection", for: indexPath) as! searchCategoryCollection
            
            DispatchQueue.main.async {
                self.categoryCollHeight.constant = self.categoryCollection.contentSize.height
            }
            return cell
        }else {
            let cell = recordsCollection.dequeueReusableCell(withReuseIdentifier: "SearchRecordCollectionCell", for: indexPath) as! SearchRecordCollectionCell
            
            DispatchQueue.main.async {
                self.recordsCollectionHeight.constant = self.recordsCollection.contentSize.height
            }
            
            return cell
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection {
            return CGSize(width: recordsCollection.frame.width/4, height: recordsCollection.frame.width/4)
        }else {
            
            let width = (self.recordsCollection.frame.size.width/2)-20
            
            return CGSize(width: width, height: 220)
        }
        
        
    }
    
}


//topCategory cell


class searchCategoryCollection: UICollectionViewCell {
    //MARK:- OUTLETS
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var productNameLBL: UILabel!
}

//class
class SearchRecordCollectionCell: UICollectionViewCell {
    //MARK:- OUTLETS
    @IBOutlet weak var favBTN: UIButton!
    @IBOutlet weak var addTocartBTN: UIButton!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet var starImages: [UIImageView]!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var decreaseBTN: UIButton!
    @IBOutlet weak var increaseBTN: UIButton!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var shadowView:UIView!
    
    override func awakeFromNib() {
        
    }
    
}
