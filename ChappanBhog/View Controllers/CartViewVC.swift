//
//  CartViewVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 09/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class CartViewVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var subTitleView: UIView!
    @IBOutlet weak var listTable: UITableView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cartLBL: UILabel!
    @IBOutlet weak var itemsLeftLBL: UILabel!
    var dataArry = [[String:Any]]()
    
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        let data = CartHelper.shared.carts()
        dataArry.append(contentsOf: data)
        print(data)
   
    }
    
    //MARK:- FUNCTIONS
    func setAppearance() {
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
    
    //MARK:- ACTIONS
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func increaseButtonClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func decreseButtonClicked(_ sender: UIButton) {
        
    }
    
}
//MARK:- TABLEVIEW METHODS
extension CartViewVC: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let arr = CartHelper.shared.carts()
        return arr.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableCell") as! CartTableCell

        if let image = dataArry[indexPath.row]["image"] as? [String]{
            if image.count > 0 {
                let image = image[0]
                print("userdefaultsIMG",image)
                cell.productIMG.sd_setImage(with: URL(string: image ), placeholderImage: UIImage(named: "placeholder.png"))
                
            }
        }
        cell.productName.text = dataArry[indexPath.row]["title"] as? String ?? ""
 
            cell.increase = {
                cell.quantity += 1
                cell.quantityLBL.text = "\(cell.quantity)"
            }
            
            cell.decrease = {
                if cell.quantity > 1 {
                    cell.quantity -= 1
                    cell.quantityLBL.text = "\(cell.quantity)"
                }
            }
        cell.deleteBTN.tag = indexPath.row
        cell.favBTN.tag = indexPath.row
        cell.tag = indexPath.row
        
        cell.delete = {
            
           // CartHelper.shared.deleteCart(itemInfo: [indexPath.row][""])
            self.dataArry.remove(at: cell.tag)
            self.listTable.reloadData()
            
            
        }
        cell.fav = {
            
        }
        cell.weigtAction = {
            
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "ProductInfoVC") as! ProductInfoVC
        let id = dataArry[indexPath.row]["id"] as? Int ?? 0
        vc.GET_PRODUCT_DETAILS(ItemId: id)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
