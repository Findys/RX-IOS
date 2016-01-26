//
//  LocalWebViewController.swift
//  rxNewsApp
//
//  Created by Geek on 15/12/2.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit
import WebKit

class LocalWebViewController: UIViewController,WKNavigationDelegate {
    
    var path = NSString()
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let id = userDefault.objectForKey("account") as! String
        
        let config = WKWebViewConfiguration()
        
        let contentController = WKUserContentController()
        
        config.userContentController = contentController
        
        let js = "window.id = '"+id+"';"
        
        let script = WKUserScript.init(source: js, injectionTime: .AtDocumentStart,forMainFrameOnly: true)
        
        config.userContentController.addUserScript(script)
        
        webView = WKWebView(frame:self.view.frame, configuration: config)
        
        webView.backgroundColor = UIColor.whiteColor()
        
        let htmlcont = try! NSString(contentsOfFile: path as String, encoding: NSUTF8StringEncoding)
        
        let baseUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
        
        webView.loadHTMLString(htmlcont as String, baseURL: baseUrl)
        
        self.view.addSubview(webView)
        
    }
    
}
