//
//  ShippingWebVC.swift
//  ChappanBhog
//
//  Created by Vakul Saini on 06/11/20.
//  Copyright © 2020 AAvula. All rights reserved.
//

import UIKit
import WebKit

class ShippingWebVC: UIViewController {

    //MARK:- OUTLETS
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    var text: String?
    var url: String?
    var titleText: String = ""
    var acceptBlock: SimpleBlock?
    
    //MARK:- APPLICATION LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppearance()
        
        // self.lblTitle.text = titleText
        self.webView.backgroundColor = .white
        self.webView.navigationDelegate = self
        
        if let mainText = text {
            // Load Text
            loadText(mainText)
        }
        else if let mainUrl = url {
            // Load Url
            loadURL(mainUrl)
        }
    }
    
    //MARK:-FUNCTIONS
    func setAppearance() {
        DispatchQueue.main.async {
            setGradientBackground(view: self.gradientView)
            self.backView.layer.cornerRadius = 30
            self.backView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            self.webView.layer.cornerRadius = 30
            self.webView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }

    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonClicked(_ sender: UIButton) {
        if let block = acceptBlock {
            block()
        }
    }
    
    // MARK:- Methods
    fileprivate func loadURL(_ url: String) {
        
        if url.contains("http") {
            // Live Url
            if let mainURL = URL(string: url) {
                showLoader()
                let request = URLRequest(url: mainURL, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 30)
                self.webView.load(request)
            }
        }
        else {
            // File Url
            showLoader()
            let mainURL = URL(fileURLWithPath: url)
            self.webView.loadFileURL(mainURL, allowingReadAccessTo: mainURL)
        }
    }
    
    fileprivate func loadText(_ text: String) {
        showLoader()
        let str = "<html><body><p style=\"padding: 20\"><font size=\"14\" face=\"Helvetica\">\(text)</font></p></body></html>"
        self.webView.loadHTMLString(str, baseURL: nil)
    }
    
    fileprivate func showLoader() {
        IJProgressView.shared.showProgressView()
        DispatchQueue.main.async {
            self.webView.isHidden = true
        }
    }
    
    fileprivate func hideLoader() {
        IJProgressView.shared.hideProgressView()
        DispatchQueue.main.async {
            self.webView.isHidden = false
        }
    }
}


extension ShippingWebVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideLoader()
    }
}

