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
    @IBOutlet weak var collageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.collageTable.header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        })
        self.collageTable.footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData(self.articleID)
        })
        self.collageTable.header.beginRefreshing()
        collageTable.delegate=self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    segue页面跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let vc = segue.destinationViewController as! WebViewController
        vc.id = cell.tag
        vc.hidesBottomBarWhenPushed = true
    }
    
    //    获取数据
    func loadData() {
        let afManager = AFHTTPRequestOperationManager()
        let op = afManager.GET("http://app.ecjtu.net/api/v1/schoolnews", parameters: nil,
            success: { (operation:AFHTTPRequestOperation, response:AnyObject) -> Void in
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(response as! NSData , options:NSJSONReadingOptions() )
                self.newsArray = json?.objectForKey("articles") as! Array<AnyObject>
                self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
                self.collageTable.reloadData()
                self.collageTable.header.endRefreshing()
            },
            failure:{ (operation:AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                self.collageTable.header.endRefreshing()
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
    
    //    获取更多数据
    func loadMoreData(id:Int) {
        let afManager = AFHTTPRequestOperationManager()
        let op = afManager.GET("http://app.ecjtu.net/api/v1/schoolnews?until=\(id)", parameters: nil,
            success: { (operation:AFHTTPRequestOperation, response:AnyObject) -> Void in
                let json: AnyObject? = try? NSJSONSerialization.JSONObjectWithData(response as! NSData , options:NSJSONReadingOptions() )
                let count = json?.objectForKey("count") as! Int
                if count == 0 {
                    self.collageTable.footer.noticeNoMoreData()
                    return
                }
                var array = json?.objectForKey("articles") as! Array<AnyObject>
                for index in 0...count-1 {
                    self.newsArray.append(array[index])
                }
                self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
                self.collageTable.reloadData()
                self.collageTable.footer.endRefreshing()
            },
            failure:{ (operation:AFHTTPRequestOperation, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.collageTable)
                self.collageTable.footer.endRefreshing()
        })
        op!.responseSerializer = AFHTTPResponseSerializer()
        op!.start()
    }
    
    //    每个cell的点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.collageTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //    返回section数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    //    获取每个cell的数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = collageTable.dequeueReusableCellWithIdentifier("collageCell")
        cell!.tag = newsArray[indexPath.row].objectForKey("id") as! Int
        let title = cell!.contentView.viewWithTag(1) as! UILabel
        let click = cell!.contentView.viewWithTag(2) as! UILabel
        let info = cell!.contentView.viewWithTag(3) as! UILabel
        let time = cell!.contentView.viewWithTag(4) as! UILabel
        
        title.text = newsArray[indexPath.row].objectForKey("title") as? String
        click.text = String(stringInterpolationSegment: newsArray[indexPath.row].objectForKey("click") as! Int)
        info.text = newsArray[indexPath.row].objectForKey("info") as? String
        time.text = newsArray[indexPath.row].objectForKey("created_at") as? String
        return cell!
    }
}
