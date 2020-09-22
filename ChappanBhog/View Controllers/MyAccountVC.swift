//
//  MyAccountVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
    @IBOutlet weak var imageBackView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var listTableHeight: NSLayoutConstraint!
    @IBOutlet weak var shadowViewBottom: UIView!
    let listArray = ["ADDRESS","PASSWORD","MY ORDERS","TRACK YOUR ORDER","PAYMENTS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setAppearance()
        
    }
    
    func setAppearance() {
        DispatchQueue.main.async {
              setGradientBackground(view: self.gradientView)
              self.backView.layer.cornerRadius = 30
              self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
//              setGradientBackground(view: self.profileImage)
              self.profileImage.cornerRadius = self.profileImage.frame.height/2
        
              self.imageBackView.cornerRadius = self.imageBackView.frame.height/2
            
            self.shadowViewBottom.cornerRadius = 30
           self.shadowViewBottom.layer.masksToBounds = true
            self.shadowViewBottom.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
          }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
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

//class
class MyAccountListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLBL:UILabel!
    
}
