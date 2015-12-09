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
class WebViewController: UIViewController,WKNavigationDelegate,UIWebViewDelegate,UITextViewDelegate{
    let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
    let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.height
    var progressBar = UIProgressView()
    var userDefault = NSUserDefaults()
    var path = String()
    var id = Int()
    var webView: WKWebView!
    var from = String()
    let content = UITextView()
    let backView = UIView()
    
    @IBOutlet weak var commitList: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let config = WKWebViewConfiguration()
        let contentController = WKUserContentController()
        config.userContentController = contentController
        self.webView = WKWebView(frame:self.view.viewWithTag(1)!.frame, configuration: config)
        webView.navigationDelegate = self
        progressBar.progress = 0
        progressBar.frame = CGRect(x: 0, y: (self.view.viewWithTag(1)?.frame.origin.y)!, width: self.view.frame.width, height: 20)
        progressBar.backgroundColor = UIColor.lightGrayColor()
        progressBar.progressTintColor = UIColor(red: 58/255.0, green: 168/255.0, blue: 252/255.0, alpha: 1.0)
        
        webView.alpha = 0
        self.view.addSubview(webView)
        self.view.addSubview(progressBar)
        
        if from == "rx"{
            backView.backgroundColor = UIColor(red: 28/255.0, green: 144/255.0, blue: 129/255.0, alpha: 1.0)
            backView.frame = CGRect(x: 0, y: WINDOW_HEIGHT - 40, width: WINDOW_WIDTH, height: 40)
            self.view.addSubview(backView)
            
            content.frame = CGRect(x: 8, y: 5, width: WINDOW_WIDTH - 90, height: 30)
            content.clipsToBounds = true
            content.layer.cornerRadius = 5
            content.delegate = self
            backView.addSubview(content)
            
            
            let comment = UIButton()
            comment.setTitle("评论", forState: UIControlState.Normal)
            comment.backgroundColor = UIColor.whiteColor()
            comment.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            comment.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Highlighted)
            comment.frame = CGRect(x: WINDOW_WIDTH - 73, y: 5, width: 65, height: 30)
            comment.clipsToBounds = true
            comment.layer.cornerRadius = 5
            comment.addTarget(self, action: "commitComment", forControlEvents: UIControlEvents.TouchUpInside)
            backView.addSubview(comment)
            
            commitList.addTarget(self, action: "commentList", forControlEvents: UIControlEvents.TouchUpInside)
            
        }
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    view将出现
    override func viewWillAppear(animated: Bool) {
        let request = NSURLRequest(URL:NSURL(string:"http://app.ecjtu.net/api/v1/article/\(id)/view")!)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.loadRequest(request)
        UIView.animateWithDuration(2) { () -> Void in
        self.webView.alpha = 1
        }
    }
    
    //    评论列表
    func commentList(){
        let myStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let push = myStoryBoard.instantiateViewControllerWithIdentifier("comment") as! CommentViewController
        push.id = id
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
    
    //    提交评论
    func commitComment(){
        if let _ = userDefault.objectForKey("account"){
            
        let afmanager = AFHTTPRequestOperationManager()
        let URL = "http://app.ecjtu.net/api/v1/article/\(id)/comment"
        let account = userDefault.objectForKey("account") as! String
        let param:[String:String] = ["sid":String(account),"content":content.text!]
        afmanager.POST(URL, parameters: param, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            print(resp)
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
        }else{
            MozTopAlertView.showWithType(MozAlertTypeError, text: "请先登录", parentView: webView)
            print("asd")
        }
    }
    
    //    点击页面调用
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        content.resignFirstResponder()
    }
    
    //    开始编辑textview时调用
    func textViewDidBeginEditing(textView: UITextView){
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.5)
        backView.frame = CGRect(x: 0, y: WINDOW_HEIGHT - 293, width: WINDOW_WIDTH, height: 40)
        UIView.commitAnimations()
    }
    
    //    结束编辑时调用
    func textViewDidEndEditing(textView: UITextView){
        backView.frame = CGRect(x: 0, y: WINDOW_HEIGHT - 40, width: WINDOW_WIDTH, height: 40)
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

