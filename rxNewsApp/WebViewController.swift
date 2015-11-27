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
class WebViewController: UIViewController,WKNavigationDelegate,UIWebViewDelegate,UITextViewDelegate {
    
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var backView: UIView!
    var userDefault = NSUserDefaults()
    var content = UITextView()
    var commit = UIButton()
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
        config.userContentController = contentController
        self.webView = WKWebView(frame:self.view.frame, configuration: config)
        self.webView.navigationDelegate = self;
        self.view = webView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        content.frame = CGRect(x: 10, y: self.view.frame.height-30, width: self.view.frame.width-90, height: 30)
        content.backgroundColor = UIColor.whiteColor()
        content.delegate = self
        content.clipsToBounds = true
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.blackColor().CGColor
        content.layer.cornerRadius = 5
        self.view.addSubview(content)
        
        commit.frame = CGRect(x: self.view.frame.width - 75 , y: self.view.frame.height - 30 , width: 70, height: 30)
        commit.setTitle("提交", forState: UIControlState.Normal)
        commit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        commit.backgroundColor = UIColor.whiteColor()
        commit.clipsToBounds = true
        commit.layer.borderWidth = 1
        commit.layer.borderColor = UIColor.blackColor().CGColor
        commit.layer.cornerRadius = 5
        commit.addTarget(self, action: "commitComment", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(commit)
        
        if ifJs{
            let apphtml = try! NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding)
            let bath = NSURL(fileURLWithPath: path)
            webView.loadHTMLString(apphtml as String, baseURL: bath)
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
    
    func webViewDidFinishLoad(webView: UIWebView){
        
    }
    
    func textViewDidBeginEditing(textView: UITextView){
        let frame = textView.frame
        var offset = frame.origin.y+67-(self.view.frame.size.height-216)
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.5)
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        comment.resignFirstResponder()
    }
    
    func textViewDidEndEditing(textView: UITextView){
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    func commitComment(){
        let AFMANAGER = AFHTTPRequestOperationManager()
        let URL = "http://app.ecjtu.net/api/v1/article/\(id)/comment"
        let PARAM = ["id":Int(id),"content":content.text!]
        let op = AFMANAGER.POST(URL, parameters: PARAM, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            print(resp)
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
        op?.responseSerializer = AFHTTPResponseSerializer()
        AFMANAGER.requestSerializer = AFHTTPRequestSerializer()
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
