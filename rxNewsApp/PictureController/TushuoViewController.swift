//
//  TushuoViewController.swift
//
//
//  Created by Geetion on 15/10/5.
//
//

import UIKit

class TushuoViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var dataSource = NSMutableArray()
    
    var articleID = String()
    
    @IBOutlet weak var tushuoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        set view subtract navigation bar‘s height and status bar’s height
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        self.tushuoTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        
        self.tushuoTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreData(self.articleID)
        })
        
        self.tushuoTable.mj_header.beginRefreshing()
        
    }
    
    func requestData() {
        
        let afmanager = AFHTTPSessionManager()
        
        afmanager.GET("http://pic.ecjtu.net/api.php/list", parameters: nil,progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let newsArray = resp!.objectForKey("list") as! NSArray
            
            self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! String
            
            let currentData = NSMutableArray()
            
            self.changeJsonDatatoItem(newsArray, myDataSource: currentData)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.saveData(currentData, localDataName: "tushuoCache")
                
                self.dataSource = currentData
                
                self.tushuoTable.reloadData()
                
                self.tushuoTable.mj_header.endRefreshing()
            })
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                self.tushuoTable.mj_header.endRefreshing()
                
                if let cache = self.getlocalData("tushuoCache") as? NSMutableArray{
                    
                    self.dataSource = cache
                    
                    self.tushuoTable.reloadData()
                }
        }
    }
    
    func changeJsonDatatoItem(myNewsArray:NSArray,myDataSource:NSMutableArray){
        
        for each in myNewsArray{
            
            let item = TuShuoItem()
            
            item.thumb = each.objectForKey("thumb") as! String
            item.title = each.objectForKey("title") as! String
            item.click = each.objectForKey("click") as! String
            item.info = each.objectForKey("count") as! String
            item.pid = each.objectForKey("pid") as! String
            item.time = each.objectForKey("pubdate") as! String
            
            myDataSource.addObject(item)
        }
    }
    
    
    func requestMoreData(id:String) {
        
        let afManager = AFHTTPSessionManager()
        
        afManager.GET("http://pic.ecjtu.net/api.php/list?before=\(id)", parameters: nil,progress: nil,  success: { (nsurl:NSURLSessionDataTask,resp:AnyObject?) -> Void in
            
            let count = resp!.objectForKey("count") as! Int
            
            if count==0 {
                
                self.tushuoTable.mj_footer.endRefreshingWithNoMoreData()
                
            }else{
                
                let newsArray = resp!.objectForKey("list") as! NSArray
                
                self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! String
                
                self.changeJsonDatatoItem(newsArray, myDataSource: self.dataSource)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.tushuoTable.reloadData()
                
                self.tushuoTable.mj_footer.endRefreshing()
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                self.tushuoTable.mj_footer.endRefreshing()
        }
    }
    
    //    设置时间显示
    func timeStampToString(timeStamp:String)->String {
        
        let string = NSString(string: timeStamp)
        
        let timeSta:NSTimeInterval = string.doubleValue
        
        let dfmatter = NSDateFormatter()
        
        dfmatter.dateFormat="yyyy/MM/dd"
        
        let date = NSDate(timeIntervalSince1970: timeSta)
        
        return dfmatter.stringFromDate(date)
    }
    
    //    tableview的delegate和Datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tushuoCell")
        
        let view = cell!.viewWithTag(1)
        let title = cell!.viewWithTag(2) as! UILabel
        let click = cell!.viewWithTag(3) as! UILabel
        let info = cell!.viewWithTag(4) as! UILabel
        let time = cell!.viewWithTag(5) as! UILabel
        
        let item = dataSource[indexPath.row] as! TuShuoItem
        
        title.text = item.title as String
        click.text = item.click 
        info.text = item.info as String
        time.text = timeStampToString(item.time)
        
        let url = "http://\(item.thumb)" as NSString
        
        var image = UIImageView()
        
        if view?.viewWithTag(6) == nil {
            
            view?.addSubview(image)
            image.tag = 6
        } else {
            image = view?.viewWithTag(6) as! UIImageView
        }
        image.sd_setImageWithURL(NSURL(string:url as String), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
            
            image.frame = CGRectMake(CGFloat(0),
                CGFloat(0),cell!.frame.width,cell!.frame.width/UIimage.size.width*UIimage.size.height)
        })
        
        return cell!
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let push = tsShowCardViewController()
        
        let item = dataSource[indexPath.row] as! TuShuoItem
        
        push.pid = Int(item.pid)!
        
        self.navigationController?.pushViewController(push, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
