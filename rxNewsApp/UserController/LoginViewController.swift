//
//  LoginViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/18.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
    var url="http://user.ecjtu.net/api/login"
    
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var account: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    发送用户信息
    func postData(){
        
        let mypassword = password.text! as String
        
        let myaccount = account.text! as String
        
        let params:[String:String] = ["username": myaccount, "password": mypassword]
        
        Alamofire.request(.POST, url, parameters: params, encoding: .URL, headers: nil).responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let result = resp.result.value!.objectForKey("result")!
                
                if result as! NSObject==1{
                    
                    let token = resp.result.value!.objectForKey("token")! as! String
                    
                    userDefault.setObject(mypassword, forKey: "password")
                    userDefault.setObject(token, forKey: "token")
                    userDefault.setObject(myaccount, forKey: "account")
                    userDefault.setBool(true, forKey: "iflogin")
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }else{
                    
                    MozTopAlertView.showWithType(MozAlertTypeError, text: "登录错误", parentView:self.view)
                    
                }
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "请检查网络", parentView:self.view)
            }
        }
    }
    
    //        点击使输入框失去焦点
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        password.resignFirstResponder()
        account.resignFirstResponder()
    }
    
    //    点击登录按钮
    func loginClick()
    {
        if (account.text?.characters.count==14)&&(password.text?.characters.count>=6){
            
            postData()
            
        }else{
            
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view)
        }
    }
    
    //    监听键盘的return的事件
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        if(password.text?.characters.count>=6){
            
            postData()
            
        }else{
            
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view)
            password.resignFirstResponder()
            
        }
        return true
    }
    
}
