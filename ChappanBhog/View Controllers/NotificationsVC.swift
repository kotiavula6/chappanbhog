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
    var currentPage: Int = 1
    var noMoreResult: Bool = false
    var isRequestOnGoing: Bool = false
    let numberOfItemsInOnePageRequest = 20 // Static as per API
    
    //MARK:- APPLICAION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        notificationsTable.delegate = self
        notificationsTable.dataSource = self
        notificationsTable.register(UINib(nibName: "LoadMoreCell", bundle: nil), forCellReuseIdentifier: "LoadMoreCell")
        setAppearance()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setGradientBackground(view: self.gradientView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        currentPage = 1
        noMoreResult = false
        IJProgressView.shared.showProgressView()
        getNotifications {
            self.isRequestOnGoing = false
            IJProgressView.shared.hideProgressView()
        }
    }
    
    // MARK:- Methods
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.notificationsTable.layer.cornerRadius = 30
            self.notificationsTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.notificationsTable.reloadData()
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func backButtonAction(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
    }
}

// MARK:- TableView Delegates & DataSources
extension NotificationsVC: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !noMoreResult, self.notificationDataArr.count >= numberOfItemsInOnePageRequest {
            return self.notificationDataArr.count + 1
        }
        return self.notificationDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.notificationDataArr.count {
            let cell = notificationsTable.dequeueReusableCell(withIdentifier: "NotificationListTableCell") as! NotificationListTableCell
            cell.selectionStyle = .none
            let notification = self.notificationDataArr[indexPath.row]
            cell.nameLBL.text = notification.name ?? ""
            cell.showNew(notification.isNew)
            return cell
        }
        else {
            // LoadMore cell
            let cell: LoadMoreCell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
            cell.selectionStyle = .none
            cell.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < self.notificationDataArr.count {
            return UITableView.automaticDimension
        }
        return LOAD_MORE_CELL_HEIGHT
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // UITableView only moves in one direction, y axis
        let currentOffset = scrollView.contentOffset.y;
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
        // Change 10.0 to adjust the distance from bottom
        if (maximumOffset - currentOffset <= 10.0) {
            
            /// Load more request when, Data is available and not currently not refreshing.
            if !noMoreResult, !isRequestOnGoing  {
                // Request for more data
                self.getNotifications {
                    self.isRequestOnGoing = false
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= notificationDataArr.count { return }
        IJProgressView.shared.showProgressView()
        markReadNotification(indexPath) {
            IJProgressView.shared.hideProgressView()
        }
    }
}

// MARK:- APIs
extension NotificationsVC {
    
    func getNotifications(_ completion: @escaping () -> Void) {
        
        if noMoreResult || isRequestOnGoing {
            // There is no more data OR request is on going
            return
        }
        
        isRequestOnGoing = true
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        let notificationUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_notification + "/\(userID)?page=\(currentPage)"
        AFWrapperClass.requestGETURL(notificationUrl, success: { (dict) in
            guard let result = dict as? [String: Any] else {
                completion()
                return
            }
            let success = result["success"] as? Bool ?? false
            if success {
                
                if self.currentPage == 1 {
                    self.notificationDataArr.removeAll()
                }
                
                // Ok
                let currentPage = result["currentPage"] as? Int ?? 1
                let totalItems = result["total_items"] as? Int ?? 0
                self.currentPage = currentPage + 1 // Increment currentPage by 1 for next request
                let data = result["data"] as? [[String: Any]] ?? []
                if data.count > 0 {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: data , options: .prettyPrinted)
                        do {
                            let jsonDecoder = JSONDecoder()
                            let notificationData = try jsonDecoder.decode([NotificationModel].self, from: jsonData)
                            self.notificationDataArr.append(contentsOf: notificationData)
                            self.reloadData()
                            
                            if self.notificationDataArr.count >= totalItems {
                                self.noMoreResult = true
                            }
                            
                        } catch {
                            alert("ChappanBhog", message: error.localizedDescription, view: self)
                        }
                    } catch {
                        alert("ChappanBhog", message: error.localizedDescription, view: self)
                    }
                }
                else {
                    // No notifications found
                    self.noMoreResult = true
                }
            }
            else {
                let message = result["message"] as? String ?? "Some error Occured"
                alert("ChappanBhog", message: message, view: self)
            }
            
            completion()
            
        }) { (error) in
            alert("ChappanBhog", message: error.description, view: self)
            completion()
        }
    }
    
    func markReadNotification(_ indexPath: IndexPath, _ completion: @escaping () -> Void) {
    
        if indexPath.row >= notificationDataArr.count {
            completion()
            return
        }
    
        let notification = notificationDataArr[indexPath.row]
        let notificationId = notification.id ?? 0
        if notificationId == 0 || !notification.isNew {
            // If notificationId is invalid OR already read
            completion()
            return
        }
        
        let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        let notificationUrl = ApplicationUrl.WEB_SERVER + WebserviceName.API_notification_read
        AFWrapperClass.requestPOSTURL(notificationUrl, params: ["user_id": userID, "notification_id": notificationId], success: { (dict) in
            guard let result = dict as? [String: Any] else {
                completion()
                return
            }
            let success = result["success"] as? Bool ?? false
            if success {
                self.notificationDataArr[indexPath.row].read = "1"
                self.reloadData()
            }
            completion()
        }) { (error) in
            alert("ChappanBhog", message: error.description, view: self)
            completion()
        }
    }
}


// MARK:- NotificationCell
class NotificationListTableCell: UITableViewCell {
    
    @IBOutlet weak var newLBL: UILabel!
    @IBOutlet weak var nameLBL: UILabel!
    @IBOutlet weak var newWidthConstraint: NSLayoutConstraint!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        newLBL.clipsToBounds = true
    }
    
    func showNew(_ show: Bool) {
        if show {
            newWidthConstraint.constant = 50
        }
        else {
            newWidthConstraint.constant = 0
        }
        self.layoutIfNeeded()
    }
}

