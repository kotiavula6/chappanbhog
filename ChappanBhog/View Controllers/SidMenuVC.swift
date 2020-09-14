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
    
        let vc = storyboard?.instantiateViewController(withIdentifier: "CartViewVC") as! CartViewVC
              self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func settingsClicked(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "MyAccountVC") as! MyAccountVC
//              self.navigationController?.pushViewController(vc, animated: true)
        
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
