//
//  searchRecordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 13/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class searchRecordVC: UIViewController {
    
    var iscomeFrom = ""
    var message:String = ""
    //MARK:- OUTLETS

    @IBOutlet weak var totalRecordsLBL: UILabel!
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
        API_GET_SEARCH_DATA()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
             
        DispatchQueue.main.async {
               self.searchTF.becomeFirstResponder()
        }
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
    
    @IBAction func textFieldAction(_ sender: UITextField) {
        API_GET_SEARCH_DATA()
    }
    
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

            let cell = recordsCollection.dequeueReusableCell(withReuseIdentifier: "SearchRecordCollectionCell", for: indexPath) as! SearchRecordCollectionCell
            return cell

    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = (self.recordsCollection.frame.size.width/2)-20
            
            return CGSize(width: width, height: 220)

    }
    
}


extension searchRecordVC {
func API_GET_SEARCH_DATA() {
    
    IJProgressView.shared.showProgressView()
    
    let Url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_SEARCH
    let userId = UserDefaults.standard.value(forKey: Constants.UserId)
    
    let params:[String:Any] = ["user_id":userId ?? 0,"keyword":searchTF.text ?? ""]
    AFWrapperClass.requestPOSTURL(Url, params: params, success: { (dict) in
        IJProgressView.shared.hideProgressView()
        print(dict)
        
        let response = dict["data"] as? NSDictionary ?? NSDictionary()
        let success = dict["success"] as? Int ?? 0
        
        if success == 0 {
            
            self.message = dict["message"] as? String ?? ""
            alert("ChappanBhog", message: self.message, view: self)
            
        }else {

        }
 
    }) { (error) in
    self.message = error.localizedDescription ?? ""
       alert("ChappanBhog", message: self.message, view: self)
        IJProgressView.shared.hideProgressView()
        
    }
}
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
