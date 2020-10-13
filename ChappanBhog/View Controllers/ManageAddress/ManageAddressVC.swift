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
    
    @IBOutlet weak var zipCodeTFShipping: UITextField!
    @IBOutlet weak var cityTFShipping: UITextField!
    @IBOutlet weak var stateTFShipping: UITextField!
    @IBOutlet weak var phoneNoTFShipping: UITextField!
    @IBOutlet weak var addressTFShipping: UITextField!
    @IBOutlet weak var nameTFShipping: UITextField!
    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var btnAddShippingAddress: UIButton!
    @IBOutlet weak var shippingAddressContentView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var stateCityPicker: UIPickerView!
    
    var statsView:StatesPopUpVC?
    var gradePicker: UIPickerView!
    
   // let States = ["Telangana", "Punjab", "NewDelhi","Gujarath","HimachalPradesh"]
    var stateSelected = true
    
    var countryStateArr = [CountryStateModel]()
    var selectedCountry: CountryStateModel?
    var selectedStateArr = [States]()
    
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imgSelected.image = UIImage(named: "uncheck_box")
        self.updateAddressBTN.setTitle("UPDATE ADDRESS", for: .normal)
        self.shippingAddressContentView.isHidden = true
        self.pickerContainerView.isHidden = true
        self.stateCityPicker.delegate = self
        self.getCountryState()
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
            
            self.zipCodeTFShipping.setLeftPaddingPoints(10)
            self.cityTFShipping.setLeftPaddingPoints(10)
            self.stateTFShipping.setLeftPaddingPoints(10)
            self.phoneNoTFShipping.setLeftPaddingPoints(10)
            self.addressTFShipping.setLeftPaddingPoints(10)
            self.nameTFShipping.setLeftPaddingPoints(10)
            
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
        if stateSelected {
            return countryStateArr.count
        } else {
            return selectedStateArr.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if stateSelected {
            return countryStateArr[row].name ?? ""
        } else {
            return selectedStateArr[row].name ?? ""
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if stateSelected {
            if countryStateArr.count > 0 {
                self.selectedCountry = countryStateArr[row]
                stateTF.text = countryStateArr[row].name ?? ""
            }
            
        } else {
            if selectedStateArr.count > 0 {
                cityTF.text = selectedStateArr[row].name ?? ""
            }
            
        }
        
        self.view.endEditing(true)
    }
    
    //        @IBAction func stateTFAction(_ sender: UITextField) {
    //
    //
    //        }
    
    //MARK:- ACTIONS
    @IBAction func stateTFAction(_ sender: UIButton) {
       // self.view.bringSubviewToFront(statesContainer)
        if self.countryStateArr.count < 1 {
            return
        }
        self.self.stateCityPicker.reloadAllComponents()
        self.stateSelected = true
        self.pickerContainerView.isHidden = false
    }
    
    @IBAction func cityTFAction(_ sender: UIButton) {
        guard let countryAvailabel = self.selectedCountry else {
            // show alert
            return
            
        }
        self.selectedStateArr = countryAvailabel.states ?? []
        self.stateSelected = false
        self.self.stateCityPicker.reloadAllComponents()
        self.pickerContainerView.isHidden = false
      }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addShippingAdressButtonClicked(_ sender: UIButton) {
        self.updateAddressBTN.setTitle("ADD SHIPPING ADDRESS", for: .normal)
        self.shippingAddressContentView.isHidden = false
    }
    
    @IBAction func btnSameShipping(_ sender: UIButton) {
        self.updateAddressBTN.setTitle("UPDATE ADDRESS", for: .normal)
        if self.imgSelected.image == UIImage(named: "uncheck_box") {
            self.imgSelected.image = UIImage(named: "check_box")
            self.btnAddShippingAddress.isHidden = true
            self.shippingAddressContentView.isHidden = true
        } else {
            self.btnAddShippingAddress.isHidden = false
            self.imgSelected.image = UIImage(named: "uncheck_box")
        }
    }
    
    @IBAction func btnDonePickingStateCity(_ sender: UIBarButtonItem) {
        self.pickerContainerView.isHidden = true
    }
    
    
    
    
    
    @IBAction func updateAddressButtonClicked(_ sender: UIButton) {
        
        let kZipCode = zipCodeTF.text ?? ""
        let kCity = cityTF.text ?? ""
        let kState = stateTF.text ?? ""
        let kPhone = phoneNoTF.text ?? ""
        let kAddress = addressTF.text ?? ""
        let kName = nameTF.text ?? ""
        
        if kName.count < 1 {
            alert("ChhappanBhog", message: "Name can't be empty.", view: self)
            return
        }
        if kAddress.count < 1 {
            alert("ChhappanBhog", message: "Address can't be empty.", view: self)
            return
        }
        if kPhone.count < 1 {
            alert("ChhappanBhog", message: "Phone can't be empty.", view: self)
            return
        }
        if kCity.count < 1 {
            alert("ChhappanBhog", message: "City can't be empty.", view: self)
            return
        }
        if kState.count < 1 {
            alert("ChhappanBhog", message: "State can't be empty.", view: self)
            return
        }
        if kZipCode.count < 1 {
            alert("ChhappanBhog", message: "Zip code can't be empty.", view: self)
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
                                //alert("ChhappanBhog", message: msg, view: self)
                                showAlertMessage(title: "ChhappanBhog", message: msg, okButton: "Ok", controller: self) {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                
                            } catch {
                                print("Unexpected error: \(error).")
                                alert("ChhappanBhog", message: error.localizedDescription, view: self)
                                
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                            
                            alert("ChhappanBhog", message: error.localizedDescription, view: self)
                        }
                        
                        
                        
                    }
                    else{
                        let msg = result["message"] as? String ?? "Some error Occured"
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
    
    
    func getCountryState() {
        
        
        
          let countryUrl = "https://www.chhappanbhog.com/wp-json/wc/v3/data/countries?consumer_key=ck_f8fb349b9f8885516ac6cddfb8b26426315d0469&consumer_secret=cs_abf949b0f1a187b60829ee1e78c905c5397e95ff"
          
         // IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURLWithoutToken(countryUrl, success: { (dict) in
          //  IJProgressView.shared.hideProgressView()
                        
                       
                        
                        print(dict)
              
                        if let result = dict as? [Dictionary<String, Any>]{
                            print(result)
                          do {
                              let jsonData = try JSONSerialization.data(withJSONObject: result , options: .prettyPrinted)
                              do {
                                  let jsonDecoder = JSONDecoder()
                                  let countryStateObj = try jsonDecoder.decode([CountryStateModel].self, from: jsonData)
                                self.countryStateArr = countryStateObj
                                self.stateCityPicker.reloadAllComponents()
                                  print(countryStateObj)
                              }  catch {
                                  print("Unexpected error: \(error).")
                                  alert("ChhappanBhog", message: error.localizedDescription, view: self)
                                  
                              }
                              
                          } catch {
                              print("Unexpected error: \(error).")
                              
                          }
                          
                          
                        } else {
                            
                        }
        }) { (error) in
           // IJProgressView.shared.hideProgressView()
             print("Unexpected error: \(error).")
        }
             
          
          
    }
}

