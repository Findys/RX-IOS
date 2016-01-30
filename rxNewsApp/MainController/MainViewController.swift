//
//  ViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/10/3.
//  Copyright (c) 2015年 Geetion. All rights reserved.
//
import UIKit

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SlideScrollViewDelegate{
    
    var slideData = NSMutableArray()
    
    var dataSource = NSMutableArray()
    
    var articleID = Int()
    
    @IBOutlet weak var newsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        set view subtract navigation bar‘s height and status bar’s height
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        //        Set cell’s hight self - change
        self.newsTable.estimatedRowHeight = 114
        self.newsTable.rowHeight = UITableViewAutomaticDimension
        
        //        set
        self.newsTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        
        self.newsTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreData(self.articleID)
        })
        
        self.newsTable.mj_header.beginRefreshing()
        
        
    }
    
    func requestData() {
        
        let afManager = AFHTTPSessionManager()
        
        afManager.GET("http://app.ecjtu.net/api/v1/index", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let normal = resp!.objectForKey("normal_article")
            
            let slide = resp!.objectForKey("slide_article")
            
            let newsArray = normal?.objectForKey("articles") as! NSArray
            
            let slideArray = slide?.objectForKey("articles") as! NSArray
            
            let currentData = NSMutableArray()
            
            self.changeJsonDatatoSlideItem(slideArray, myDataSource: self.slideData)
            
            self.changeJsonDatatoNewsItem(newsArray, myDataSource: currentData)
            
            self.saveData(currentData, localDataName: "rxNewsCache")
            self.saveData(self.slideData, localDataName: "rxNewsSlideCache")
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.dataSource = currentData
                //                reload tabview‘s dataSource
                self.newsTable.reloadData()
                
                self.newsTable.mj_header.endRefreshing()
            })
            
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                //                if cahces exist load cache data
                if let cache = self.getlocalData("rxNewsCache") as? NSMutableArray{
                    self.dataSource = cache
                }
                
                if let slideCache = self.getlocalData("rxNewsSlideCache") as? NSMutableArray{
                    self.slideData = slideCache
                }
                
                self.newsTable.reloadData()
                
                self.newsTable.mj_header.endRefreshing()
        }
    }
    
    //    Convert JSON data to custom item
    func changeJsonDatatoSlideItem(mySlideArray:NSArray,myDataSource:NSMutableArray){
        
        for each in mySlideArray{
            
            let item = rxNewsSlideItem()
            
            item.title = each.objectForKey("title") as! String
            item.thumb = each.objectForKey("thumb") as! String
            item.id = each.objectForKey("id") as! Int
            
            myDataSource.addObject(item)
        }
    }
    
    func changeJsonDatatoNewsItem(myNewsArray:NSArray,myDataSource:NSMutableArray){
        
        for each in myNewsArray{
            
            let item = rxNewsItem()
            
            item.title = each.objectForKey("title") as! String
            item.click = each.objectForKey("click") as! Int
            item.info = each.objectForKey("info") as! String
            item.thumb = each.objectForKey("thumb") as! String
            item.id = each.objectForKey("id") as! Int
            
            myDataSource.addObject(item)
        }
    }
    
    func requestMoreData(id:Int) {
        
        let afManager = AFHTTPSessionManager()
        
        //        If Id is equal to 0 represents there is no more data
        if id == 0{
            self.newsTable.mj_footer.endRefreshingWithNoMoreData()
        }else{
            
            afManager.GET("http://app.ecjtu.net/api/v1/index?until=\(id)", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
                
                let lang = resp!.objectForKey("normal_article")
                
                let array = lang?.objectForKey("articles") as! NSArray
                
                self.changeJsonDatatoNewsItem(array, myDataSource: self.dataSource)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //                reload tabview‘s dataSource
                    self.newsTable.reloadData()
                    
                    self.newsTable.mj_header.endRefreshing()
                })
                }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                    
                    MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                    self.newsTable.mj_footer.endRefreshing()
            }
        }
    }
    
    func SlideScrollViewDidClicked(index:Int){
        
        let item = slideData[index] as! rxNewsSlideItem
        
        let push = WebViewController()
        
        push.id = item.id
        push.from = "rx"
        
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    
    //    tableview的datasource和delegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{

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
            
            push.id = item.id
            
            push.from = "rx"
            
            self.navigationController?.pushViewController(push, animated: true)
        }
        
        self.newsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
}

