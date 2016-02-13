//
//  SettingViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/11/4.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit
import Alamofire
import AFNetworking
import RSKImageCropper

class SettingViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
    
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBOutlet var tableview: UITableView!
    
    override func loadView() {
        super.loadView()

        version.text=String(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)
        
        let avatar = userDefault.URLForKey("headimage")
        self.headImg.sd_setImageWithURL(avatar)
        
        headImg.layer.cornerRadius = 15
        headImg.clipsToBounds = true
    }
    
    //    图片选择
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imgData = UIImageJPEGRepresentation(image, CGFloat(1))
        
        let params = ["token":userDefault.stringForKey("token")!]
        
                let afmanager = AFHTTPSessionManager()
        
        let studentID = userDefault.stringForKey("account")!
        
        let url = "http://user.ecjtu.net/api/user/\(studentID)/avatar"

                afmanager.POST(url, parameters: params, constructingBodyWithBlock: { (formdata:AFMultipartFormData) -> Void in
                    formdata.appendPartWithFileData(imgData!, name: "avatar", fileName: "headimage"+studentID+".jpg", mimeType: "image/jpg")
                    }, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
                        let avatar = resp?.objectForKey("avatar") as! String
                        
                        let nsurl = NSURL(string: avatar)
                        
                        userDefault.setURL(nsurl, forKey: "headImage")
                        
        
        
                    }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                        print(error)
                }
        
                afmanager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        switch indexPath.section{
            
        case 0:
            
            switch indexPath.row{
                
                //            修改头像
            case 0:
                let imagepicker=UIImagePickerController()
                imagepicker.delegate=self
                imagepicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
                imagepicker.allowsEditing = true
                self.presentViewController(imagepicker, animated: true, completion: nil)
                break
                
                //            修改用户名
            case 1:
                break
                
                //            修改密码
            case 2: break
                
            default:break
                
            }
            break
            
        case 1:
            
            switch indexPath.row{
                //                反馈建议
            case 0:
                let push = myStoryBoard.instantiateViewControllerWithIdentifier("feedback") as! FeedBackViewController
                self.navigationController?.pushViewController(push, animated: true)
                break
                
                //            好评
            case 1:
                break
                
                //            关于我们
            case 3:
                let push = myStoryBoard.instantiateViewControllerWithIdentifier("about")
                push.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(push, animated: true)
                break
                
            default:break
            }
            break
            
            //        注销账户
        case 2:
            let ALERT = DXAlertView.init(title: "提示", contentText: "真的要注销吗？", leftButtonTitle: "是的", rightButtonTitle: "点错了")
            ALERT.show()
            ALERT.leftBlock={
                userDefault.setBool(false, forKey: "iflogin")
                userDefault.removeObjectForKey("account")
                self.navigationController?.popViewControllerAnimated(true)
            }
        default:break
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}