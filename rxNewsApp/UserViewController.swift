//
//  UserViewController.swift
//  rxNewsApp
//
//  Created by Shakugan on 15/10/19.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    var iflogin=Bool()
    var userDefault = NSUserDefaults.standardUserDefaults()
    var url="http://user.ecjtu.net/api/login"
    @IBOutlet weak var headimage: UIImageView!
    let array = ["成绩查询","课表查询","一卡通查询","图书馆查询","个人设置"]
    let iconArray = ["score","classquery","ecard","book","book"]
    @IBOutlet weak var rxServiceTable: UITableView!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        login.addTarget(self, action: "click", forControlEvents: UIControlEvents.TouchUpInside)
        rxServiceTable.dataSource=self
        rxServiceTable.delegate=self
        if (userDefault.objectForKey("password") == nil){
            iflogin=false
            userDefault.setBool(iflogin, forKey: "iflogin")
        }
//        判断本地是否已缓存密码以判断是否登录
//        if (userDefault.objectForKey("password") == nil)||((userDefault.objectForKey("logout")!) as! NSObject == 1){
//            self.iflogin=false
//        }else{
//            self.iflogin=true
//            self.getdata()
//        }
//        判断是否登录
        if (userDefault.objectForKey("iflogin") != nil) as Bool {
            login.hidden=true
            password.hidden=true
            account.hidden=true
            username.hidden=false
            rxServiceTable.hidden=false
        }else{
            login.hidden=false
            password.hidden=false
            account.hidden=false
            username.hidden=true
            rxServiceTable.hidden=true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        print(userDefault.boolForKey("iflogin"))
        if (userDefault.boolForKey("iflogin")){
            login.hidden=true
            password.hidden=true
            account.hidden=true
            username.hidden=false
            rxServiceTable.hidden=false
        }else{
            login.hidden=false
            password.hidden=false
            account.hidden=false
            username.hidden=true
            rxServiceTable.hidden=true
        }
        
        password.delegate=self

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = rxServiceTable.dequeueReusableCellWithIdentifier("rxServiceCell")!
        let label=cell.viewWithTag(1) as! UILabel
        let image=cell.viewWithTag(2) as! UIImageView
        image.image = UIImage(named:iconArray[indexPath.row])
        label.text=array[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.row{
        case 0:break
        
        case 1:break
        
        case 2:break
        
        case 3:break
        
        case 4:
            let setting=UIStoryboard.init(name: "Main", bundle: nil)
            let push=setting.instantiateViewControllerWithIdentifier("setting")
            self.navigationController?.pushViewController(push, animated: true)
            break
        
        default:break
        }
        self.rxServiceTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func postdata(){
        let afManager = AFHTTPRequestOperationManager()
        let params:[String:String] = ["username": String(account.text!), "password":String(password.text!)]
        let op=afManager.POST(url, parameters:params , success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(resp as! NSData, options:NSJSONReadingOptions() )
            let result:AnyObject=(json?.objectForKey("result"))!
            if result as! NSObject==1{
                let token:AnyObject=(json?.objectForKey("token"))!
                let bpassword=String(self.password.text!)
                let baccount=String(self.account.text!)
                self.iflogin=true
                self.userDefault.setBool(self.iflogin, forKey: "iflogin")
                self.userDefault.setObject(bpassword, forKey: "password")
                self.userDefault.setObject(token, forKey: "token")
                self.userDefault.setObject(baccount, forKey: "account")
                MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "登录成功", parentView:self.view.viewWithTag(1))
                self.viewDidLoad()
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录错误", parentView:self.view.viewWithTag(1))
            }
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录超时", parentView:self.view.viewWithTag(1))
        }
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
    
    func getdata(){
        let apassword=userDefault.objectForKey("password")
        let aaccount=userDefault.objectForKey("account")
        let afManager = AFHTTPRequestOperationManager()
        let params: [String:String] = ["username": String(aaccount!), "password":String(apassword!)]
        let op=afManager.POST(url, parameters:params , success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(resp as! NSData, options:NSJSONReadingOptions() )
                let token:AnyObject=(json?.objectForKey("token"))!
                self.userDefault.setObject(token, forKey: "token")
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录超时", parentView:self.view.viewWithTag(1))
        }
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        判断是否登录以使输入框失去焦点
        if iflogin==false{
        password.resignFirstResponder()
        account.resignFirstResponder()
        }
    }
    
    func click()
    {
        password.resignFirstResponder()
        account.resignFirstResponder()
        if (account.text?.characters.count==14)&&(password.text?.characters.count>=6){
            postdata()
        }else{
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view.viewWithTag(1))
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if(password.text?.characters.count>=6){
            postdata()
        }else{
            password.resignFirstResponder()
        }
        return true
    }

}
