//
//  tsShowCardViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit
import Social

class tsShowCardViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var scrollview: UIScrollView!
    var pid = Int()
    var ifloading = Bool()
    var ifheight = false
    var picheight = Int()
    var picArray = Array<AnyObject>()
    let text = UILabel()
    let background = UIView()
    var width = CGFloat()
    var height = CGFloat()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        share.addTarget(self, action: "sharefunc", forControlEvents: UIControlEvents.TouchUpInside)
        width = self.view.frame.width
        height = self.view.frame.height
        requestData()
        scrollview.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadscroll(){
        for index in 0..<picArray.count {
            var url = picArray[index].objectForKey("url") as! String
            let detail = picArray[0].objectForKey("detail") as! String
            
            text.text="1/"+String(picArray.count)+"   "+detail
            let size=detail.boundingRectWithSize(CGSize(width: width, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            text.frame=CGRect(x: 10, y:0, width: width-20, height: size.height+20)
            text.lineBreakMode=NSLineBreakMode.ByWordWrapping
            text.numberOfLines=0
            text.textColor=UIColor.whiteColor()
            text.font=UIFont.boldSystemFontOfSize(15)
            
            background.frame=CGRect(x: 0, y: height-size.height-20, width: width, height: size.height+20)
            background.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            url = "http://pic.ecjtu.net/\(url)"
            let image = UIImageView()
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                image.frame = CGRectMake(CGFloat(index)*self.width,self.height/2-self.width/UIimage.size.width*UIimage.size.height/2-10
                    ,self.width,self.width/UIimage.size.width*UIimage.size.height)
                let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*self.width,y: self.view.bounds.origin.y-40
                    ,width: self.view.bounds.size.width,height: self.view.bounds.size.height), andImage: image.image)
                if self.ifheight == false{
                    self.picheight = Int(image.frame.height)
                }
                else{
                    if Int(image.frame.width)>self.picheight{
                        self.picheight = Int(image.frame.width)
                    }
                }
                self.scrollview.addSubview(photoview)
            })
            scrollview.frame.origin.x = width * CGFloat(index)
            self.view.addSubview(background)
            background.addSubview(text)
        }
        self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){         /*页面滑动时重载UI*/
        if ifloading{
        let detail = picArray[Int(scrollview.contentOffset.x/width)].objectForKey("detail") as! NSString
        let size = detail.boundingRectWithSize(CGSize(width: width, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
        let current = String(Int(scrollview.contentOffset.x/width+1))
        let count = String(picArray.count)
        text.text = current+"/"+count+"   "+(detail as String)
        background.frame = CGRect(x: 0, y: height-size.height-20, width: width, height: size.height+20)
        text.frame = CGRect(x: 10, y:0, width: width-20, height: size.height+20)
        }
    }
    
    func requestData() {                        /*打开页面获取数据*/
        let afManager = AFHTTPRequestOperationManager()
        let op =  afManager.GET("http://pic.ecjtu.net/api.php/post/\(pid)",
            parameters:nil,
            success: {  (operation: AFHTTPRequestOperation,
                responseObject: AnyObject) in
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options:NSJSONReadingOptions() )
                self.picArray = (json?.objectForKey("pictures"))! as! Array<AnyObject>
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loadscroll()
                    self.ifloading=true
                }
            },
            failure: {  (operation: AFHTTPRequestOperation,
                error: NSError) in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.scrollview)
                
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
    
    func sharefunc(){
        let shareParames = NSMutableDictionary()
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com"),
            title : "分享标题",
            type : SSDKContentType.Auto)
        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success: print("分享成功")
            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    }
    
    func back(){
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
    }

}
