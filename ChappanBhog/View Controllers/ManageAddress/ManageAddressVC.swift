//
//  ManageAddressVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit
import CoreLocation

class ManageAddressVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIToolbarDelegate {
    
    //MARK:- OUTLETS
    @IBOutlet weak var statesContainer: UIView!
    @IBOutlet weak var updateAddressBTN: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    
    @IBOutlet weak var zipCodeTF: UITextField!
    @IBOutlet weak var cityTF:    UITextField!
    @IBOutlet weak var stateTF:   UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var phoneNoTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    @IBOutlet weak var houseTF:    UITextField!
    @IBOutlet weak var nameTF:    UITextField!
    
    @IBOutlet weak var zipCodeTFShipping: UITextField!
    @IBOutlet weak var cityTFShipping: UITextField!
    @IBOutlet weak var stateTFShipping: UITextField!
    @IBOutlet weak var countryTFShipping: UITextField!
    @IBOutlet weak var phoneNoTFShipping: UITextField!
    @IBOutlet weak var addressTFShipping: UITextField!
    @IBOutlet weak var houseTFShipping:    UITextField!
    @IBOutlet weak var nameTFShipping: UITextField!
    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var btnAddShippingAddress: UIButton!
    @IBOutlet weak var billingAddressContentView: UIView!
    @IBOutlet weak var pickerContainerView: UIView!
    @IBOutlet weak var stateCityPicker: UIPickerView!
    
    var statsView:StatesPopUpVC?
    var gradePicker: UIPickerView!
    
   // let States = ["Telangana", "Punjab", "NewDelhi","Gujarath","HimachalPradesh"]
    var stateSelected = true
    
    var selectedCountry: CountryStateModel?
    var selectedStateArr = [States]()
    var shippingAddressSelected = false
    
    var manageAddress: ManageAddress = ManageAddress(dict: [:])
    var needToFetchCurrentAddress: Bool = false
    var shippingPlacemark: CLPlacemark?
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // nameTF.placeholder = "Name"
        // nameTFShipping.placeholder = "Name"
        
        self.imgSelected.image = UIImage(named: "uncheck_box")
        self.updateAddressBTN.setTitle("UPDATE ADDRESS", for: .normal)
        self.billingAddressContentView.isHidden = true
        self.pickerContainerView.isHidden = true
        self.stateCityPicker.delegate = self
        
//        CartHelper.shared.syncCountries { (success, msg) in
//            DispatchQueue.main.async {
//                self.stateCityPicker.reloadAllComponents()
//            }
//        }
        
        //        gradePicker = UIPickerView()
        //
        //        gradePicker.dataSource = self
        //        gradePicker.delegate = self
        //
        //        stateTF.inputView = gradePicker
        //        stateTF.text = States[0]
        
        
        setAppearance()
        showShippingAddress(true)
        
        cityTF.autocapitalizationType = .words
        cityTFShipping.autocapitalizationType = .words
        nameTF.autocapitalizationType = .words
        nameTFShipping.autocapitalizationType = .words
        addressTF.autocapitalizationType = .words
        addressTFShipping.autocapitalizationType = .words
        phoneNoTF.keyboardType = .phonePad
        phoneNoTFShipping.keyboardType = .phonePad
        
        IJProgressView.shared.showProgressView()
        CartHelper.shared.syncAddress { (success, message) in
            IJProgressView.shared.hideProgressView()
            self.manageAddress = CartHelper.shared.manageAddress
            
            // Bind data
            self.bindData()
            
            if self.manageAddress.shipping_zip.isEmpty {
                self.showAlertWithTitle(title: "", message: "Would you like to update your shipping address to you current location?", okButton: "Yes", cancelButton: "No", okSelectorName: #selector(self.performCurrentLocation))
            }
        }
        /*getAddress {
            IJProgressView.shared.hideProgressView()
            // Bind data
            self.bindData()
        }*/
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(locationDidUpdate(_:)), name: NSNotification.Name(rawValue: "kLocationUpdate"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK:- FUCNTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            //   setShadowRadius(view: self.shadowView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
            self.zipCodeTF.setLeftPaddingPoints(10)
            self.cityTF.setLeftPaddingPoints(10)
            self.countryTF.setLeftPaddingPoints(10)
            self.stateTF.setLeftPaddingPoints(10)
            self.phoneNoTF.setLeftPaddingPoints(10)
            self.addressTF.setLeftPaddingPoints(10)
            self.houseTF.setLeftPaddingPoints(10)
            self.nameTF.setLeftPaddingPoints(10)
            
            self.zipCodeTFShipping.setLeftPaddingPoints(10)
            self.cityTFShipping.setLeftPaddingPoints(10)
            self.stateTFShipping.setLeftPaddingPoints(10)
            self.countryTFShipping.setLeftPaddingPoints(10)
            self.phoneNoTFShipping.setLeftPaddingPoints(10)
            self.houseTFShipping.setLeftPaddingPoints(10)
            self.addressTFShipping.setLeftPaddingPoints(10)
            self.nameTFShipping.setLeftPaddingPoints(10)
            
        }
        
    }
    
