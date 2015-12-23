//
//  CollageViewController.swift
//
//
//  Created by Shakugan on 15/10/5.
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
        // Do any additional setup after loading the view.
        self.collageTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        })
        self.collageTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData(self.articleID)
        })
        self.collageTable.mj_header.beginRefreshing()
        collageTable.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    获取数据
    func loadData() {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/schoolnews", parameters: nil,progress: nil,success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            self.newsArray = resp!.objectForKey("articles") as! Array<AnyObject>
            self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
            let currentData = NSMutableArray()
            for each in self.newsArray{
                let item = CollageItem()
                item.id = each.objectForKey("id") as! NSNumber
                item.info = each.objectForKey("info") as! String
                item.click = each.objectForKey("click") as! NSNumber
                item.title = each.objectForKey("title") as! String
                item.time = each.objectForKey("created_at") as! String
                currentData.addObject(item)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.dataSource = currentData
                self.collageTable.dataSource = self
                self.collageTable.reloadData()
                self.collageTable.mj_header.endRefreshing()
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                self.collageTable.mj_header.endRefreshing()
        }
    }
    
    //    获取更多数据
    func loadMoreData(id:Int) {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/schoolnews?until=\(id)", parameters: nil, progress:nil,success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let count = resp!.objectForKey("count") as! Int
            if count == 0 {
                self.collageTable.mj_footer.endRefreshingWithNoMoreData()
                return
            }
            var array = resp!.objectForKey("articles") as! Array<AnyObject>
            for index in 0...count-1 {
                self.newsArray.append(array[index])
            }
            self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
            self.collageTable.reloadData()
            self.collageTable.mj_footer.endRefreshing()
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                self.collageTable.mj_footer.endRefreshing()
        }
    }
    //    tableview的datasource和delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let item = dataSource[indexPath.row] as! CollageItem
        let push = myStoryBoard.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        push.id = Int(item.id)
        self.navigationController?.pushViewController(push, animated: true)
        self.collageTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = collageTable.dequeueReusableCellWithIdentifier("collageCell")
        let item = dataSource[indexPath.row] as! CollageItem
        let title = cell!.contentView.viewWithTag(1) as! UILabel
        let click = cell!.contentView.viewWithTag(2) as! UILabel
        let info = cell!.contentView.viewWithTag(3) as! UILabel
        let time = cell!.contentView.viewWithTag(4) as! UILabel
        
        time.text = item.time as String
        click.text = String(item.click) as String
        info.text = item.info as String
        title.text = item.title as String
        return cell!
    }
}
