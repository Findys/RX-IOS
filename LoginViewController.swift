//
//  LoginViewController.swift
//  rxNewsApp
//
//  Created by Findys on 15/12/18.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var url="http://user.ecjtu.net/api/login"
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var account: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        login.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    发送用户信息
    func postData(){
        let afManager = AFHTTPSessionManager()
        let mypassword=password.text! as String
        let myaccount=account.text! as String
        afManager.responseSerializer = AFHTTPResponseSerializer()
        let params:[String:String] = ["username": myaccount, "password": mypassword]
        afManager.POST(url, parameters: params, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let json = try! NSJSONSerialization.JSONObjectWithData(resp as! NSData, options: NSJSONReadingOptions())
            print(json)
            let result:AnyObject=(json.objectForKey("result"))!
            if result as! NSObject==1{
                let token=(json.objectForKey("token"))! as! String
                userDefault.setObject(mypassword, forKey: "password")
                userDefault.setObject(token, forKey: "token")
                userDefault.setObject(myaccount, forKey: "account")
                self.headImageGet()
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录错误", parentView:self.view)
            }
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error)
                MozTopAlertView.showWithType(MozAlertTypeError, text: "请检查网络", parentView:self.view)
        }
    }
    
    //        判断是否登录以使输入框失去焦点
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
    
    //    获取头像
    func headImageGet(){
        let afmanager = AFHTTPSessionManager()
        let url = "http://user.ecjtu.net/api/user/" + (userDefault.objectForKey("account")! as! String)
        afmanager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        afmanager.GET(url, parameters: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let avatar = "http://"+((resp!.objectForKey("user")?.objectForKey("avatar"))! as! String)
            let name = (resp!.objectForKey("user")?.objectForKey("name")!) as! String
            userDefault.setObject(name, forKey: "name")
            var headimage = UIImageView()
            headimage.sd_setImageWithURL(NSURL(string: avatar), completed: { (image:UIImage!, error:NSError!, catchType:SDImageCacheType, nsurl:NSURL!) -> Void in
                let imagedata = UIImageJPEGRepresentation(headimage.image!, CGFloat(100))
                userDefault.setObject(imagedata, forKey: "headimage")
                 self.dismissViewControllerAnimated(true, completion: nil)
            })
            iflogin = true
            self.dismissViewControllerAnimated(true, completion: nil)
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                print(error)
        }
    }


}
