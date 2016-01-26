//
//  SettingViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/11/4.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate=self
        version.text=String(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)
        headImageGet()
        headImg.layer.cornerRadius = 15
        headImg.clipsToBounds = true
    }
    

    //    图片选择
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let image=info[UIImagePickerControllerOriginalImage] as! UIImage
        let img=RSKImageCropViewController.init(image: image, cropMode: RSKImageCropMode.Circle)
        img.delegate=self
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(img, animated: true, completion: nil)
    }
    
    //    图片取消裁剪
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    图片裁剪结束
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        let imgData = UIImageJPEGRepresentation(croppedImage, CGFloat(1))
        let params:[String:AnyObject] = ["token":userDefault.stringForKey("token")!]
        let afmanager = AFHTTPSessionManager()
        let studentID = userDefault.stringForKey("account")!
        let url = "http://user.ecjtu.net/api/user/\(studentID)/avatar"
        afmanager.POST(url, parameters: params, constructingBodyWithBlock: { (formdata:AFMultipartFormData) -> Void in
            formdata.appendPartWithFileData(imgData!, name: "avatar", fileName: "headimage"+studentID+".jpg", mimeType: "image/jpg")
            }, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
                if( resp!.objectForKey("result")! as! Int == 1){
                    MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "头像上传成功",parentView: self.view)
                    self.headImageGet()
                    self.headImg.image = croppedImage
                }
                
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView: self.view)
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "头像上传中", parentView: self.view)
        afmanager.requestSerializer = AFHTTPRequestSerializer()
        afmanager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as? Set<String>
    }
    
    func headImageGet(){
        let avatar = userDefault.objectForKey("headimg") as! String
        self.headImg.sd_setImageWithURL(NSURL(string: avatar))
        
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
                let push = myStoryBoard.instantiateViewControllerWithIdentifier("feedback")
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