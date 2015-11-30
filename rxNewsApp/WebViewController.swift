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
class WebViewController: UIViewController,WKNavigationDelegate,UIWebViewDelegate {
    
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backView: UIView!
    var userDefault = NSUserDefaults()
    var path = String()
    var id = Int()
    var ifJs = Bool()
    var webView: WKWebView!
    override func loadView() {
        super.loadView()
            let config = WKWebViewConfiguration()
            let contentController = WKUserContentController()
//
//            let userScript = WKUserScript(
//                source: "bootstrap()",
//                injectionTime: WKUserScriptInjectionTime.AtDocumentEnd,
//                forMainFrameOnly: true)
//        
//        contentController.addUserScript(userScript)
        config.userContentController = contentController
        self.webView = WKWebView(frame:self.view.frame, configuration: config)
        webView.frame = self.view.frame
        self.view.addSubview(webView)
        
        comment.addTarget(self, action: "commentButton", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL:NSURL(string:"http://app.ecjtu.net/api/v1/article/\(id)/view")!)
        webView.loadRequest(request)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func commentButton(){
        let myStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let push = myStoryBoard.instantiateViewControllerWithIdentifier("comment") as! CommentViewController
        self.navigationController?.pushViewController(push, animated: true)
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
