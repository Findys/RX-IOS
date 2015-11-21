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
    @IBOutlet weak var headimage: UIImageView!
    var userDefault = NSUserDefaults.standardUserDefaults()
    var url="http://user.ecjtu.net/api/login"
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
        if let img = userDefault.objectForKey("headimage"){
        var himage=userDefault.objectForKey("headimage") as! UIImage
        headimage.image=himage as! UIImage
        }
        if (userDefault.objectForKey("password") == nil){
            iflogin=false
            userDefault.setBool(iflogin, forKey: "iflogin")
        }
        
        reload()
    }
    
    override func viewDidAppear(animated: Bool) {
        reload()
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
        let mypassword=password.text! as String
        let myaccount=account.text! as String
        let params:[String:String] = ["username": myaccount, "password": mypassword]
        let op=afManager.POST(url, parameters:params , success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(resp as! NSData, options:NSJSONReadingOptions() )
            let result:AnyObject=(json?.objectForKey("result"))!
            if result as! NSObject==1{
                let token=(json?.objectForKey("token"))! as! String
                self.iflogin=true
                self.userDefault.setBool(self.iflogin, forKey: "iflogin")
                self.userDefault.setObject(mypassword, forKey: "password")
                self.userDefault.setObject(token, forKey: "token")
                self.userDefault.setObject(myaccount, forKey: "account")
                MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "登录成功", parentView:self.view.viewWithTag(1))
                self.reload()
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录错误", parentView:self.view.viewWithTag(1))
            }
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "登录超时", parentView:self.view.viewWithTag(1))
        }
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }

//        判断是否登录以使输入框失去焦点
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
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
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view.viewWithTag(1))
            password.resignFirstResponder()
        }
        return true
    }
    
//    判断是否已登录并且刷新界面
    func reload(){
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
        
    }

}
