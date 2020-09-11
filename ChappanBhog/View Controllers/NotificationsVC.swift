//
//  NotificationsVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {

    var listArray = ["Stories are, perhaps, the","best way to teach life ","ou can teach them","the values and morals ","without being preachy","some short moral stories f","kids to enjoy the story"]
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var notificationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.notificationsTable.layer.cornerRadius = 30
            self.notificationsTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
   
            
        }
    }
    

}
extension NotificationsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTable.dequeueReusableCell(withIdentifier: "NotificationListTableCell") as! NotificationListTableCell
        cell.nameLBL.text = listArray[indexPath.row]
        if indexPath.row == 0 {
            
        }else {
            cell.newWidthConstraint.constant = 0
        }
        return cell
    }
    
  
}

class NotificationListTableCell: UITableViewCell {
    
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var newWidthConstraint: NSLayoutConstraint!
    
}

