//
//  MyOrderVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 10/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class MyOrderVC: UIViewController {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var myOrdersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            
        }
        
        
    }
    


}

extension MyOrderVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myOrdersTable.dequeueReusableCell(withIdentifier: "MyordreTableCell") as! MyordreTableCell
        
        return cell
    }
    
    
}


//Tableview cell
class MyordreTableCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
    
    override func awakeFromNib() {
        setShadowRadius(view: shadowView)
    }
    
}
