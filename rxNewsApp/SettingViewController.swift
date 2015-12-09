//
//  SettingViewController.swift
//  rxNewsApp
//
//  Created by HuJian on 15/11/4.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBOutlet var tableview: UITableView!
    var userDefault = NSUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableview.delegate=self
        version.text=String(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)
        
        let himage = userDefault.objectForKey("headimage") as! NSData
        let h2image = UIImage.init(data: himage)! as UIImage
        headImg.image = h2image
        headImg.layer.cornerRadius = 15
        headImg.clipsToBounds = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    view将出现时调用
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
    }
    
    //    每个Cell的点击事件
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
                let feedback = UIStoryboard.init(name: "Main", bundle: nil)
                let push = feedback.instantiateViewControllerWithIdentifier("feedback")
                self.navigationController?.pushViewController(push, animated: true)
                break
                
                //            好评
            case 1:
                break
                
                //            关于我们
            case 3:
                let setting = UIStoryboard.init(name: "Main", bundle: nil)
                let push = setting.instantiateViewControllerWithIdentifier("about")
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
                self.userDefault.setBool(false, forKey: "iflogin")
                self.navigationController?.popViewControllerAnimated(true)
                self.userDefault.removeObjectForKey("account")
            }
        default:break
        }
        self.tableview.deselectRowAtIndexPath(indexPath, animated: true)
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
        let IMGDATA = UIImageJPEGRepresentation(croppedImage, CGFloat(1))
        userDefault.setObject(IMGDATA, forKey: "headimage")
        let params:[String:AnyObject] = ["token":userDefault.stringForKey("token")!]
        let afmanager = AFHTTPRequestOperationManager()
        let studentID = userDefault.stringForKey("account")!
        let url = "http://user.ecjtu.net/api/user/\(studentID)/avatar"
        afmanager.POST(url, parameters: params, constructingBodyWithBlock: { (formdata:AFMultipartFormData) -> Void in
            formdata.appendPartWithFileData(IMGDATA!, name: "avatar", fileName: "headimage"+studentID+".jpg", mimeType: "image/jpg")
            }, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
                if( resp.objectForKey("result")! as! Int == 1){
                    MozTopAlertView.showWithType(MozAlertTypeSuccess, text: "头像上传成功",parentView: self.view)
                    self.headImageGet()
                }
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView: self.view)
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "头像上传中", parentView: self.view)
        afmanager.requestSerializer = AFHTTPRequestSerializer()
        afmanager.responseSerializer.acceptableContentTypes = NSSet(object: "text/html") as Set<NSObject>
    }
    
    //    获取头像
    func headImageGet(){
        let afmanager = AFHTTPRequestOperationManager()
        let URL = "http://user.ecjtu.net/api/user/" + (userDefault.objectForKey("account")! as! String)
        let GET = afmanager.GET(URL, parameters: nil, success: { (AFHTTPRequestOperation, resp:AnyObject) -> Void in
            let JSON: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(resp as! NSData, options:NSJSONReadingOptions() )
            let AVATAR_URL = "http://"+((JSON?.objectForKey("user")?.objectForKey("avatar"))! as! String)
            self.headImg.sd_setImageWithURL(NSURL(string: AVATAR_URL), completed: { (image:UIImage!, error:NSError!, catchType:SDImageCacheType, nsurl:NSURL!) -> Void in
                let IMGDATA = UIImageJPEGRepresentation(self.headImg.image!, CGFloat(1))
                self.userDefault.setObject(IMGDATA, forKey: "headimage")
            })
            }) { (AFHTTPRequestOperation, error:NSError) -> Void in
                print(error)
        }
        GET?.responseSerializer = AFHTTPResponseSerializer()
        GET?.start()
        
    }
}