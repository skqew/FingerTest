//
//  ViewController.swift
//  FingerPushLiveTest
//
//  Created by 박은지 on 2019. 9. 4..
//  Copyright © 2019년 박은지. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webview = WKWebView(frame: self.view.frame)
        
        webview.uiDelegate = self
        webview.navigationDelegate = self
        
        self.view.addSubview(webview)
        
        
        //웹뷰
        let address = "https://www.fingerpush.com/portal/live_app_slide/slide.html"
        let url = URL(string: address)
        let request = URLRequest(url: url!)
        webview.load(request)


    }
    
    
    

}