    func bindData() {
        DispatchQueue.main.async {
            self.zipCodeTF.text = self.manageAddress.zip
            self.cityTF.text = self.manageAddress.city
            
            // self.manageAddress.state = self.manageAddress.state.parseHTML()
            self.stateTF.text = self.manageAddress.state
            // self.manageAddress.country = self.manageAddress.country.parseHTML()
            self.countryTF.text = self.manageAddress.country
            
            self.phoneNoTF.text = self.manageAddress.phone
            self.houseTF.text = self.manageAddress.house_no
            self.addressTF.text = self.manageAddress.address
            self.nameTF.text = self.manageAddress.name
            
            self.zipCodeTFShipping.text = self.manageAddress.shipping_zip
            self.cityTFShipping.text = self.manageAddress.shipping_city
            
            // self.manageAddress.shipping_state = self.manageAddress.shipping_state.parseHTML()
            self.stateTFShipping.text = self.manageAddress.shipping_state
            // self.manageAddress.shipping_country = self.manageAddress.shipping_country.parseHTML()
            self.countryTFShipping.text = self.manageAddress.shipping_country
            
            self.phoneNoTFShipping.text = self.manageAddress.shipping_phone_number
            self.addressTFShipping.text = self.manageAddress.shipping_address
            self.houseTFShipping.text = self.manageAddress.shipping_house_no
            self.nameTFShipping.text = self.manageAddress.shipping_name
            
            self.showShippingAddress(self.manageAddress.same_as_shipping)
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
            return CartHelper.shared.countryStateArr.count
        } else {
            return selectedStateArr.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if stateSelected {
            /*if !CartHelper.shared.countryStateArr[row].parsed {
                CartHelper.shared.countryStateArr[row].parsed = true
                CartHelper.shared.countryStateArr[row].name = CartHelper.shared.countryStateArr[row].name.parseHTML()
            }*/
            return CartHelper.shared.countryStateArr[row].name
        } else {
            /*if !selectedStateArr[row].parsed {
                selectedStateArr[row].parsed = true
                selectedStateArr[row].name = selectedStateArr[row].name.parseHTML()
            }*/
            return selectedStateArr[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        if stateSelected {
//            if CartHelper.shared.countryStateArr.count > 0 {
//                self.selectedCountry = CartHelper.shared.countryStateArr[row]
//                if self.shippingAddressSelected {
//                    countryTFShipping.text = CartHelper.shared.countryStateArr[row].name
//                } else {
//                    countryTF.text = CartHelper.shared.countryStateArr[row].name
//                }
//            }
//        } else {
//            if selectedStateArr.count > 0 {
//                if self.shippingAddressSelected {
//                    stateTFShipping.text = selectedStateArr[row].name
//                } else{
//                    stateTF.text = selectedStateArr[row].name
//                }
//            }
//        }
//
//        self.view.endEditing(true)
    }
    
    //        @IBAction func stateTFAction(_ sender: UITextField) {
    //
    //
    //        }
    
    func showShippingAddress(_ show: Bool) {
        if !show {
            self.imgSelected.image = UIImage(named: "uncheck_box")
            self.btnAddShippingAddress.isHidden = true
            self.billingAddressContentView.isHidden = false
        }
        else {
            self.imgSelected.image = UIImage(named: "check_box")
            self.btnAddShippingAddress.isHidden = false
            self.billingAddressContentView.isHidden = true
        }
    }
    
    func resignAll() {
        zipCodeTF.resignFirstResponder()
        cityTF.resignFirstResponder()
        phoneNoTF.resignFirstResponder()
        addressTF.resignFirstResponder()
        nameTF.resignFirstResponder()
        
        zipCodeTFShipping.resignFirstResponder()
        cityTFShipping.resignFirstResponder()
        phoneNoTFShipping.resignFirstResponder()
        addressTFShipping.resignFirstResponder()
        nameTFShipping.resignFirstResponder()
    }
    
    @objc func performCurrentLocation() {
        // Check for location
        let status = AppDelegate.shared.canTrackLocation()
        if !status.canTrack {
            // We don't have location permission
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                showAlertWithTitle(title: "\"ChhappanBhog\" Would Like to Access the Location", message: "Location is needed to get your current location.", okButton: "Open Settings", cancelButton: "Cancel", okSelectorName: #selector(openLocationSettings))
            }
            else {
                // Can not open settings url, so just show a simple alert
                alert("\"ChhappanBhog\" Would Like to Access the Location", message: "", view: self)
            }
            return
        }
        
        // Get current location
        if let currentLocation = AppDelegate.shared.currentLocation {
            // We already have current location, Just fetch the address
            fetchAddress(location: currentLocation)
        }
        else {
            // We need to fetch the current location
            needToFetchCurrentAddress = true
        }
    }
    
    @objc func openLocationSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
        }
    }
    
    @objc
    func locationDidUpdate(_ notification: NSNotification) {
        if let currentLocation = AppDelegate.shared.currentLocation {
            // fetchAddress(location: currentLocation)
        }
    }
    
    @objc func fetchAddress(location: CLLocation) {
        IJProgressView.shared.showProgressView()
        AppDelegate.shared.getPlaceMark(location) { (placemark) in
            if let placemark = placemark {
                self.shippingPlacemark = placemark
                self.zipCodeTFShipping.text = placemark.postalCode ?? ""
                self.cityTFShipping.text = placemark.locality ?? ""
                self.addressTFShipping.text = AppDelegate.shared.getAddress(placeMark: placemark)
                
                let state = placemark.administrativeArea ?? ""
                self.stateTFShipping.text = state
                
                let country = placemark.country ?? ""
                self.countryTFShipping.text = country
                
                if !state.isEmpty && !country.isEmpty {
                    // Placemark fetchs state code instead if state name
                    let countryCode = CartHelper.shared.countryCodeFromName(country)
                    self.stateTFShipping.text = CartHelper.shared.stateNameFromCode(countryCode: countryCode, state)
                }
            }
            IJProgressView.shared.hideProgressView()
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func currentLoctionAction(_ sender: UIButton) {
        performCurrentLocation()
    }
    
    @IBAction func countryTFAction(_ sender: UIButton) {
       // self.view.bringSubviewToFront(statesContainer)
        if CartHelper.shared.countryStateArr.count < 1 {
            return
        }
        
        self.shippingAddressSelected = false
        self.stateSelected = true
        self.stateCityPicker.reloadAllComponents()
        //self.stateCityPicker.selectRow(0, inComponent: 0, animated: false)
        
        /*if let currentCountry = countryTF.text {
            if let index = CartHelper.shared.countryStateArr.firstIndex(where: {$0.name.lowercased() == currentCountry.lowercased()}) {
                self.stateCityPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }*/
        
        self.pickerContainerView.isHidden = false
        resignAll()
    }
    
    @IBAction func stateTFAction(_ sender: UIButton) {
        
        /*if !self.manageAddress.country.isEmpty && CartHelper.shared.countryStateArr.count > 0 && self.selectedCountry == nil {
            let result = CartHelper.shared.countryStateArr.filter {$0.name.lowercased() ==  self.manageAddress.country.lowercased()}
            if let first = result.first {
                self.selectedCountry = first
            }
        }*/
        
        let country = self.countryTF.text ?? ""
        if !country.isEmpty && CartHelper.shared.countryStateArr.count > 0 {
            let result = CartHelper.shared.countryStateArr.filter {$0.name.lowercased() ==  country.lowercased()}
            if let first = result.first {
                self.selectedCountry = first
            }
        }
        
        guard let countryAvailabel = self.selectedCountry else {
            // show alert
            return
        }
        
        self.shippingAddressSelected = false
        self.selectedStateArr = countryAvailabel.states
        self.stateSelected = false
        self.stateCityPicker.reloadAllComponents()
        //self.stateCityPicker.selectRow(0, inComponent: 0, animated: false)
        
        /*if let currentState = stateTF.text {
            if let index = countryAvailabel.states.firstIndex(where: {$0.name.lowercased() == currentState.lowercased()}) {
                self.stateCityPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }*/
        
        self.pickerContainerView.isHidden = false
        resignAll()
    }
    
    
    @IBAction func shippingCountryTFAction(_ sender: UIButton) {
        // self.view.bringSubviewToFront(statesContainer)
        if CartHelper.shared.countryStateArr.count < 1 {
            return
        }
        self.shippingPlacemark = nil
        self.shippingAddressSelected = true
        self.stateSelected = true
        self.stateCityPicker.reloadAllComponents()
        //self.stateCityPicker.selectRow(0, inComponent: 0, animated: false)
        
        /*if let currentCountry = countryTFShipping.text {
            if let index = CartHelper.shared.countryStateArr.firstIndex(where: {$0.name.lowercased() == currentCountry.lowercased()}) {
                self.stateCityPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }*/
        
        self.pickerContainerView.isHidden = false
        resignAll()
    }
      
    @IBAction func shippingStateTFAction(_ sender: UIButton) {
        
        /*if !self.manageAddress.country.isEmpty && CartHelper.shared.countryStateArr.count > 0 && self.selectedCountry == nil {
            let result = CartHelper.shared.countryStateArr.filter {$0.name.lowercased() ==  self.manageAddress.shipping_country.lowercased()}
            if let first = result.first {
                self.selectedCountry = first
            }
        }*/
        
        let country = self.countryTFShipping.text ?? ""
        if !country.isEmpty && CartHelper.shared.countryStateArr.count > 0 {
            let result = CartHelper.shared.countryStateArr.filter {$0.name.lowercased() ==  country.lowercased()}
            if let first = result.first {
                self.selectedCountry = first
            }
        }
        
        guard let countryAvailabel = self.selectedCountry else {
            // show alert
            return
        }
        
        self.shippingPlacemark = nil
        self.shippingAddressSelected = true
        self.selectedStateArr = countryAvailabel.states
        self.stateSelected = false
        self.stateCityPicker.reloadAllComponents()
        //self.stateCityPicker.selectRow(0, inComponent: 0, animated: false)
        
        /*if let currentState = stateTFShipping.text {
            if let index = countryAvailabel.states.firstIndex(where: {$0.name.lowercased() == currentState.lowercased()}) {
                self.stateCityPicker.selectRow(index, inComponent: 0, animated: false)
            }
        }*/
        
        self.pickerContainerView.isHidden = false
        resignAll()
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addShippingAdressButtonClicked(_ sender: UIButton) {
       // self.updateAddressBTN.setTitle("ADD SHIPPING ADDRESS", for: .normal)
       // self.billingAddressContentView.isHidden = false
        showShippingAddress(false)
    }
    
    @IBAction func btnSameShipping(_ sender: UIButton) {
        //self.updateAddressBTN.setTitle("UPDATE ADDRESS", for: .normal)
        if self.imgSelected.image == UIImage(named: "uncheck_box") {
            showShippingAddress(true)
        } else {
            showShippingAddress(false)
        }
    }
    
    @IBAction func btnDonePickingStateCity(_ sender: UIBarButtonItem) {
        self.pickerContainerView.isHidden = true
        performPickerDone()
        
       //  pickerView(stateCityPicker, didSelectRow: stateCityPicker.selectedRow(inComponent: 0), inComponent: 0)
    }
    
    func performPickerDone() {
        let row = stateCityPicker.selectedRow(inComponent: 0)
        if stateSelected {
            if CartHelper.shared.countryStateArr.count > 0 {
                self.selectedCountry = CartHelper.shared.countryStateArr[row]
                if self.shippingAddressSelected {
                    countryTFShipping.text = CartHelper.shared.countryStateArr[row].name
                } else {
                    countryTF.text = CartHelper.shared.countryStateArr[row].name
                }
            }
        } else {
            if selectedStateArr.count > 0 {
                if self.shippingAddressSelected {
                    stateTFShipping.text = selectedStateArr[row].name
                } else{
                    stateTF.text = selectedStateArr[row].name
                }
            }
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func btnCancelStateCity(_ sender: UIBarButtonItem) {
        self.pickerContainerView.isHidden = true
    }

    @IBAction func updateAddressButtonClicked(_ sender: UIButton) {
        
        let kZipCodeShipping = zipCodeTFShipping.text ?? ""
        var kCountryShipping = countryTFShipping.text ?? ""
        let kCityShipping = cityTFShipping.text ?? ""
        var kStateShipping = stateTFShipping.text ?? ""
        let kPhoneShipping = phoneNoTFShipping.text ?? ""
        let kAddressShipping = addressTFShipping.text ?? ""
        let kHouseNoShipping = houseTFShipping.text ?? ""
        let kNameShipping = nameTFShipping.text ?? ""
        
        if kNameShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping name can't be empty.", view: self)
            return
        }
        if kHouseNoShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping house no. can't be empty.", view: self)
            return
        }
        if kAddressShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping address can't be empty.", view: self)
            return
        }
        if kPhoneShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping phone can't be empty.", view: self)
            return
        }
        if kPhoneShipping.count != 10 {
            alert("ChhappanBhog", message: "Please enter valid phone number.", view: self)
            return
        }
        if kCountryShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping country can't be empty.", view: self)
            return
        }
        if kStateShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping state can't be empty.", view: self)
            return
        }
        if kCityShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping city can't be empty.", view: self)
            return
        }
        if kZipCodeShipping.count < 1 {
            alert("ChappanBhog", message: "Shipping zip code can't be empty.", view: self)
            return
        }
        
                
        let kZipCode = zipCodeTF.text ?? ""
        var kCountry = countryTF.text ?? ""
        let kCity = cityTF.text ?? ""
        var kState = stateTF.text ?? ""
        let kPhone = phoneNoTF.text ?? ""
        let kAddress = addressTF.text ?? ""
        let kHouseNo = houseTF.text ?? ""
        let kName = nameTF.text ?? ""

        let sameAsShipping = self.imgSelected.image == UIImage(named: "check_box")
        if !sameAsShipping {
            // Need to add billing address data as well
            if kName.count < 1 {
                alert("ChhappanBhog", message: "Billing name can't be empty.", view: self)
                return
            }
            if kHouseNo.count < 1 {
                alert("ChhappanBhog", message: "Billing house no. can't be empty.", view: self)
                return
            }
            if kAddress.count < 1 {
                alert("ChhappanBhog", message: "Billing address can't be empty.", view: self)
                return
            }
            if kPhone.count < 1 {
                alert("ChhappanBhog", message: "Billing phone can't be empty.", view: self)
                return
            }
            if kPhone.count != 10 {
                alert("ChhappanBhog", message: "Please enter valid phone number.", view: self)
                return
            }
            
            if kCountry.count < 1 {
                alert("ChhappanBhog", message: "Billing country can't be empty.", view: self)
                return
            }
            if kState.count < 1 {
                alert("ChhappanBhog", message: "Billing state can't be empty.", view: self)
                return
            }
            if kCity.count < 1 {
                alert("ChhappanBhog", message: "Billing city can't be empty.", view: self)
                return
            }
            if kZipCode.count < 1 {
                alert("ChhappanBhog", message: "Billing zip code can't be empty.", view: self)
                return
            }
            
        }
        
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId)
        var params : [String: Any] = [:]
        params["user_id"] =  userID
        
