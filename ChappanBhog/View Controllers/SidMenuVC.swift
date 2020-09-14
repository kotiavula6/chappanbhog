//
//  SidMenuVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 14/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height

class SidMenuVC: UIViewController {

//    @IBOutlet weak var sideTable: UITableView!
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var leftMenuWidthConstant: NSLayoutConstraint!
    let swipeRight = UISwipeGestureRecognizer.init()
    
    var completionHandler: (Int)->Void = {_ in }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewSetup()
    }
    

    @IBAction func closeButtonAction(_ sender: UIButton) {
      self.viewOutAnimation()
    }
    
    @IBAction func AboutClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func CartClicked(_ sender: UIButton) {
    

        
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
  
        
    }
    @IBAction func MyAccountClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func viewSetup() {
        swipeRight.addTarget(self, action: #selector(viewOutAnimation))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        DispatchQueue.main.async {
            setGradientBackground(view: self.menuView)
            
        }
    }
    
    @objc func viewOutAnimation()
    {
        UIView.animate(withDuration: 0.3, animations:
            {
                self.leftMenuWidthConstant.constant = -ScreenWidth - (ScreenWidth / 3)
             ////   self.UserIMG.isHidden = true
                self.view.layoutIfNeeded();
        }, completion:
            {
                _ in
                self.view.layoutIfNeeded();
                self.dismiss(animated: false, completion:
                    {
                    self.completionHandler(16)
                });
        })

    }

    
}
//extension SidMenuVC:UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")   as? UITableViewCell
//        cell?.textLabel?.text = "koooo"
//
//        return cell ?? UITableViewCell()
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//
//        UserDefaults.standard.set(indexPath.section, forKey:"viewController")
//                 UIView.animate(withDuration: 0.3, animations:
//                     {
//                         self.leftMenuWidthConstant.constant = 0
//                         self.view.layoutIfNeeded();
//                 }, completion:
//                     {
//                         _ in
//                         self.view.layoutIfNeeded();
//                         self.dismiss(animated: false, completion:
//                             {
//                               let Notificationlist = AppConstant.APP_STOREBOARD.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
//                                      let nav = UINavigationController(rootViewController: Notificationlist)
//                                      AppConstant.APP_DELEGATES.window!.rootViewController = nav
//                         });
//                 })
//    }
//
//
//}
