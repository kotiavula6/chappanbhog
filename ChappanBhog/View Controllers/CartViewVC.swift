//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CartViewVC: UIViewController {

    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cartLBL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            
//            subTitleView
             self.subTitleView.layer.cornerRadius = 30
              self.subTitleView.layer.masksToBounds = true
              self.subTitleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.cornerRadius = self.cartLBL.frame.height/2
            self.cartLBL.layer.masksToBounds = true
     
            
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func increaseButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func decreseButtonClicked(_ sender: UIButton) {
    }
    
}
extension CartViewVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
}