        kCountryShipping = CartHelper.shared.countryCodeFromName(kCountryShipping)
        kStateShipping = CartHelper.shared.stateCodeFromName(kStateShipping)
        
        if let location = AppDelegate.shared.currentLocation, let placemark = shippingPlacemark {
            params["shipping_latitude"]  = String(format: "%.6f", location.coordinate.latitude)
            params["shipping_longitude"] = String(format: "%.6f", location.coordinate.longitude)
        }
        
        params["same_as_shipping"] = "0"
        params["shipping_name"] = kNameShipping
        params["shipping_house_no"] = kHouseNoShipping
        params["shipping_address"] = kAddressShipping
        params["shipping_phone_number"] = kPhoneShipping
        params["shipping_country"] = kCountryShipping
        params["shipping_city"] = kCityShipping
        params["shipping_state"] = kStateShipping
        params["shipping_zip"] = kZipCodeShipping
        
        if !sameAsShipping {
            // add billing params
            kCountry = CartHelper.shared.countryCodeFromName(kCountry)
            kState = CartHelper.shared.stateCodeFromName(kState)
            
            params["name"] = kName
            params["house_no"] = kHouseNo
            params["address"] = kAddress
            params["phone_number"] = kPhone
            params["country"] = kCountry
            params["city"] = kCity
            params["state"] = kState
            params["zip"] = kZipCode
            
        } else {
            params["same_as_shipping"] = "1"
        }
        
