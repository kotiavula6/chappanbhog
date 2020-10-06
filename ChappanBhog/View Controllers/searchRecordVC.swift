//
//  searchRecordVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 13/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class searchRecordVC: UIViewController {
    
    var searchArr = [SearchRecordModel]()
    
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
      //  searchTF.delegate = self
        setAppearance()
   
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
    
    @IBAction func searchTF(_ sender: UITextField) {
        
        let TF = searchTF.text ?? ""
        
        if TF.count > 3 {
            
        API_GET_SEARCH_DATA()
       // recordsCollection.reloadData()
            
        }
        
        
    }
    
    
    @IBAction func textFieldAction(_ sender: UITextField) {
        let ksearchTF = searchTF.text ?? ""
        if ksearchTF.count >= 1 {
            API_GET_SEARCH_DATA()
            recordsCollection.reloadData()
            totalRecordsLBL.text = "\(searchArr.count) RECORDS FOUND"
        }
        
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
        return searchArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = recordsCollection.dequeueReusableCell(withReuseIdentifier: "SearchRecordCollectionCell", for: indexPath) as! SearchRecordCollectionCell
        cell.productIMG.sd_setImage(with: URL(string: searchArr[indexPath.row].image?[0] ?? ""), placeholderImage: UIImage(named: "placeholder.png"))
        cell.productNameLBL.text = searchArr[indexPath.row].title
        cell.priceLBL.text = "\(searchArr[indexPath.row].price ?? 0)"
        cell.weightLBL.text =  ""
        cell.ratingView.rating = Double((searchArr[indexPath.row].ratings ?? 0))
        cell.favBTN.backgroundColor = .red
        
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
            
            let response = dict["data"] as? NSArray ?? NSArray()
            let success = dict["success"] as? Int ?? 0
            
            if success == 0 {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChappanBhog", message: self.message, view: self)
                
            }else {
                
                self.searchArr.removeAll()
                for i in 0..<response.count {
                    self.searchArr.append(SearchRecordModel(dict: response.object(at: i) as! [String:Any]))
                }
                
            }
            self.recordsCollection.reloadData()
        }) { (error) in
            self.message = error.localizedDescription 
            alert("ChappanBhog", message: self.message, view: self)
            IJProgressView.shared.hideProgressView()
            
        }
    }
}


//class
import Cosmos
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
    
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var weightLBL: UILabel!
    override func awakeFromNib() {
        
    }
    
}
