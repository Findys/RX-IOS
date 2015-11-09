//
//  tsShowCardViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit

class tsShowCardViewController: UIViewController{
    @IBOutlet weak var scrollview: UIScrollView!
    var pid = Int()
    var ifheight=false
    var picheight=Int()
    var picArray = Array<AnyObject>()
    var frame: CGRect = CGRectMake(0, 0, 0, 0)
    var colors:[UIColor] = [UIColor.redColor(), UIColor.blueColor(), UIColor.greenColor(), UIColor.yellowColor()]
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
        //        for index in 0..<colors.count {
//            
//            frame.origin.x = self.scrollview.frame.size.width * CGFloat(index)
//            frame.size = self.scrollview.frame.size
//            self.scrollview.pagingEnabled = true
//            
//            var subView = UIView(frame: frame)
//            subView.backgroundColor = colors[index]
//            self.scrollview .addSubview(subView)
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadscroll(){
        print(self.picArray.count)
        let width=self.view.frame.width
        let height=self.view.frame.height
        for index in 0..<picArray.count {
            var url = picArray[index].objectForKey("url") as! String
            url = "http://pic.ecjtu.net/\(url)"
            let image = UIImageView()
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                image.frame = CGRectMake(CGFloat(index)*width,0
                    ,width,width/UIimage.size.width*UIimage.size.height)
                if self.ifheight==false{
                    self.picheight=Int(image.frame.height)
                }
                else{
                    if Int(image.frame.width)>self.picheight{
                        self.picheight=Int(image.frame.width)
                    }
                }
            })
            frame.origin.x = self.scrollview.frame.size.width * CGFloat(index)
            frame.size = self.scrollview.frame.size
            scrollview.frame.origin.x = width * CGFloat(index)
            self.scrollview.addSubview(image)
        }
        self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))

    }
    
    @IBAction func goBack(sender: AnyObject) {
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
    }
    
    func requestData() {
        let afManager = AFHTTPRequestOperationManager()
        let op =  afManager.GET("http://pic.ecjtu.net/api.php/post/\(pid)",
            parameters:nil,
            success: {  (operation: AFHTTPRequestOperation,
                responseObject: AnyObject) in
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options:NSJSONReadingOptions() )
                self.picArray = json?.objectForKey("pictures") as! Array<AnyObject>
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loadscroll()
                }
            },
            failure: {  (operation: AFHTTPRequestOperation,
                error: NSError) in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
}
