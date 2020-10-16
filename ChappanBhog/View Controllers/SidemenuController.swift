//
//  SidemenuController.swift
//  AJT
//
//  Created by Aman on 22/09/19.
//  Copyright © 2019 enAct eServices. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class SidemenuController: UIViewController{

    var myIndex = -1
    var imgArray: [String] = ["active_profile", "active_work_history", "active_change_password", "active_contact_us", "active_about", "active_help", "active_terms", "active_privacy_policy","","active_logout"]
    var listArray: [String] = ["Profile", "Work History", "Change Password", "Contact us", "About", "Help/FAQ", "Terms", "Privay Policy","","Logout"]
    var data = [[String: Any]]()
    @IBOutlet weak var myimgvw: UIImageView!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblprofilename: UILabel!
    @IBOutlet weak var lblUserPosition: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeNotification(observer: self,selector: #selector(leftSideMenuDidOpen(_ :)) ,name: "leftSideMenuDidOpen", object: nil)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.isScrollEnabled = true
        update()
    }
    func observeNotification( observer: Any,  selector: Selector,  name: String,  object: Any?) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: name), object: object)
    }
    @objc func leftSideMenuDidOpen(_ notification: Notification) {
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserData()
//        if let userDetails = UserDefaults.standard.dictionary(forKey: DefaultsKeys.CURRENT_USERID) {
//            let userData = LoginModel(toDict: userDetails)
//             let String = userData.firstName
//             let string2 = userData.lastName
//             let combined2 = "\(String) \(string2)"
//             lblprofilename.text = combined2
//            guard let imageUrl = URL(string: userData.image) else { return }
//            do {
//                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
//                DispatchQueue.main.async {
//                    self.myimgvw.image = UIImage(data: imageData)
//                }
//            } catch {
//            }
//        }
    }
    
    func setUserData () {
   
    }
    
    
    func update() {
        myimgvw.layer.borderWidth = 0.1
        myimgvw.layer.masksToBounds = false
        myimgvw.layer.cornerRadius = myimgvw.frame.height/2
        myimgvw.clipsToBounds = true
    }
   
}
extension SidemenuController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableVwCell
        cell.lblText.text = listArray[indexPath.row]
        let image = UIImage(named: imgArray[indexPath.row])
        cell.lblImg.image = image
        if myIndex == indexPath.row && myIndex != 8{
            // selected color
            cell.uivwCell.layer.backgroundColor = #colorLiteral(red: 0.9552512765, green: 0.4696164727, blue: 0.1269498765, alpha: 1)
            cell.lblText.textColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lblImg.tintColor = UIColor.white
            cell.uivwCell.layer.cornerRadius = 18
            cell.uivwCell.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.uivwCell.layer.shadowOpacity = 0.23
            cell.uivwCell.layer.shadowRadius = 3.0
            cell.uivwCell.layer.masksToBounds = true
        }
        else{
            // unselected color
            cell.uivwCell.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cell.lblText.textColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            cell.lblImg.tintColor = UIColor.gray
        }
        return cell
    }
}
class CustomTableVwCell: UITableViewCell {
//    Marks Outlets
    @IBOutlet weak var lblImg: UIImageView!
    @IBOutlet weak var lblText: UILabel!
    @IBOutlet weak var uivwCell: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
}
}


extension SidemenuController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
