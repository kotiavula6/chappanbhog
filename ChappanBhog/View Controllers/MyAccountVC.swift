//
//  MyAccountVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import SDWebImage

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
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var lblPlusPlaceholder: UILabel!
    @IBOutlet weak var lblUploadPlaceholder: UILabel!
    
    var listArray = ["ADDRESS","PASSWORD","MY ORDERS","TRACK YOUR ORDER","PAYMENTS"]
    
    
    var imagePicker = UIImagePickerController()
    var selectedImage: UIImage?
    var isFromSideMenu = false
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        userNameTF.text = UserDefaults.standard.string(forKey: Constants.Name) ?? ""
        userNameTF.isUserInteractionEnabled = false
        setAppearance()
        
        let type = UserDefaults.standard.integer(forKey: Constants.type)
        
        if type != 0 {
            listArray.remove(at: 1)
            self.listTable.reloadData()
        }
        
        profileImage.contentMode = .scaleAspectFill
        let imageStr = UserDefaults.standard.string(forKey: Constants.Image) ?? ""
        visiablePlaceholder(isTrue: false)
        if !imageStr.isEmpty {
            let urlString = ApplicationUrl.IMAGE_BASE_URL + imageStr
            profileImage.sd_setImage(with: URL(string: urlString), completed: nil)
            visiablePlaceholder(isTrue: true)
            
        }
        
        // Check if its from tabbar
        if let controller = self.navigationController?.viewControllers.first, controller is UITabBarController {
            // For tabbar, Hide back button and load favourites
            btnBack.isHidden = true
        }
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setGradientBackground(view: self.gradientView)
    }
    
 
    //MARK:- FUNCTIONS
    func visiablePlaceholder(isTrue: Bool) {
        self.lblPlusPlaceholder.isHidden = isTrue
        self.lblUploadPlaceholder.isHidden = isTrue
    }
    
    
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.view.layoutIfNeeded()
          
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
        if isFromSideMenu {
            AppDelegate.shared.showHomeScreen()
        }
        
      //  self.navigationController?.popViewController(animated: true)
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
        
        if btnEdit.title(for: .normal) == "Edit" {
            btnEdit.setTitle("Save", for: .normal)
            userNameTF.isUserInteractionEnabled = true
            userNameTF.becomeFirstResponder()
            return
        }
        
        let kUserName = self.userNameTF.text ?? ""
        if kUserName.count < 1 {
            alert("ChhappanBhog", message: "Name can't be empty.", view: self)
            return
        }
        
       /* guard let selectedImage = self.profileImage.image else {
            alert("ChhappanBhog", message: "Please select profile image.", view: self)
            return
        } */
        
        
        let updateProfileUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_update_profile
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        
        var params : [String: Any] = [:]
        params["user_id"] =  userID
        params["name"] = kUserName
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.uploadPhoto(updateProfileUrl, image: selectedImage, params: params, completion: { (dict) in
            IJProgressView.shared.hideProgressView()
            if let result = dict as? [String:Any] {
                
                let isTokenExpired = AFWrapperClass.handle401Error(dict: result, self)
                if isTokenExpired {
                    return
                }
                                
                //  let message = result["message"] as? String ?? ""
                let status = result["success"] as? Bool ?? false
                if status {
                    DispatchQueue.main.async {
                        self.userNameTF.isUserInteractionEnabled = false
                        self.btnEdit.setTitle("Edit", for: .normal)
                    }
                    
                    if let data = result["data"] as? [String: Any] {
                        let msg = result["message"] as? String ?? "Successfully Updated"
                        let name = data["name"] as? String ?? ""
                        UserDefaults.standard.set(name, forKey: Constants.Name)
                        
                        // Save image locally to avoid downloading for uploaded image
                        if let image = self.selectedImage {
                            let imageStr = data["image"] as? String ?? ""
                             UserDefaults.standard.set(imageStr, forKey: Constants.Image)
                            SDImageCache.shared.store(image, forKey: ApplicationUrl.IMAGE_BASE_URL + imageStr, completion: nil)
                        }
                        
                        alert("ChhappanBhog", message: msg, view: self)
                    }
                    
                } else {
                    let msg = result["message"] as? String ?? "Some error Occured"
                    alert("ChhappanBhog", message: msg, view: self)
                }
            } else {
                          
                      }
        }) { (error) in
            IJProgressView.shared.hideProgressView()
            alert("ChhappanBhog", message: error.description, view: self)
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
        cell.selectionStyle = .none
        DispatchQueue.main.async {
            self.listTableHeight.constant = self.listTable.contentSize.height
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // ["ADDRESS","PASSWORD","MY ORDERS","TRACK YOUR ORDER","PAYMENTS"]
        let listName = listArray[indexPath.row]
        if listName == "ADDRESS" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ManageAddressVC") as! ManageAddressVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if listName == "PASSWORD" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UpdatePasswordVC") as! UpdatePasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if listName == "MY ORDERS" {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVC") as! MyOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if listName == "TRACK YOUR ORDER" {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "TrackYourOrderVC") as! TrackYourOrderVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        if listName == "PAYMENTS" {
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentVC") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

extension MyAccountVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        selectedImage = chosenImage
        self.profileImage.image = chosenImage
        visiablePlaceholder(isTrue: true)
        dismiss(animated:true, completion: nil)
    }
    
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         print("imagePickerController cancel")
        dismiss(animated:true, completion: nil)
     }
}

//TABLE CLASS
class MyAccountListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLBL:UILabel!
    
}
