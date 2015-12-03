//
//  CommentViewController.swift
//  rxNewsApp
//
//  Created by Geek on 15/11/30.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextViewDelegate {
    var content = UITextView()
    var commit = UIButton()
    var id = NSNumber()
    
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    开始编辑textview时调用
    func textViewDidBeginEditing(textView: UITextView){
        let frame = textView.frame
        let offset = frame.origin.y+67-(self.view.frame.size.height-216)
        UIView.beginAnimations("ResizeForKeyboard", context: nil)
        UIView.setAnimationDuration(0.5)
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height)
        UIView.commitAnimations()
    }
    
//    点击页面调用
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        content.resignFirstResponder()
    }
    
//    结束编辑时调用
    func textViewDidEndEditing(textView: UITextView){
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
//    提交评论
    func commitComment(){
        let afmanager = AFHTTPRequestOperationManager()
        let URL = "http://app.ecjtu.net/api/v1/article/\(id)/comment"
        let param = ["id":id,"content":content.text!]
        afmanager.POST(URL, parameters: param, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            print(resp)
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
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
