//
//  OurMenuVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class OurMenuVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var backView: UIView!
    
    var colors: [UIColor] = [#colorLiteral(red: 0.9849506021, green: 0.8973115683, blue: 0.876331389, alpha: 1), #colorLiteral(red: 0.9407958388, green: 0.9658285975, blue: 0.9961531758, alpha: 1), #colorLiteral(red: 0.9904260039, green: 0.9232538342, blue: 0.8390535712, alpha: 1), #colorLiteral(red: 0.9181006551, green: 0.9216977954, blue: 0.924925983, alpha: 1), #colorLiteral(red: 0.9757087827, green: 0.8361513615, blue: 0.8480049372, alpha: 1)]
    var shopCategories: [ShopCategory] = []
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.register(UINib(nibName: "OurMenuTableCell", bundle: nil), forCellReuseIdentifier: "OurMenuTableCell")
        menuTable.separatorStyle = .none
        setAppearance()
        
        IJProgressView.shared.showProgressView()
        getCategories {
            IJProgressView.shared.hideProgressView()
            self.reload()
        }
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.menuTable.layer.cornerRadius = 30
            self.menuTable.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.cartLBL.layer.cornerRadius = self.cartLBL.frame.height/2
            self.cartLBL.layer.masksToBounds = true
        }
    }
    
    func reload() {
        DispatchQueue.main.async {
            self.menuTable.reloadData()
        }
    }
        
    // MARK:- Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- TABLEVIEW METHODS
extension OurMenuVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = menuTable.dequeueReusableCell(withIdentifier: "OurMenuTableCell") as! OurMenuTableCell
        cell.selectionStyle = .none
        var colorIndex = indexPath.row
        if colorIndex > 4 {
            colorIndex = indexPath.row % 5
        }
        cell.contentView.backgroundColor = colors[colorIndex]
        cell.shopCategory = shopCategories[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let totalWidth: CGFloat = UIScreen.main.bounds.width
        let iconWidth = totalWidth * 0.4
        let height = iconWidth * 86 / 100
        return height
    }
}


extension OurMenuVC {
    
    func getCategories(_ completion: @escaping () -> Void) {
        
        // let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        // let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_CATEGORIES + "/\(userID)"
        
        let url = "https://www.chhappanbhog.com/restapi/example/getcategories.php"
        AFWrapperClass.requestGETURL(url, success: { (response) in
            
            if let dict = response as? [String: Any] {
                let success = dict["success"] as? Bool ?? false
                if success {
                    print(dict)
                    self.shopCategories.removeAll()
                    let data = dict["data"] as? [[String: Any]] ?? []
                    for info in data {
                        let category = ShopCategory(dict: info)
                        self.shopCategories.append(category)
                    }
                }
                else {
                    let message = dict["message"] as? String ?? "Some error Occured"
                    alert("ChhappanBhog", message: message, view: self)
                }
            }
            completion()
            
        }) { (error) in
            alert("ChhappanBhog", message: error.description, view: self)
            completion()
        }
    }
}
