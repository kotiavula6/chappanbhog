//
//  OurMenuVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 11/09/20.
//  Copyright © 2020 enAct eServices. All rights reserved.
//

import UIKit

class OurMenuVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var btnHome: UIButton!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnBack: UIButton!
    
    var colors: [UIColor] = [#colorLiteral(red: 0.9849506021, green: 0.8973115683, blue: 0.876331389, alpha: 1), #colorLiteral(red: 0.9407958388, green: 0.9658285975, blue: 0.9961531758, alpha: 1), #colorLiteral(red: 0.9904260039, green: 0.9232538342, blue: 0.8390535712, alpha: 1), #colorLiteral(red: 0.9181006551, green: 0.9216977954, blue: 0.924925983, alpha: 1), #colorLiteral(red: 0.9757087827, green: 0.8361513615, blue: 0.8480049372, alpha: 1)]
    var shopCategories: [ShopCategory] = []
    var isFromSidemenu = false
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTable.register(UINib(nibName: "OurMenuTableCell", bundle: nil), forCellReuseIdentifier: "OurMenuTableCell")
        menuTable.separatorStyle = .none
        setAppearance()
        
        if let controllers = self.navigationController?.viewControllers, let controller = controllers.first, controller is UITabBarController, controllers.count == 1 {
            // Will be fetch in viewWillAppear
        }
        else {
            IJProgressView.shared.showProgressView()
            getCategories {
                IJProgressView.shared.hideProgressView()
                self.reload()
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCartCount()
        NotificationCenter.default.addObserver(self, selector: #selector(updateCartCount), name: NSNotification.Name(rawValue: "kCartCount"), object: nil)
        
        // Check if its from tabbar
        if let controllers = self.navigationController?.viewControllers, let controller = controllers.first, controller is UITabBarController, controllers.count == 1 {
            // For tabbar, Hide back button and load favourites
            btnBack.isHidden = true
            btnHome.isHidden = true
            
            IJProgressView.shared.showProgressView()
            getCategories {
                IJProgressView.shared.hideProgressView()
                self.reload()
            }
        }
        else {
            btnHome.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
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
    
    @objc func updateCartCount() {
        let data = CartHelper.shared.cartItems
        if data.count == 0 {
            cartLBL.text = "0"
            cartLBL.isHidden = true
        }
        else {
            cartLBL.text = "\(data.count)"
            cartLBL.isHidden = false
        }
    }
        
    // MARK:- Actions
    @IBAction func backButtonAction(_ sender: UIButton) {
        
        //if isFromSidemenu {
            AppDelegate.shared.showHomeScreen()
       // }
        
       // self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func homeAction(_ sender: UIButton) {
        AppDelegate.shared.showHomeScreen()
    }
    
    @IBAction func cartAction(_ sender: UIButton) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        if CartHelper.shared.isRunningOnIpad {
            return 160
        }
        
        let totalWidth: CGFloat = UIScreen.main.bounds.width
        let iconWidth = totalWidth * 0.4
        let height = iconWidth * 86 / 100
        return height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shopCategory = shopCategories[indexPath.row]
        let id = Int(shopCategory.id) ?? 0
        if id == 0 { return }
        
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CategoryAndItemsVC") as! CategoryAndItemsVC
        vc.isFromNavgation = true
        vc.GET_CATEGORY_ITEMS(ItemId: id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension OurMenuVC {
    
    func getCategories(_ completion: @escaping () -> Void) {
        
        // let userID = UserDefaults.standard.value(forKey: Constants.UserId) as? Int ?? 0
        // let url = ApplicationUrl.WEB_SERVER + WebserviceName.API_GET_CATEGORIES + "/\(userID)"
        
        let url = "http://3.7.199.43/restapi/example/getcategories.php"
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
