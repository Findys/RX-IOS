//
//  CommentsViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/23.
//  Copyright © 2016年 Findys. All rights reserved.
//

import UIKit
import WebKit

class CommentsViewController: UIViewController {

    var id = Int()
    
    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        
        let config = WKWebViewConfiguration()
        
        config.userContentController = WKUserContentController()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.webView = WKWebView(frame:self.view.frame, configuration: config)
        self.view.addSubview(webView)
        
        webView.alpha = 0
    }
}
