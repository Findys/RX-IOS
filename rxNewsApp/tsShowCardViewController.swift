//
//  tsShowCardViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit

class tsShowCardViewController: UIViewController,UIScrollViewDelegate{
    @IBOutlet weak var scrollview: UIScrollView!
    var pid = Int()
    var ifheight=false
    var picheight=Int()
    var picArray = Array<AnyObject>()
    let text=UILabel()
    let background=UIView()
    var actualsize=CGSize()
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
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
            let detail=picArray[0].objectForKey("detail") as! String
            text.text="1/"+String(picArray.count)+"   "+detail
            text.frame=CGRect(x: 10, y:0, width: width-20, height: 100)
            text.lineBreakMode=NSLineBreakMode.ByWordWrapping
            text.numberOfLines=0
            text.textColor=UIColor.whiteColor()
            text.font=UIFont.boldSystemFontOfSize(15)
            background.frame=CGRect(x: 0, y: height-text.frame.height, width: width, height: text.frame.height)
            background.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            url = "http://pic.ecjtu.net/\(url)"
            let image = UIImageView()
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                image.frame = CGRectMake(CGFloat(index)*width,height/2-width/UIimage.size.width*UIimage.size.height/2-10
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
            scrollview.frame.origin.x = width * CGFloat(index)
            self.scrollview.addSubview(image)
            self.view.addSubview(background)
            background.addSubview(text)
        }
        self.scrollview.contentSize = CGSizeMake(self.scrollview.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))
        scrollview.delegate=self

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView){
        let width=self.view.frame.width
        let height=self.view.frame.height
        let detail=picArray[Int(scrollview.contentOffset.x/width)].objectForKey("detail") as! String
        text.text=String(Int(scrollview.contentOffset.x/width+1))+"/"+String(picArray.count)+"   "+detail
        background.frame=CGRect(x: 0, y: height-text.frame.height, width: width, height: text.frame.height)
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
                print(json)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.loadscroll()
                }
            },
            failure: {  (operation: AFHTTPRequestOperation,
                error: NSError) in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.scrollview)
                
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
}
