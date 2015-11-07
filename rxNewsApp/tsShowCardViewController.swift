//
//  tsShowCardViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit

class tsShowCardViewController: UIViewController,UITableViewDataSource {
    
    @IBOutlet weak var cardTable: UITableView!
    
    var pid = Int()
    var picArray = Array<AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picArray.count
    }
 
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = cardTable.dequeueReusableCellWithIdentifier("tsCardCell")
        let view = cell!.viewWithTag(1)
        let textView = cell!.viewWithTag(2) as! UITextView
        textView.text = picArray[indexPath.row].objectForKey("detail") as! String
        var image = UIImageView()
        if view?.viewWithTag(6) == nil {
            view?.addSubview(image)
            image.tag = 6
        } else {
            image = view?.viewWithTag(6) as! UIImageView
        }
        var url = picArray[indexPath.row].objectForKey("url") as! String
        url = "http://pic.ecjtu.net/\(url)"
        image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
            image.frame = CGRectMake(CGFloat(0),
                CGFloat(0),cell!.frame.width,cell!.frame.width/UIimage.size.width*UIimage.size.height)
        })
        return cell!
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
                self.cardTable.reloadData()
            },
            failure: {  (operation: AFHTTPRequestOperation,
                error: NSError) in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.cardTable)
                
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
}
