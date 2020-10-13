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
//    var optionsArr = [optionsModel]()
    
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
    

    @IBAction func searchAction(_ sender: UITextField) {
        
        let TF = searchTF.text ?? ""
        if TF.count > 3 {
            totalRecordsLBL.text = "\(searchArr.count) RECORDS FOUND"
            API_GET_SEARCH_DATA()
            recordsCollection.reloadData()
            
        }
        
    }
    
    @IBAction func cartButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func ClearButtonClicked(_ sender: UIButton) {
        
        searchArr.removeAll()
          recordsCollection.reloadData()
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
        cell.ratingView.rating = searchArr[indexPath.row].ratings ?? 0
        
        
        cell.increase = {
                 cell.quantity += 1
                 cell.quantityLBL.text = "\(cell.quantity)"
             }
             
             cell.decrease = {
                 
                 if cell.quantity > 1 {
                     cell.quantity -= 1
                     cell.quantityLBL.text = "\(cell.quantity)"
                 }
             }
        

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
        let searchData = searchTF.text ?? ""
        
        let params:[String:Any] = ["user_id":userId ?? 0,"keyword":searchData]
        AFWrapperClass.requestPOSTURLWithHeader(Url, params: params, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            
            let response = dict["data"] as? NSArray ?? NSArray()
            let status = dict["status"] as? Int ?? 0
            let options = dict["options"] as? NSArray ?? NSArray()
            
            if status == 200 {
                
                self.searchArr.removeAll()
   //             self.optionsArr.removeAll()
                
                for i in 0..<response.count {
                    self.searchArr.append(SearchRecordModel(dict: response.object(at: i) as! [String:Any]))
                    

                }
//                print(self.optionsArr)

            }else {
                
                self.message = dict["message"] as? String ?? ""
                alert("ChappanBhog", message: self.message, view: self)
                
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
import STRatingControl
class SearchRecordCollectionCell: UICollectionViewCell {
    
    //MARK:- OUTLETS
    @IBOutlet weak var favBTN: UIButton!
    @IBOutlet weak var addTocartBTN: UIButton!
    @IBOutlet weak var weightBTN: UIButton!
    @IBOutlet weak var priceLBL: UILabel!
    @IBOutlet weak var productNameLBL: UILabel!
    @IBOutlet weak var quantityLBL: UILabel!
    @IBOutlet weak var decreaseBTN: UIButton!
    @IBOutlet weak var increaseBTN: UIButton!
    @IBOutlet weak var productIMG: UIImageView!
    @IBOutlet weak var shadowView:UIView!
    @IBOutlet weak var ratingView: STRatingControl!
    @IBOutlet weak var weightLBL: UILabel!
    var quantity:Int = 1
    
    var increase:(()->())?
     var decrease:(()->())?
     var weigtAction:(()->())?
    
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func buttonIncreaseClicked(_ sender: UIButton) {
           
           if let actio = increase {
               actio()
           }

       }
       @IBAction func buttonDecreaseClicked(_ sender: UIButton) {
           if let actio = decrease {
                   actio()
               }
       }
       
       @IBAction func weightButtonClicked(_ sender: UIButton) {
           
           if let actio = weigtAction {
                         actio()
                     }
       }
       
    
    
}
