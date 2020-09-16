//
//  ManageAddressVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class ManageAddressVC: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIToolbarDelegate {
    
    @IBOutlet weak var statesContainer: UIView!
    var statsView:StatesPopUpVC?
    var gradePicker: UIPickerView!
    
    let States = ["Telangana", "Punjab", "NewDelhi","Gujarath","HimachalPradesh"]
    
    
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
    
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            setShadowRadius(view: self.shadowView)
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
    
    @IBAction func stateTFAction(_ sender: UIButton) {
        self.view.bringSubviewToFront(statesContainer)
    }
    //MARK:- Segue
    
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
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addShippingAdressButtonClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func updateAddressButtonClicked(_ sender: UIButton) {
    }
}
