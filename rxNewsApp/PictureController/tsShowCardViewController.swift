//
//  tsShowCardViewController.swift
//
//
//  Created by Geetion on 15/10/6.
//
//

import UIKit
import Social

class tsShowCardViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var share: UIButton!
    var scrollview = UIScrollView()
    var pid = Int()
    var ifloading = Bool()
    var ifheight = false
    var picheight = Int()
    var picArray = Array<AnyObject>()
    let text = UILabel()
    let background = UIView()
    var imagearray = Array<UIImage>()
    
    override func loadView() {
        super.loadView()
        
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        scrollview.frame = self.view.frame
        scrollview.backgroundColor = UIColor.blackColor()
        scrollview.pagingEnabled = true
        scrollview.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(scrollview)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareFunc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
        
        scrollview.delegate = self
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.navigationController?.navigationBar.barTintColor=UIColor(red: 0/255.0, green: 150/255.0, blue: 136/255.0, alpha: 1.0)
        }
        
        self.showTabBar()

    }
    
    override func viewWillAppear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.navigationController?.navigationBar.barTintColor=UIColor.clearColor()
        }
        
        self.hideTabBar()

    }
      
    func loadScroll(){
        
        for index in 0..<picArray.count {
            
            var url = picArray[index].objectForKey("url") as! String
            let detail = picArray[0].objectForKey("detail") as! String
            
            text.text="1/"+String(picArray.count)+"   "+detail
            
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            
            text.frame = CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
            text.lineBreakMode = NSLineBreakMode.ByWordWrapping
            text.numberOfLines = 0
            text.textColor = UIColor.whiteColor()
            text.font = UIFont.boldSystemFontOfSize(15)
            
            background.frame = CGRect(x: 0, y: WINDOW_HEIGHT-text.frame.height-84, width: WINDOW_WIDTH, height: text.frame.height+20)
            background.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            url = "http://pic.ecjtu.net/\(url)"
            
            let image = UIImageView()
            
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, SDImageCacheType cacheType, nsurl:NSURL!) -> Void in
                
                image.frame = CGRectMake(CGFloat(index)*WINDOW_WIDTH,WINDOW_HEIGHT/2-WINDOW_WIDTH/UIimage.size.width*UIimage.size.height/2-10
                    ,WINDOW_WIDTH,WINDOW_WIDTH/UIimage.size.width*UIimage.size.height)
                
                self.imagearray.append(UIimage)
                
                let longpress = UILongPressGestureRecognizer.init(target: self, action: "longPress")
                longpress.allowableMovement = 10
                longpress.minimumPressDuration = 1
                longpress.numberOfTouchesRequired = 1
                
                let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*WINDOW_WIDTH,y:-70
                    ,width: WINDOW_WIDTH,height: WINDOW_HEIGHT), andImage: UIimage)
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
        
        self.scrollview.contentSize = CGSizeMake(WINDOW_WIDTH * CGFloat(picArray.count),CGFloat(picheight))
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        
        if ifloading{
            
            let detail = picArray[Int(scrollview.contentOffset.x/WINDOW_WIDTH)].objectForKey("detail") as! NSString
            
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            
            var current = String(Int(scrollview.contentOffset.x/WINDOW_WIDTH + 1))
            
            if current == "0"{
                current = "1"
            }
            
            let count = String(picArray.count)
            
            text.text = current+"/"+count+"   "+(detail as String)
            
            text.frame = CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
            
            background.frame = CGRect(x: 0, y: WINDOW_HEIGHT-text.frame.height-84, width: WINDOW_WIDTH, height: text.frame.height+20)
        }
    }
    
    func requestData() {
        
        let afManager = AFHTTPSessionManager()
        
        afManager.GET("http://pic.ecjtu.net/api.php/post/\(pid)", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask?, resp:AnyObject?) -> Void in
            
            self.picArray = (resp!.objectForKey("pictures"))! as! Array<AnyObject>
            
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.loadScroll()
                self.ifloading = true
            }
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
            MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
        }
    }
    
    //    分享功能
//    func shareFunc(){
//        
//        let shareParames = NSMutableDictionary()
//        
//        let shareimage=imagearray[Int(scrollview.contentOffset.x/WINDOW_HEIGHT)] as UIImage
//        
//        shareParames.SSDKSetupShareParamsByText("分享内容",
//            images : shareimage,
//            url : NSURL(string:"http://mob.com"),
//            title : "分享标题",
//            type : SSDKContentType.Auto)
//        ShareSDK.showShareActionSheet(self.view, items: nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, Bool end) -> Void in
//            
//            switch state{
//                
//            case SSDKResponseState.Success: print("分享成功")
//            case SSDKResponseState.Fail:    print("分享失败,错误描述:\(error)")
//            case SSDKResponseState.Cancel:  print("分享取消")
//                
//            default:
//                break
//            }
//        }
//    }
    
    
    //    长按保存图片
    func longPress(){
        
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "保存到图库", doText: "是的", doBlock: { () -> Void in
            
            let img = self.imagearray[Int(self.scrollview.contentOffset.x/WINDOW_WIDTH)] as UIImage
            
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            
            }, parentView: self.view)
    }
    
}