        params["version"] = "v2"
        print(params)
        IJProgressView.shared.showProgressView()
        saveAddress(params: params) {
            IJProgressView.shared.hideProgressView()
        }
    }
}


// MARK:- APIs
extension ManageAddressVC {
    
    func getAddress(completion: @escaping () -> Void) {
        let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_ADDRESS
        AFWrapperClass.requestGETURL(url, success: { (response) in
            if let dict = response as? [String: Any] {
                let success = dict["success"] as? Bool ?? false
                if success {
                    let data = dict["data"] as? [String: Any] ?? [:]
                    self.manageAddress.setDict(data)
                    self.manageAddress.updateToLocal()
                }
                else {
                    let message = dict["message"] as? String ?? "Some error occured"
                    alert("ChhappanBhog", message: message, view: self)
                }
            }
            completion()
        }) { (error) in
            alert("ChhappanBhog", message: error.description, view: self)
            completion()
        }
    }
    
    func saveAddress(params: [String: Any], completion: @escaping () -> Void) {
        let addAddressUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_ADD_ADDRESS
        AFWrapperClass.requestPOSTURLWithHeader(addAddressUrl, params: params , success: { (dict) in
            
            let isTokenExpired = AFWrapperClass.handle401Error(dict: dict, self)
            if isTokenExpired {
                completion()
                return
            }
        
            //print(dict)
            let status = dict["success"] as? Bool ?? false
            if status {
                
                let data = dict["data"] as? [String: Any] ?? [:]
                CartHelper.shared.manageAddress.setDict(data)
                CartHelper.shared.manageAddress.updateToLocal()
                
                let msg = dict["message"] as? String ?? "Successfully updated!"
                showAlertMessage(title: "ChhappanBhog", message: msg, okButton: "Ok", controller: self) {
                    self.navigationController?.popViewController(animated: true)
                }
                
                /*if dict["data"] != nil {
                    
                    let responseData = dict["data"] as! Dictionary<String, Any>
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: responseData , options: .prettyPrinted)
                        do {
                            let jsonDecoder = JSONDecoder()
                            let updatedData = try jsonDecoder.decode(UpdateAddressModel.self, from: jsonData)
                            let msg = dict["message"] as? String ?? ""
                            showAlertMessage(title: "ChhappanBhog", message: msg, okButton: "Ok", controller: self) {
                                self.navigationController?.popViewController(animated: true)
                            }
                            
                        } catch {
                            alert("ChhappanBhog", message: error.localizedDescription, view: self)
                        }
                    } catch {
                        alert("ChhappanBhog", message: error.localizedDescription, view: self)
                    }
                }
                else{
                    let msg = dict["message"] as? String ?? "Some error Occured"
                    alert("ChhappanBhog", message: msg, view: self)
                }*/
            } else {
                let msg = dict["message"] as? String ?? "Some error Occured"
                alert("ChhappanBhog", message: msg, view: self)
            }
            completion()
        }) { (error) in
            alert("ChhappanBhog", message: error.description, view: self)
            completion()
        }
    }
}

