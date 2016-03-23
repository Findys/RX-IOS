//
//  tsShowCardViewController.swift
//
//
//  Created by Geetion on 15/10/6.
//
//

import UIKit
import Alamofire
import VIPhotoView

class tsShowCardViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var share: UIButton!
    
    var scrollview = UIScrollView()
    
    var pid = Int()
    
    var ifloading = Bool()
    
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
        
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "shareFunc")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestData()
        
        scrollview.delegate = self
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.navigationController?.navigationBar.barTintColor =  UIColor(red:0.27, green:0.67, blue:0.67, alpha:1)
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
            
            let background_Y =  WINDOW_HEIGHT-text.frame.height-84
            let background_Height = text.frame.height+20
            background.frame = CGRect(x: 0, y: background_Y, width: WINDOW_WIDTH, height:background_Height )
            background.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            url = "http://pic.ecjtu.net/\(url)"
            
            setImage(index, url: url)
            
            background.addSubview(text)
            
            self.view.addSubview(background)
        }
        
        self.scrollview.contentSize = CGSizeMake(WINDOW_WIDTH * CGFloat(picArray.count),CGFloat(self.view.frame.height))
    }
    
    func setImage(index:Int,url:String){
        
        let image = UIImageView()
        
        image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType, nsurl:NSURL!) -> Void in
            
            let image_X = CGFloat(index)*WINDOW_WIDTH
            
            let image_Y = WINDOW_HEIGHT/2-WINDOW_WIDTH/UIimage.size.width*UIimage.size.height/2-10
            
            let image_Height = WINDOW_WIDTH/UIimage.size.width*UIimage.size.height
            
            
            image.frame = CGRect(x: image_X, y: image_Y, width: WINDOW_WIDTH, height: image_Height)
            
            self.imagearray.append(UIimage)
            
            let longpress = UILongPressGestureRecognizer(target: self, action: "longPress:")
            longpress.minimumPressDuration = 1
            longpress.numberOfTouchesRequired = 1
            
            let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*WINDOW_WIDTH,y:-70
                ,width: WINDOW_WIDTH,height: WINDOW_HEIGHT), andImage: UIimage)
            photoview.userInteractionEnabled = true
            photoview.addGestureRecognizer(longpress)
            
            self.scrollview.addSubview(photoview)
        })
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
        
        Alamofire.request(.GET, "http://pic.ecjtu.net/api.php/post/\(pid)").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                self.picArray = (resp.result.value!.objectForKey("pictures"))! as! Array<AnyObject>
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loadScroll()
                    self.ifloading = true
                }
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
            }
        }
    }
    
    //    long press to save picture
    func longPress(sender:UILongPressGestureRecognizer){
        
        if sender.state == UIGestureRecognizerState.Began{
        
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "保存到图库", doText: "是的", doBlock: { () -> Void in
            
            let img = self.imagearray[Int(self.scrollview.contentOffset.x/WINDOW_WIDTH)] as UIImage
            
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            
            }, parentView: self.view)
        }
    }
    
}
