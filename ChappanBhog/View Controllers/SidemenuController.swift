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

    var listArray: [String] = ["SHOP", "MY ACCOUNT", "CART", "ABOUT"]

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
        
        let name = UserDefaults.standard.value(forKey: Constants.Name) as? String ?? ""
            print(name)
        lblprofilename.text = "Hi \(name)"
        
        myimgvw.contentMode = .scaleAspectFill
        myimgvw.layer.cornerRadius = myimgvw.frame.size.width/2
        myimgvw.layer.borderColor = UIColor.black.cgColor
        myimgvw.layer.borderWidth = 1
        myimgvw.clipsToBounds = true
        let imageStr = UserDefaults.standard.string(forKey: Constants.Image) ?? ""
        if !imageStr.isEmpty {
            let urlString = ApplicationUrl.IMAGE_BASE_URL + imageStr
            myimgvw.sd_setImage(with: URL(string: urlString), completed: nil)
        }
        

    }
    
    @objc func logout() {
        AppDelegate.shared.logout()
    }
    
    @IBAction func btnLogout(_ sender: UIButton) {
        
        self.showAlertWithTitle(title: "", message: "Are you sure you want to logout?", okButton: "Yes", cancelButton: "No", okSelectorName: #selector(self.logout))
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
        return listArray.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selecteItem = listArray[indexPath.row]
        
        if (selecteItem == "SHOP") {
            
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "OurMenuVC") as! OurMenuVC
            vc.isFromSidemenu = true
            let navController   = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            slideMenuController()?.changeMainViewController(navController, close: true)
            
        }
        else if (selecteItem == "MY ACCOUNT") {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
            vc.isFromSideMenu = true
            let navController   = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            vc.isFromSideMenu = true
            slideMenuController()?.changeMainViewController(navController, close: true)
            
        }
//
//        else if (selecteItem == "SETTINGS") {
//            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
//            vc.isFromSideMenu = true
//            let navController   = UINavigationController(rootViewController: vc)
//            navController.isNavigationBarHidden = true
//            slideMenuController()?.changeMainViewController(navController, close: true)
//
//
//        }
            
        else if (selecteItem == "CART") {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
            let navController   = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            slideMenuController()?.changeMainViewController(navController, close: true)
            
        }
            
        else if (selecteItem == "ABOUT") {
            let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
            let navController   = UINavigationController(rootViewController: vc)
            navController.isNavigationBarHidden = true
            slideMenuController()?.changeMainViewController(navController, close: true)
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableVwCell
        cell.lblText.text = listArray[indexPath.row]
      
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
