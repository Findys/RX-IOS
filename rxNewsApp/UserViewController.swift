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
    let iconArray = ["score","classquery","ecard","book","Untitled"]
    @IBOutlet weak var rxServiceTable: UITableView!
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var login: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        login.addTarget(self, action: "loginClick", forControlEvents: UIControlEvents.TouchUpInside)
        rxServiceTable.dataSource=self
        rxServiceTable.delegate=self
        if let himage = userDefault.objectForKey("headimage"){
        let h2image = UIImage.init(data: himage as! NSData)! as UIImage
        username.text = userDefault.objectForKey("name") as? String
        headimage.image = h2image
        }
        
        headimage.layer.cornerRadius = 50
        headimage.clipsToBounds = true
        
        if (userDefault.objectForKey("password") == nil){
            iflogin=false
            userDefault.setBool(iflogin, forKey: "iflogin")
        }
        
        reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        reload()
        if let himage = userDefault.objectForKey("headimage"){
            let h2image = UIImage.init(data: himage as! NSData)! as UIImage
            username.text = userDefault.objectForKey("name") as? String
            headimage.image = h2image
        }
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
//            成绩查询
        case 0:
            let local = LocalWebViewController()
            local.path = NSBundle.mainBundle().pathForResource("scoreQuery", ofType: "html")!
            self.navigationController?.pushViewController(local, animated: true)
            break
        
//            课表查询
        case 1:
            let local = LocalWebViewController()
            local.path = NSBundle.mainBundle().pathForResource("classQuery", ofType: "html")!
            self.navigationController?.pushViewController(local, animated: true)
            break
        
//            一卡通查询
        case 2:
//            let webview = UIStoryboard.init(name: "Main", bundle: nil)
//            let push = webview.instantiateViewControllerWithIdentifier("webview") as! WebViewController
//            push.path = NSBundle.mainBundle().pathForResource("cardQuery", ofType: "html")!
//            push.ifJs = true
//            self.navigationController?.pushViewController(push, animated: true)
            MozTopAlertView.showWithType(MozAlertTypeInfo, text: "开发中..", parentView: self.view.viewWithTag(1))
            break
        
//            图书馆查询
        case 3:
//            let webview = UIStoryboard.init(name: "Main", bundle: nil)
//            let push = webview.instantiateViewControllerWithIdentifier("webview") as! WebViewController
//            push.path = NSBundle.mainBundle().pathForResource("review", ofType: "html")!
//            push.ifJs = true
//            self.navigationController?.pushViewController(push, animated: true)
            MozTopAlertView.showWithType(MozAlertTypeInfo, text: "开发中..", parentView: self.view.viewWithTag(1))
            break
        
//            个人设置
        case 4:
            let setting=UIStoryboard.init(name: "Main", bundle: nil)
            let push=setting.instantiateViewControllerWithIdentifier("setting")
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
        
        default:break
        }
        self.rxServiceTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
//    发送用户信息
    func postData(){
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
                self.headImageGet()
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
    
    func loginClick()
    {
        password.resignFirstResponder()
        account.resignFirstResponder()
        if (account.text?.characters.count==14)&&(password.text?.characters.count>=6){
            postData()
        }else{
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view.viewWithTag(1))
        }
    }
    
//    监听键盘的return的事件
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        if(password.text?.characters.count>=6){
            postData()
        }else{
            MozTopAlertView.showWithType(MozAlertTypeWarning, text: "输入错误", parentView:self.view.viewWithTag(1))
            password.resignFirstResponder()
        }
        return true
    }
    
//    获取头像
    func headImageGet(){
        let afManager = AFHTTPRequestOperationManager()
        let url = "http://user.ecjtu.net/api/user/" + (userDefault.objectForKey("account")! as! String)
        let op = afManager.GET(url, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(resp as! NSData, options:NSJSONReadingOptions() )
            let avatar = "http://"+((json?.objectForKey("user")?.objectForKey("avatar"))! as! String)
            let name = (json?.objectForKey("user")?.objectForKey("name")!) as! String
            self.username.text = name
            self.userDefault.setObject(name, forKey: "name")
            self.headimage.sd_setImageWithURL(NSURL(string: avatar), completed: { (image:UIImage!, error:NSError!, catchType:SDImageCacheType, nsurl:NSURL!) -> Void in
                let imagedata = UIImageJPEGRepresentation(self.headimage.image!, CGFloat(100))
                self.userDefault.setObject(imagedata, forKey: "headimage")
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
        op?.responseSerializer = AFHTTPResponseSerializer()
        op?.start()
        
    }
    
//    判断是否已登录并且刷新界面
    func reload(){
        
        if (userDefault.boolForKey("iflogin")){
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.login.alpha = 0
                self.password.alpha = 0
                self.account.alpha = 0
                self.username.alpha = 1
                self.rxServiceTable.alpha = 1
                self.headimage.alpha = 1
            })
            login.hidden = true
            password.hidden = true
            account.hidden = true
            username.hidden = false
            rxServiceTable.hidden = false
            headimage.hidden = false
            self.view.viewWithTag(1)!.backgroundColor = UIColor(red: 38/255.0, green: 165/255.0, blue: 153/255.0, alpha: 1.0)
            
        }else{
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.login.alpha = 1
                self.password.alpha = 1
                self.account.alpha = 1
                self.username.alpha = 0
                self.rxServiceTable.alpha = 0
                self.headimage.alpha = 0
            })
            login.hidden = false
            password.hidden = false
            account.hidden = false
            username.hidden = true
            rxServiceTable.hidden = true
            headimage.hidden = true
            self.view.viewWithTag(1)!.backgroundColor = UIColor.whiteColor()
        }
        
        if let himage = userDefault.objectForKey("headimage"){
            let h2image = UIImage.init(data: himage as! NSData)! as UIImage
            headimage.image = h2image
        }

        
    }

}
