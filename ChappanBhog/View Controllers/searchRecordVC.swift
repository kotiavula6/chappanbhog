//
//  searchRecordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 13/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class searchRecordVC: UIViewController {
    
    @IBOutlet weak var categoryCollection: UICollectionView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var recordsCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.searchView.cornerRadius = self.searchView.frame.height/2
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    @IBAction func clearBTN(_ sender: UIButton) {
        
        
    }
    
}

extension searchRecordVC:UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollection {
            let cell = categoryCollection.dequeueReusableCell(withReuseIdentifier: "searchCategoryCollection", for: indexPath) as! searchCategoryCollection
                            return cell
        }else {
            let cell = recordsCollection.dequeueReusableCell(withReuseIdentifier: "SearchRecordCollectionCell", for: indexPath) as! SearchRecordCollectionCell
                   return cell
        }
        
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollection {
                     return CGSize(width: recordsCollection.frame.width/3, height: recordsCollection.frame.width/3)
        }else {
        
        let width = (self.recordsCollection.frame.size.width/2.2)
           let height = self.recordsCollection.frame.size.height/1.3
                      return CGSize(width: width, height: height)
        }
    
   
    }
    
        
    
}


//topCategory cell


class searchCategoryCollection: UICollectionViewCell {

}

//class
class SearchRecordCollectionCell: UICollectionViewCell {
    @IBOutlet weak var shadowView:UIView!
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
    }
}
