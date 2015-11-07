//
//  SettingViewController.swift
//  rxNewsApp
//
//  Created by HuJian on 15/11/4.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RSKImageCropViewControllerDelegate{
    @IBOutlet weak var head: UIImageView!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBOutlet var tableview: UITableView!
    var userDefault = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableview.delegate=self
        version.text=String(NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleShortVersionString")!)
        password.text=String(userDefault.objectForKey("password")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        switch indexPath.section{
        case 0:
            switch indexPath.row{
            case 0:
                let imagepicker=UIImagePickerController()
                imagepicker.delegate=self
                imagepicker.sourceType=UIImagePickerControllerSourceType.PhotoLibrary
                self.presentViewController(imagepicker, animated: true, completion: nil)
                break
            case 1:
                break
            case 2: break
            default:break
                
            }
            break
        case 1:
            switch indexPath.row{
            case 0:break
            case 1:break
            case 2:break
            case 3:break
            default:break
            }
            break
        case 2:
            let alert = DXAlertView.init(title: "提示", contentText: "真的要注销吗？", leftButtonTitle: "是的", rightButtonTitle: "不，点错了")
            alert.show()
            alert.leftBlock={
                let logout=true
                self.userDefault.setObject(logout, forKey: "logout")
                self.navigationController?.popViewControllerAnimated(true)
            }
        default:break
        }
        
    }

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]){
        let image=info[UIImagePickerControllerOriginalImage] as! UIImage
        let img=RSKImageCropViewController.init(image: image, cropMode: RSKImageCropMode.Circle)
        img.delegate=self
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(img, animated: true, completion: nil)
    }
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imageCropViewController(controller: RSKImageCropViewController!, didCropImage croppedImage: UIImage!, usingCropRect cropRect: CGRect) {
        self.head.image=croppedImage
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}