// MARK:- Address  Model
class ManageAddress: NSObject {
    var user_id = ""
    var name = ""
    var email = ""
    var phone = ""
    var type = ""
    var image = ""
    var city = ""
    var state = ""
    var zip = ""
    var house_no = ""
    var address = ""
    var phone_number = ""
    var country = ""
    var shipping_phone_number = ""
    var shipping_city = ""
    var shipping_state = ""
    var shipping_zip = ""
    var shipping_house_no = ""
    var shipping_address = ""
    var shipping_country = ""
    var shipping_name = ""
    var shipping_latitude = ""
    var shipping_longitude = ""
    var same_as_shipping: Bool = true
    
    var fullShippingAddress: String {
        var str = ""
        if !shipping_house_no.isEmpty {
            str = self.shipping_house_no
        }
        if !shipping_address.isEmpty {
            str = self.shipping_address
        }
        if !self.shipping_city.isEmpty {
            str.append(", \(self.shipping_city)")
        }
        if !self.shipping_state.isEmpty {
            str.append(", \(self.shipping_state)")
        }
        if !self.shipping_zip.isEmpty {
            str.append(", \(self.shipping_zip)")
        }
        if !self.shipping_country.isEmpty {
            str.append(", \(self.shipping_country)")
        }
        return str
    }
    
