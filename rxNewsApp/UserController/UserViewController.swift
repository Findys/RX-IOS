//
//  UserViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/10/19.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit
import Alamofire

class UserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var headimage: UIImageView!
    let array = ["成绩查询","课表查询","一卡通查询","图书馆查询","个人设置"]
    let iconArray = ["score","classquery","ecard","library","Untitled"]
    @IBOutlet weak var rxServiceTable: UITableView!
    @IBOutlet weak var username: UILabel!
    
    override func loadView() {
        super.loadView()
        
        self.headimage.layer.cornerRadius = 50
        
        self.headimage.clipsToBounds = true
        
        if let image = userDefault.stringForKey("headimage"){
            if let name = userDefault.stringForKey("name"){
                self.username.text = name
            }
            
            self.headimage.sd_setImageWithURL(NSURL(string: image))
            
        }else{
            if let _  = userDefault.stringForKey("account"){
            getUserData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let iflogin = userDefault.boolForKey("iflogin")
        
        if iflogin == false{
            
            tabBarController!.selectedIndex = 0
            
        }else{
            
            getUserData()
            
        }
    }
    
    //    获取头像
    func getUserData(){
        
        let url = "http://user.ecjtu.net/api/user/" + (userDefault.stringForKey("account"))!
        
        Alamofire.request(.GET, url).responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let avatar = "http://"+((resp.result.value!.objectForKey("user")?.objectForKey("avatar"))! as! String)
                
                userDefault.setObject(avatar, forKey: "headimage")
                
                let name = (resp.result.value!.objectForKey("user")?.objectForKey("name")!) as! String
                
                self.username.text = name
                
                userDefault.setObject(name, forKey: "name")
                
                self.headimage.sd_setImageWithURL(NSURL(string: avatar))
            }

        }
    }
    
    
//    tableview的delegate和datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("rxServiceCell")!
        
        let label = cell.viewWithTag(1) as! UILabel
        
        let image  = cell.viewWithTag(2) as! UIImageView
        
        image.image = UIImage(named:iconArray[indexPath.row])
        
        label.text = array[indexPath.row]
        
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
            MozTopAlertView.showWithType(MozAlertTypeInfo, text: "开发中..", parentView: self.view.viewWithTag(1))
            break
            
            //            图书馆查询
        case 3:
            MozTopAlertView.showWithType(MozAlertTypeInfo, text: "开发中..", parentView: self.view.viewWithTag(1))
            break
            
            //            个人设置
        case 4:
            let push = myStoryBoard.instantiateViewControllerWithIdentifier("setting")
            push.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(push, animated: true)
            break
            
        default:break
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
