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
    let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
    let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.height
    var scrollview = UIScrollView()
    var pid = Int()
    var ifloading = Bool()
    var ifheight = false
    @IBOutlet weak var backview: UIView!
    var picheight = Int()
    var picArray = Array<AnyObject>()
    let text = UILabel()
    let background = UIView()
    var imagearray=Array<UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor=UIColor.clearColor()
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        requestData()
        share.addTarget(self, action: "shareFunc", forControlEvents: UIControlEvents.TouchUpInside)
        
        scrollview.delegate = self
        scrollview.frame = CGRectMake(0, 0, backview.frame.width, backview.frame.height)
        scrollview.pagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        self.backview.addSubview(scrollview)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    加载数据
    func loadScroll(){
        
        for index in 0..<picArray.count {
            var url = picArray[index].objectForKey("url") as! String
            let detail = picArray[0].objectForKey("detail") as! String
            
            text.text="1/"+String(picArray.count)+"   "+detail
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            text.frame=CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
            text.lineBreakMode=NSLineBreakMode.ByWordWrapping
            text.numberOfLines=0
            text.textColor=UIColor.whiteColor()
            text.font=UIFont.boldSystemFontOfSize(15)
            
            background.frame=CGRectMake(0, WINDOW_HEIGHT-size.height-60, WINDOW_WIDTH, size.height+60)
            background.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            url = "http://pic.ecjtu.net/\(url)"
            let image = UIImageView()
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                image.frame = CGRectMake(CGFloat(index)*self.WINDOW_WIDTH,self.WINDOW_HEIGHT/2-self.WINDOW_WIDTH/UIimage.size.width*UIimage.size.height/2-10
                    ,self.WINDOW_WIDTH,self.WINDOW_WIDTH/UIimage.size.width*UIimage.size.height)
                self.imagearray.append(UIimage)
                let longpress = UILongPressGestureRecognizer.init(target: self, action: "longPress")
                longpress.allowableMovement = 10
                longpress.minimumPressDuration = 1
                longpress.numberOfTouchesRequired = 1
                let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*self.WINDOW_WIDTH,y:-70
                    ,width: self.backview.frame.width,height: self.backview.frame.height), andImage: UIimage)
                photoview.userInteractionEnabled = true
                photoview.addGestureRecognizer(longpress)
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
            self.view.addSubview(background)
            background.addSubview(text)
        }
        self.scrollview.contentSize = CGSizeMake(self.backview.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))
    }
    
    
    //     页面滑动时重载UI
    func scrollViewDidScroll(scrollView: UIScrollView){
        if ifloading{
            let detail = picArray[Int(scrollview.contentOffset.x/WINDOW_WIDTH)].objectForKey("detail") as! NSString
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            let current = String(Int(scrollview.contentOffset.x/WINDOW_WIDTH + 1))
            let count = String(picArray.count)
            text.text = current+"/"+count+"   "+(detail as String)
            background.frame = CGRect(x: 0, y: WINDOW_HEIGHT-size.height-60, width: WINDOW_WIDTH, height: size.height+60)
            text.frame = CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
        }
    }
    
    //    打开页面获取数据
    func requestData() {
        let afManager = AFHTTPRequestOperationManager()
        let op =  afManager.GET("http://pic.ecjtu.net/api.php/post/\(pid)",
            parameters:nil,
            success: {  (operation: AFHTTPRequestOperation,
                responseObject: AnyObject) in
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options:NSJSONReadingOptions() )
                self.picArray = (json?.objectForKey("pictures"))! as! Array<AnyObject>
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loadScroll()
                    self.ifloading=true
                }
            },
            failure: {  (operation: AFHTTPRequestOperation,
                error: NSError) in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.backview)
                
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
    
    //    分享功能
    func shareFunc(){
        let shareParames = NSMutableDictionary()
        let shareimage=imagearray[Int(scrollview.contentOffset.x/WINDOW_HEIGHT)] as UIImage
        shareParames.SSDKSetupShareParamsByText("分享内容",
            images : shareimage,
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
    
    //    返回时改变navigationbar颜色
    func back(){
        self.navigationController?.navigationBar.barTintColor=UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
    }
    
    //    长按图片事件
    func longPress(){
        //        if gestureRec.state == UIGestureRecognizerState.Began {
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "保存到图库", doText: "是的", doBlock: { () -> Void in
            let img = self.imagearray[Int(self.scrollview.contentOffset.x/self.WINDOW_WIDTH)] as UIImage
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }, parentView: self.backview)
        //        }
    }
    
}
