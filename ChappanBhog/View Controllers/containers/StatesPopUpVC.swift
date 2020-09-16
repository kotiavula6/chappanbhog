//
//  StatesPopUpVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 16/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class StatesPopUpVC: UIViewController {
    
    let States = ["Telangana", "Punjab", "NewDelhi","Gujarath","HimachalPradesh"]
    
    @IBOutlet weak var backView: UIView!
    var selctedState:String = ""
    var didSelectAction:(()->())?
    var closeButtonAction:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            self.backView.cornerRadius = 8
            self.backView.layer.masksToBounds = true
            self.backView.clipsToBounds = true
        }
    }
    
    //MARK:- ACTIONS
    @IBAction func closeButtonClicked(_ sender: UIButton) {
        if let action = closeButtonAction{
            action()
        }
    }
}

//MARK:- TABLEVIEW METHODS

extension StatesPopUpVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return States.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = States[indexPath.row]
        return cell ?? UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selctedState =  States[indexPath.row]
        if let action = didSelectAction {
            action()
        }
    }
    
    
}
