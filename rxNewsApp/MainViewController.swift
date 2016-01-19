//
//  ViewController.swift
//  rxNewsApp
//
//  Created by Shakugan on 15/10/3.
//  Copyright (c) 2015年 Shakugan. All rights reserved.
//
import UIKit

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SlideScrollViewDelegate{
    var slideData = NSMutableArray()
    var dataSource = NSMutableArray()
    var articleID = Int()
    var pageInited = false
    @IBOutlet weak var newsTable: UITableView!
    var slidetitle = UILabel()
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newsTable.estimatedRowHeight = 114
        self.newsTable.rowHeight = UITableViewAutomaticDimension
        
        self.newsTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        
        self.newsTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData(self.articleID)
        })
        
        self.newsTable.mj_header.beginRefreshing()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    请求数据
    func requestData() {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/index", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let normal = resp!.objectForKey("normal_article")
            let slide = resp!.objectForKey("slide_article")
            
            let newsArray = normal?.objectForKey("articles") as! Array<AnyObject>
            let slideArray = slide?.objectForKey("articles") as! Array<AnyObject>
            
            let currentData = NSMutableArray()
            
            for each in newsArray{
                let item = rxNewsItem()
                item.title = each.objectForKey("title") as! String
                item.click = each.objectForKey("click") as! NSNumber
                item.info = each.objectForKey("info") as! String
                item.thumb = each.objectForKey("thumb") as! String
                item.id = each.objectForKey("id") as! NSNumber
                currentData.addObject(item)
            }
            
            let currentSlideData = NSMutableArray()
            
            for each in slideArray{
                let item = rxNewsSlideItem()
                item.title = each.objectForKey("title") as! String
                item.thumb = each.objectForKey("thumb") as! String
                item.id = each.objectForKey("id") as! NSNumber
                currentSlideData.addObject(item)
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.saveData(currentData, localDataName: "rxNewsCache")
                self.saveData(currentSlideData, localDataName: "rxNewsSlideCache")
                
                self.slideData = currentSlideData
                self.dataSource = currentData
                
                self.newsTable.reloadData()
                
                self.newsTable.mj_header.endRefreshing()
            })
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.newsTable)
                
                if let cache = self.getlocalData("rxNewsCache"){
                    self.dataSource = cache as! NSMutableArray
                }
                
                if let slideCache = self.getlocalData("rxNewsSlideCache"){
                    self.slideData = slideCache as! NSMutableArray
                }
                
                self.newsTable.reloadData()
                
                self.newsTable.mj_header.endRefreshing()
        }
    }
    
    //    获取更多数据
    func loadMoreData(id:Int) {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/index?until=\(id)", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let lang: AnyObject? = resp!.objectForKey("normal_article")
            let count = lang?.objectForKey("count") as! Int
            if count==0 {
                self.newsTable.mj_footer.endRefreshingWithNoMoreData()
                return
            }else{
                let array = lang?.objectForKey("articles") as! Array<AnyObject>
                for each in array{
                    let item = rxNewsItem()
                    item.title = each.objectForKey("title") as! String
                    item.click = each.objectForKey("click") as! NSNumber
                    item.info = each.objectForKey("info") as! String
                    item.thumb = each.objectForKey("thumb") as! String
                    item.id = each.objectForKey("id") as! NSNumber
                    self.dataSource.addObject(item)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.newsTable.reloadData()
                self.newsTable.mj_header.endRefreshing()
            })
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.newsTable)
                self.newsTable.mj_footer.endRefreshing()
        }
    }
    
//    横幅点击事件
    func SlideScrollViewDidClicked(index:Int){
        let item = slideData[index] as! rxNewsSlideItem
        let push = WebViewController()
        push.id = item.id as Int
        push.from = "rx"
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    
    //    tableview的datasource和delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.section {
            return 204
        } else {
            return 114
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = newsTable.dequeueReusableCellWithIdentifier("pageCell")!
            let slideImgArray = NSMutableArray()
            let slideTtlArray = NSMutableArray()
            for each in slideData{
                let item = each as! rxNewsSlideItem
                slideImgArray.addObject(item.thumb)
                slideTtlArray.addObject(item.title)
            }
            
            let shadow = UIImage(named: "shadow")
            let myslideView = SlideScrollView(frame: cell.contentView.frame,imgArr:slideImgArray,titArr:slideTtlArray,backShadowImage: shadow)
            myslideView.mydelegate = self
            cell.contentView.addSubview(myslideView)
            return cell
        } else {
            let cell = newsTable.dequeueReusableCellWithIdentifier("rxCell")
            let item = dataSource[indexPath.row] as! rxNewsItem
            let title = cell!.viewWithTag(1) as! UILabel
            let click = cell!.viewWithTag(2) as! UILabel
            let info = cell!.viewWithTag(3) as! UILabel
            let image = cell!.viewWithTag(4) as! UIImageView
            title.text = item.title
            title.font = UIFont.boldSystemFontOfSize(16)
            click.text = String(item.click)
            info.text = item.info
            let url = item.thumb
            image.sd_setImageWithURL(NSURL(string:url))
            return cell!
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.section != 0{
            let item = dataSource[indexPath.row] as! rxNewsItem
            let push = WebViewController()
            push.id = item.id as Int
            self.navigationController?.pushViewController(push, animated: true)
        }
        self.newsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
}

