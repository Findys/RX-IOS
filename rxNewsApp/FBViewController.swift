//
//  FBViewController.swift
//  rxNewsApp
//
//  Created by HuJian on 15/11/21.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class FBViewController: UIViewController,UITextViewDelegate {
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var commit: UIButton!
    
    override func loadView() {
        super.loadView()
        commit.addTarget(self, action: "feedBack", forControlEvents: UIControlEvents.TouchUpInside)
        content.layer.borderWidth = 1
        content.layer.cornerRadius = 5
        content.clipsToBounds = true
        content.text="请输入内容"
        content.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
                content.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    反馈功能实现
    func feedBack(){
        if content.text != nil && nickname.text != nil {
            let param = ["content":content.text!,"nickname":nickname.text!]
            let afmanager = AFHTTPSessionManager()
            let url = "http://app.ecjtu.net/api/v1/feedback"
            afmanager.POST(url, parameters: param, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "感谢您的支持", parentView: self.view.viewWithTag(1))
                }, failure: { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                    MozTopAlertView.showWithType(MozAlertTypeError, text: "请检查网络", parentView: self.view.viewWithTag(1))
            })

        }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "请填写必要信息", parentView: self.view.viewWithTag(1))
        }
        
    }
    
    //    点击页面时取消焦点
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        content.resignFirstResponder()
        nickname.resignFirstResponder()
    }
    
    //    textview点击事件
    func textViewDidBeginEditing(textView: UITextView){
        content.text=""
    }
    
    
}