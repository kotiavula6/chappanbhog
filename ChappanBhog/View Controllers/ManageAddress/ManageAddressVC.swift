//
//  ManageAddressVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class ManageAddressVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIToolbarDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var statesContainer: UIView!
    @IBOutlet weak var updateAddressBTN: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    var statsView:StatesPopUpVC?
    var gradePicker: UIPickerView!
    
    let States = ["Telangana", "Punjab", "NewDelhi","Gujarath","HimachalPradesh"]
    
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        gradePicker = UIPickerView()
        //
        //        gradePicker.dataSource = self
        //        gradePicker.delegate = self
        //
        //        stateTF.inputView = gradePicker
        //        stateTF.text = States[0]
        
        
        setAppearance()
        
    }
    //MARK:- FUCNTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            //   setShadowRadius(view: self.shadowView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.zipCodeTF.setLeftPaddingPoints(10)
            self.cityTF.setLeftPaddingPoints(10)
            self.stateTF.setLeftPaddingPoints(10)
            self.phoneNoTF.setLeftPaddingPoints(10)
            self.addressTF.setLeftPaddingPoints(10)
            self.nameTF.setLeftPaddingPoints(10)
            
            
        }
        
    }
    
    //MARK:- SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StatesPopUpVC"{
            
            statsView = segue.destination as? StatesPopUpVC
            //
            statsView?.closeButtonAction = {
                self.view.sendSubviewToBack(self.statesContainer)
            }
            statsView?.didSelectAction = {
                self.stateTF.text = self.statsView?.selctedState
                self.view.sendSubviewToBack(self.statesContainer)
                
            }
            
            
        }
    }
    
  //MARKK:- PICKERVIEW METHODS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return States.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return States[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        stateTF.text = States[row]
        self.view.endEditing(true)
    }
    
    //        @IBAction func stateTFAction(_ sender: UITextField) {
    //
    //
    //        }
    
    //MARK:- ACTIONS
    @IBAction func stateTFAction(_ sender: UIButton) {
        self.view.bringSubviewToFront(statesContainer)
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addShippingAdressButtonClicked(_ sender: UIButton) {
        
      
        
        
        
    }
    
    
    @IBAction func updateAddressButtonClicked(_ sender: UIButton) {
        
        let kZipCode = zipCodeTF.text ?? ""
        let kCity = cityTF.text ?? ""
        let kState = stateTF.text ?? ""
        let kPhone = phoneNoTF.text ?? ""
        let kAddress = addressTF.text ?? ""
        let kName = nameTF.text ?? ""
        
        if kName.count < 1 {
            alert("ChappanBhog", message: "Name can't be empty.", view: self)
            return
        }
        if kAddress.count < 1 {
            alert("ChappanBhog", message: "Address can't be empty.", view: self)
            return
        }
        if kPhone.count < 1 {
            alert("ChappanBhog", message: "Phone can't be empty.", view: self)
            return
        }
        if kCity.count < 1 {
            alert("ChappanBhog", message: "City can't be empty.", view: self)
            return
        }
        if kState.count < 1 {
            alert("ChappanBhog", message: "State can't be empty.", view: self)
            return
        }
        if kZipCode.count < 1 {
            alert("ChappanBhog", message: "Zip code can't be empty.", view: self)
            return
        }
        
        
        
        let addAddressUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_ADD_ADDRESS
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        
        var params : [String: Any] = [:]
        params["user_id"] =  userID as Any
        params["name"] = kName as Any
        params["address"] = kAddress as Any
        params["phone_number"] = kPhone as Any
        params["city"] = kCity as Any
        params["state"] = kState as Any
        params["zip"] = kZipCode as Any
        params["type"] = (0) as Any
        params["same_as_shipping"] = (false) as Any
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestPOSTURLWithHeader(addAddressUrl, params: params , success: { (dict) in
            IJProgressView.shared.hideProgressView()
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                return
            }
            
            print(dict)
            print(params)
            if let result = dict as? [String:Any]{
                print(result)
                
              //  let message = result["message"] as? String ?? ""
                let status = result["success"] as? Bool ?? false
                
                if status{
                    if result["data"] != nil{
                        
                        let responseData = result["data"] as! Dictionary<String, Any>
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: responseData , options: .prettyPrinted)
                            do {
                                let jsonDecoder = JSONDecoder()
                                let updatedData = try jsonDecoder.decode(UpdateAddressModel.self, from: jsonData)
                                print(updatedData)
                                let msg = result["message"] as? String ?? ""
                                //alert("ChappanBhog", message: msg, view: self)
                                showAlertMessage(title: "ChappanBhog", message: msg, okButton: "Ok", controller: self) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                            } catch {
                                print("Unexpected error: \(error).")
                                alert("ChappanBhog", message: error.localizedDescription, view: self)
                                
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            
                            alert("ChappanBhog", message: error.localizedDescription, view: self)
                        }
                        
                        
                        
                    }
                    else{
                        let msg = result["message"] as? String ?? "Some error Occured"
                        alert("ChappanBhog", message: msg, view: self)
                    }
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
