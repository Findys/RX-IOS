//
//  WebViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit
import WebKit

@available(iOS 8.0, *)
class WebViewController: UIViewController,WKNavigationDelegate {
    
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backView: UIView!
    var path = String()
    var id = Int()
    var ifJs = Bool()
   var webView: WKWebView!
    override func loadView() {
        
        super.loadView()
            let config = WKWebViewConfiguration()
            let contentController = WKUserContentController()
        
            let userScript = WKUserScript(
                source: "bootstrap()",
                injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
                forMainFrameOnly: true)
        
        contentController.addUserScript(userScript)
        config.userContentController = contentController;
        self.webView = WKWebView(frame:self.view.frame, configuration: config)
        self.webView.navigationDelegate = self;
//        progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        self.view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if ifJs{
            let apphtml = try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let bath = NSURL(fileURLWithPath: path)
            webView.loadHTMLString(apphtml as String, baseURL: bath)
//            webView.loadRequest(jsrequest)
        }
        else{
            let request = NSURLRequest(URL:NSURL(string:"http://app.ecjtu.net/api/v1/article/\(id)/view")!)
            webView.loadRequest(request)
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
