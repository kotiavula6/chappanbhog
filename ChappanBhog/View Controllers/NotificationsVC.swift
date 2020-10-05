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
    
    //MARK:- OUTLETS
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var notificationsTable: UITableView!
    
    var notificationDataArr = [NotificationModel]()
    
    //MARK:- APPLICAION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAppearance()
        getNotifications()
    }
    
    
    
    
    func getNotifications() {
        
        
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        let notificationUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_notification + "/\(userID)?page=1"
        
        
        IJProgressView.shared.showProgressView()
        AFWrapperClass.requestGETURL(notificationUrl, success: { (dict) in
            IJProgressView.shared.hideProgressView()
            print(dict)
            
            if let result = dict as? [String:Any]{
                print(result)
                
              //  let message = result["message"] as? String ?? ""
                let status = result["success"] as? Bool ?? false
                
                if status{
                    if result["data"] != nil{
                        
                        let responseData = result["data"] as! [Dictionary<String, Any>]
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: responseData , options: .prettyPrinted)
                            do {
                                let jsonDecoder = JSONDecoder()
                                let notificationData = try jsonDecoder.decode([NotificationModel].self, from: jsonData)
                                print(notificationData)
                                self.notificationDataArr = notificationData
                                self.notificationsTable.reloadData()
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
    
    //MARK:- FUNCTIONS
    func setAppearance() {
             DispatchQueue.main.async {
                setGradientBackground(view: self.gradientView)
                 self.notificationsTable.layer.cornerRadius = 30
                 self.notificationsTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
             }
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:- TABLEVIEW METHODS
extension NotificationsVC: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notificationDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = notificationsTable.dequeueReusableCell(withIdentifier: "NotificationListTableCell") as! NotificationListTableCell
        cell.nameLBL.text = self.notificationDataArr[indexPath.row].name ?? ""
        if indexPath.row == 0 {
            
        }else {
            cell.newWidthConstraint.constant = 0
        }
        return cell
    }
    
  
}


//TABLEVIEW CLASS
class NotificationListTableCell: UITableViewCell {
    
    @IBOutlet weak var newLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var newWidthConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        newLBL.clipsToBounds = true
    }
    
}

