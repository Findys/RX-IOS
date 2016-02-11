//
//  LoginViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/18.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController,UITextInputTraits {
    
    var url="http://user.ecjtu.net/api/login"
    

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var account: UITextField!
    
    var initial_Y = CGFloat()
    let notifictionCenter = NSNotificationCenter.defaultCenter()
    
    @IBAction func passwordTint(sender: AnyObject) {
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "默认密码身份证后六位", parentView:self.view)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        
        notifictionCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardWillShowNotification, object: nil)
        notifictionCenter.addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        initial_Y = backView.frame.origin.y
        
        backView.translatesAutoresizingMaskIntoConstraints = true
//        let background = UIImageView(image:  UIImage(named: "loginWallPaper"))
//        background.frame = self.view.frame
//        self.view.insertSubview(background, atIndex: 0)
        
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
    func loginClick(){

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
    
    func keyboardDidShow(notification:NSNotification){
        
        logoImage.alpha = 0
        
        backView.frame.origin.y = 100
    }
    
    func keyboardDidHide(notification:NSNotification){
        
        logoImage.alpha = 1
        
        backView.frame.origin.y = initial_Y
    }
    
}
