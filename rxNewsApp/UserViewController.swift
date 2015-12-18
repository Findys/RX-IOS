//
//  UserViewController.swift
//  rxNewsApp
//
//  Created by Shakugan on 15/10/19.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var headimage: UIImageView!
    let array = ["成绩查询","课表查询","一卡通查询","图书馆查询","个人设置"]
    let iconArray = ["score","classquery","ecard","book","Untitled"]
    @IBOutlet weak var rxServiceTable: UITableView!
    @IBOutlet weak var username: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rxServiceTable.dataSource=self
        rxServiceTable.delegate=self
        self.headimage.layer.cornerRadius = 50
        self.headimage.clipsToBounds = true
        if let _ = userDefault.objectForKey("headimage"){
            self.headimage.image = UIImage(data: userDefault.objectForKey("headimage")as! NSData)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    返回Section数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //    获取每个Cell的数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = rxServiceTable.dequeueReusableCellWithIdentifier("rxServiceCell")!
        let label=cell.viewWithTag(1) as! UILabel
        let image=cell.viewWithTag(2) as! UIImageView
        image.image = UIImage(named:iconArray[indexPath.row])
        label.text=array[indexPath.row]
        return cell
    }
    
    //    每个cell的点击事件
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
    
}
