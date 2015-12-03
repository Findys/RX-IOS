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
class WebViewController: UIViewController,WKNavigationDelegate,UIWebViewDelegate{
    
    @IBOutlet weak var comment: UIButton!
    var progressBar = UIProgressView()
    var userDefault = NSUserDefaults()
    var path = String()
    var id = Int()
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    加载所需空间
    override func loadView() {
        super.loadView()
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = contentController
        self.webView = WKWebView(frame:self.view.viewWithTag(1)!.frame, configuration: config)
        webView.navigationDelegate = self
        progressBar.progress = 0
        progressBar.frame = CGRect(x: 0, y: (self.view.viewWithTag(1)?.frame.origin.y)!, width: self.view.frame.width, height: 20)
        progressBar.backgroundColor = UIColor.lightGrayColor()
        progressBar.progressTintColor = UIColor(red: 58/255.0, green: 168/255.0, blue: 252/255.0, alpha: 1.0)
        
        webView.alpha = 0;
        self.view.addSubview(webView)
        self.view.addSubview(progressBar)
        
        comment.addTarget(self, action: "commentButton", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //    view将消失时执行
    override func viewWillAppear(animated: Bool) {
        let request = NSURLRequest(URL:NSURL(string:"http://app.ecjtu.net/api/v1/article/\(id)/view")!)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.loadRequest(request)
        UIView.animateWithDuration(2) { () -> Void in
            self.webView.alpha = 1
        }
    }
    
    //    评论按钮点击事件
    func commentButton(){
        let myStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let push = myStoryBoard.instantiateViewControllerWithIdentifier("comment")
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    
    //    view将要消失时执行
    override func viewWillDisappear(animated: Bool) {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
        progressBar.setProgress(0.0, animated: false)
    }
    
    //    KVO监控
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if (keyPath == "estimatedProgress") {
            progressBar.hidden = webView.estimatedProgress == 1
            progressBar.setProgress(Float(webView.estimatedProgress), animated: true)
        }
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

