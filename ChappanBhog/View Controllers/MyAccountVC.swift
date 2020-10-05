//
//  MyAccountVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var bacVieww: UIView!
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var listTableHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowViewBottom: UIView!
    @IBOutlet weak var userNameTF: UITextField!
    let listArray = ["ADDRESS","PASSWORD","MY ORDERS","TRACK YOUR ORDER","PAYMENTS"]
    
    var imagePicker = UIImagePickerController()
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        setAppearance()
        
    }
    //MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.bacVieww.layer.cornerRadius = 30
            self.bacVieww.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.profileImage.cornerRadius = self.profileImage.frame.height/2
            
            self.imageBackView.cornerRadius = self.imageBackView.frame.height/2
            
            self.shadowViewBottom.cornerRadius = 30
            //           self.shadowViewBottom.layer.masksToBounds = true
            self.shadowViewBottom.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.scrollview.cornerRadius = 30
            self.scrollview.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            
        }
    }
    
    func openCamera(_ sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnPickImage(_ sender: UIButton) {
     
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
           let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default) {
               UIAlertAction in
               self.openCamera(UIImagePickerController.SourceType.camera)
           }
           let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertAction.Style.default) {
               UIAlertAction in
               self.openCamera(UIImagePickerController.SourceType.photoLibrary)
           }
           let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
               UIAlertAction in
           }

           // Add the actions
           imagePicker.delegate = self
           alert.addAction(cameraAction)
           alert.addAction(gallaryAction)
           alert.addAction(cancelAction)
           self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func btnUpdateProfile(_ sender: UIButton) {
        
        let kUserName = self.userNameTF.text ?? ""
        if kUserName.count < 1 {
            alert("ChappanBhog", message: "User name can't be empty.", view: self)
            return
        }
        
        guard let selectedImage = self.profileImage.image else {
            alert("ChappanBhog", message: "Please select profile image.", view: self)
            return
        }
        
        
        
        let updateProfileUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_update_profile
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        
        var params : [String: Any] = [:]
        params["user_id"] =  userID as Any
        params["name"] = kUserName as Any
        
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.uploadPhoto(updateProfileUrl, image: selectedImage, params: params, completion: { (dict) in
            IJProgressView.shared.hideProgressView()
              if let result = dict as? [String:Any]{
                          print(result)
                          
                        //  let message = result["message"] as? String ?? ""
                          let status = result["success"] as? Bool ?? false
                          
                          if status{
                              
                            
                          } else {
                              let msg = result["message"] as? String ?? "Some error Occured"
                              alert("ChappanBhog", message: msg, view: self)
                              
                          }
                      } else {
                          
                      }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert("ChappanBhog", message: error.description, view: self)
        }
        
    }
    
}
//MARK:- TABLEVIEW METHODS
extension MyAccountVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTable.dequeueReusableCell(withIdentifier: "MyAccountListTableCell") as! MyAccountListTableCell
        cell.nameLBL.text = listArray[indexPath.row]
        
        DispatchQueue.main.async {
            self.listTableHeight.constant = self.listTable.contentSize.height
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 1 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePasswordVC") as! UpdatePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if indexPath.row == 2 {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if indexPath.row == 3 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackYourOrderVC") as! TrackYourOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if indexPath.row == 4 {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

extension MyAccountVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
       
        self.profileImage.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         print("imagePickerController cancel")
     }
    
    
}

//TABLE CLASS
class MyAccountListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLBL:UILabel!
    
}
