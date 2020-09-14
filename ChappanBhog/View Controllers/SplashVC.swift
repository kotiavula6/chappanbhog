//
//  SplashVC.swift
//  ChappanBhog
//
//  Created by AAVULA KOTI on 08/09/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            setGradientBackground(view: self.view)
        }
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(navigateTologinPage), userInfo: nil, repeats: false)
 
    }
    
    @objc func navigateTologinPage() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
