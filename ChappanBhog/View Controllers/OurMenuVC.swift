//
//  OurMenuVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class OurMenuVC: UIViewController {

    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var backView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.menuTable.layer.cornerRadius = 30
                      self.menuTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
                      
            
            
        }
        
        
    }
    

  

}
extension OurMenuVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTable.dequeueReusableCell(withIdentifier: "OurMenuTableCell") as! OurMenuTableCell
        
        return cell
    }
    
  
}

//class
class OurMenuTableCell: UITableViewCell {
    @IBOutlet weak var menuIMG:UIImageView!
    override func awakeFromNib() {
        
    }
    
}
