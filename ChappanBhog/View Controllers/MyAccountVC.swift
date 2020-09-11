//
//  MyAccountVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class MyAccountVC: UIViewController {
    
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
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            setGradientBackground(view: self.profileImage)
            self.profileImage.cornerRadius = self.profileImage.frame.height/2
            
            setShadowatBottom(view: self.shadowViewBottom, color: .black, shadowRadius: 5)
            
        }
        
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
    
    
}

//class
class MyAccountListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLBL:UILabel!
    
}
