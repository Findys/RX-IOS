//
//  FBViewController.swift
//  rxNewsApp
//
//  Created by HuJian on 15/11/21.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class FBViewController: UIViewController {
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var commit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        commit.addTarget(self, action: "feedback", forControlEvents: UIControlEvents.TouchUpInside)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func feedback(){
        if let _ = content.text {
            if let _ = nickname.text{
                let params:[String:String] = ["content":content.text!,"nickname":nickname.text!]
                let afManager = AFHTTPRequestOperationManager()
                let url = "http://user.ecjtu.net/api/v1/feedback"
                let op = afManager.POST(url, parameters: params, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
                    print(resp)
                    }, failure: { (AFHTTPRequestOperation, error:NSError) -> Void in
                        print(error)
                })
                op!.responseSerializer = AFHTTPResponseSerializer()
                op!.start()
                MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "感谢您的支持", parentView: self.view.viewWithTag(1))
            }
        }
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        content.resignFirstResponder()
        nickname.resignFirstResponder()
    }


}