    var firstName: String {
        let components = name.components(separatedBy: " ")
        return (components.first ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var lastName: String {
        let components = name.components(separatedBy: " ")
        return (components.last ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(dict: [String: Any]) {
        super.init()
        setDict(dict)
    }
    
    func reset() {
        user_id = ""
        name = ""
        email = ""
        phone = ""
        type = ""
        image = ""
        city = ""
        state = ""
        zip = ""
        house_no = ""
        address = ""
        phone_number = ""
        country = ""
        shipping_phone_number = ""
        shipping_city = ""
        shipping_state = ""
        shipping_zip = ""
        shipping_house_no = ""
        shipping_address = ""
        shipping_country = ""
        shipping_name = ""
        shipping_latitude = ""
        shipping_longitude = ""
        same_as_shipping = true
    }
    
    func setDict(_ dict: [String: Any]) {
        reset()
        if let value = dict["user_id"] as? Int { user_id = "\(value)"}
        else if let value = dict["user_id"] as? String { user_id = value}
        
        if let value = dict["name"] as? String  { name  = value}
        if let value = dict["email"] as? String { email = value}
        if let value = dict["phone"] as? String { phone = value}
        if let value = dict["type"] as? String  { type  = value}
        if let value = dict["image"] as? String { image = value}
        if let value = dict["city"] as? String  { city  = value}
        if let value = dict["state"] as? String { state = value}
        
        if let value = dict["zip"] as? Int { zip = "\(value)"}
        else if let value = dict["zip"] as? String { zip = value}
        
        if let value = dict["address"] as? String                { address               = value}
        if let value = dict["house_no"] as? String               { house_no               = value}
        if let value = dict["phone_number"] as? String           { phone_number          = value}
        if let value = dict["country"] as? String                { country               = value}
        if let value = dict["shipping_phone_number"] as? String  { shipping_phone_number = value}
        if let value = dict["shipping_city"] as? String          { shipping_city         = value}
        if let value = dict["shipping_state"] as? String         { shipping_state        = value}
        
        if let value = dict["shipping_zip"] as? Int { shipping_zip = "\(value)"}
        else if let value = dict["shipping_zip"] as? String { shipping_zip = value}
        
        if let value = dict["shipping_house_no"] as? String { shipping_house_no = value}
        if let value = dict["shipping_address"] as? String  { shipping_address = value}
        if let value = dict["shipping_country"] as? String  { shipping_country = value}
        if let value = dict["shipping_name"] as? String     { shipping_name    = value}
        
        if let value = dict["shipping_latitude"] as? Double { shipping_latitude = "\(value)"}
        else if let value = dict["shipping_latitude"] as? String { shipping_latitude = value}
        
        if let value = dict["shipping_latitude"] as? Double { shipping_latitude = "\(value)"}
        else if let value = dict["shipping_latitude"] as? String { shipping_latitude = value}
        
        if let value = dict["shipping_longitude"] as? Int { shipping_longitude = "\(value)"}
        else if let value = dict["shipping_longitude"] as? String { shipping_longitude = value}
        
        let shipping = dict["same_as_shipping"] as? String ?? "1"
        self.same_as_shipping = shipping == "0" ? false : true
    }
    
    func updateToLocal() {
        // We get code from server
        // Update them with names
        let stateName = CartHelper.shared.stateNameFromCode(countryCode: self.country, self.state)
        if !stateName.isEmpty { self.state = stateName }
        
        let shippingStateName = CartHelper.shared.stateNameFromCode(countryCode: self.shipping_country, self.shipping_state)
        if !shippingStateName.isEmpty { self.shipping_state = shippingStateName }
        
        let countryName = CartHelper.shared.countryNameFromCode(self.country)
        if !countryName.isEmpty { self.country = countryName }
        
        let shippingCountryName = CartHelper.shared.countryNameFromCode(self.shipping_country)
        if !shippingCountryName.isEmpty { self.shipping_country = shippingCountryName }
    }
}
