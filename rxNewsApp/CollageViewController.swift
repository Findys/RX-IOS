//
//  CollageViewController.swift
//
//
//  Created by Geetion on 15/10/5.
//
//

import UIKit

class CollageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var newsArray = Array<AnyObject>()
    var articleID = Int()
    var dataSource = NSMutableArray()
    @IBOutlet weak var collageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collageTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        self.collageTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreData(self.articleID)
        })
        self.collageTable.mj_header.beginRefreshing()
    }
    
    //    获取数据
    func requestData() {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/schoolnews", parameters: nil,progress: nil,success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            self.newsArray = resp!.objectForKey("articles") as! Array<AnyObject>
            
            self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
            
            let currentData = NSMutableArray()
            
            for each in self.newsArray{
                
                let item = CollageItem()
                item.id = each.objectForKey("id") as! Int
                item.info = each.objectForKey("info") as! String
                item.click = each.objectForKey("click") as! Int
                item.title = each.objectForKey("title") as! String
                item.time = each.objectForKey("created_at") as! String
                
                currentData.addObject(item)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.saveData(currentData, localDataName: "CollageCache")
                
                self.dataSource = currentData
                
                self.collageTable.reloadData()
                
                self.collageTable.mj_header.endRefreshing()
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                
                self.collageTable.mj_header.endRefreshing()
                
                    if let cache = self.getlocalData("CollageCache") as? NSMutableArray{
                        
                        self.dataSource = cache
                        
                        self.collageTable.reloadData()
                    }
        }
    }
    
    func requestMoreData(id:Int) {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/schoolnews?until=\(id)", parameters: nil, progress:nil,success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let count = resp!.objectForKey("count") as! Int
            if count==0 {
                self.collageTable.mj_footer.endRefreshingWithNoMoreData()
                return
            }else{
                let newsArray = resp!.objectForKey("list") as! Array<AnyObject>
                self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! Int
                for each in newsArray{
                    let item = CollageItem()
                    item.id = each.objectForKey("id") as! Int
                    item.info = each.objectForKey("info") as! String
                    item.click = each.objectForKey("click") as! Int
                    item.title = each.objectForKey("title") as! String
                    item.time = each.objectForKey("created_at") as! String
                    self.dataSource.addObject(item)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collageTable.reloadData()
                self.collageTable.mj_footer.endRefreshing()
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                self.collageTable.mj_footer.endRefreshing()
        }
    }
    
    //    tableview的datasource和delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let item = dataSource[indexPath.row] as! CollageItem
        
        let push = WebViewController()
        
        push.id = item.id
        
        self.navigationController?.pushViewController(push, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("collageCell")
        let item = dataSource[indexPath.row] as! CollageItem
        let title = cell!.viewWithTag(1) as! UILabel
        let click = cell!.viewWithTag(2) as! UILabel
        let info = cell!.viewWithTag(3) as! UILabel
        let time = cell!.viewWithTag(4) as! UILabel
        
        time.text = item.time as String
        click.text = String(item.click) as String
        info.text = item.info as String
        title.text = item.title as String
        return cell!
    }
}
