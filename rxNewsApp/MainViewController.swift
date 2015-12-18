//
//  ViewController.swift
//  rxNewsApp
//
//  Created by Shakugan on 15/10/3.
//  Copyright (c) 2015年 Shakugan. All rights reserved.
//
import UIKit

class MainViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate, UIPageViewControllerDelegate{
    let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
    var newsArray = Array<AnyObject>()
    var slideArray = Array<AnyObject>()
    var articleID = Int()
    var isiOS7 = false
    var pageInited = false
    @IBOutlet weak var newsTable: UITableView!
    var scrollview: UIScrollView!
    var slidetitle = UILabel()
    var pageControl = UIPageControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let version = UIDevice.currentDevice().systemVersion
        let flag = version.compare("8.0.0", options: NSStringCompareOptions.NumericSearch)
        if flag == .OrderedAscending {
            isiOS7 = true
            
        } else {
            self.newsTable.estimatedRowHeight = 114
            self.newsTable.rowHeight = UITableViewAutomaticDimension
        }
        self.newsTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.loadData()
        })
        self.newsTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.loadMoreData(self.articleID)
        })
        self.newsTable.mj_header.beginRefreshing()
        newsTable.delegate=self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //    segue页面跳转
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "rxNews" {
            let cell = sender as! UITableViewCell
            let vc = segue.destinationViewController as! WebViewController
            vc.id = cell.tag
            vc.hidesBottomBarWhenPushed = true
        }
        if segue.identifier == "rxPageNews" {
            let vc = segue.destinationViewController as! WebViewController
            vc.id = (slideArray[pageControl.currentPage].objectForKey("id") as? Int)!
            vc.hidesBottomBarWhenPushed = true
        }
    }
    
    //    返回cell的高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if 0 == indexPath.row {
            return 204
        } else {
            return 114
        }
    }
    
    //    返回section数量
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    //    获取每个cell的值
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = newsTable.dequeueReusableCellWithIdentifier("pageCell")!
            
            scrollview = cell.viewWithTag(1) as! UIScrollView
            scrollview.scrollEnabled = true
            scrollview.pagingEnabled = true
            scrollview.scrollsToTop = false
            scrollview.delegate=self
            
            if cell.viewWithTag(112) == nil {
                pageControl = UIPageControl(frame: CGRectMake(0,0,70,(cell.viewWithTag(111)!.frame.height)))
                let leftConstraint = NSLayoutConstraint(item: pageControl,
                    attribute: NSLayoutAttribute.Trailing,
                    relatedBy: NSLayoutRelation.Equal,
                    toItem: self.view,
                    attribute: NSLayoutAttribute.Trailing,
                    multiplier: 1,
                    constant: 0)
                pageControl.numberOfPages = 3
                pageControl.tag = 112
                cell.viewWithTag(111)?.addSubview(pageControl)
                pageControl.addConstraint(leftConstraint)
            }
            pageControl = cell.viewWithTag(112) as! UIPageControl
            pageInited = true
            for i in 0...2 {
                var view = UIImageView()
                view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "scrollViewClick"))
                view.userInteractionEnabled=true
                if scrollview.viewWithTag(i+20) == nil {
                    self.slidetitle = cell.viewWithTag(11) as! UILabel
                    slidetitle.text = slideArray[indexPath.row].objectForKey("title") as? String
                    view.tag = i+20
                    scrollview.addSubview(view)
                } else {
                    view = scrollview.viewWithTag(i+20) as! UIImageView
                }
                let url = slideArray[i].objectForKey("thumb") as! String
                view.sd_setImageWithURL(NSURL(string:url), completed: { (uiImage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                    if (error != nil){
                        MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.newsTable)
                    }
                    else{
                        view.frame = CGRectMake(CGFloat(Int(cell.frame.width)*i),
                            CGFloat(0),self.WINDOW_WIDTH,self.WINDOW_WIDTH/uiImage.size.width*uiImage.size.height)
                        self.scrollview.contentSize = CGSizeMake(CGFloat(Int(self.WINDOW_WIDTH)*3),0)
                    }
                })
            }
            return cell
        } else {
            let cell = newsTable.dequeueReusableCellWithIdentifier("rxCell")
            cell!.tag = newsArray[indexPath.row-1].objectForKey("id") as! Int
            let title = cell!.contentView.viewWithTag(1) as! UILabel
            let click = cell!.contentView.viewWithTag(2) as! UILabel
            let info = cell!.contentView.viewWithTag(3) as! UILabel
            let image = cell!.contentView.viewWithTag(4) as! UIImageView
            title.text = newsArray[indexPath.row-1].objectForKey("title") as? String
            title.font = UIFont.boldSystemFontOfSize(16)
            click.text = String(stringInterpolationSegment: newsArray[indexPath.row-1].objectForKey("click") as! Int)
            info.text = newsArray[indexPath.row-1].objectForKey("info") as? String
            let url = newsArray[indexPath.row-1].objectForKey("thumb") as! String
            image.sd_setImageWithURL(NSURL(string:url))
            return cell!
        }
    }
    
    //    请求数据
    func loadData() {
        let afManager = AFHTTPSessionManager()
        afManager.GET("http://app.ecjtu.net/api/v1/index", parameters: nil, progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            let normal = resp!.objectForKey("normal_article")
            let slide = resp!.objectForKey("slide_article")
            self.newsArray = normal?.objectForKey("articles") as! Array<AnyObject>
            self.slideArray = slide?.objectForKey("articles") as! Array<AnyObject>
            self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
            self.newsTable.reloadData()
            self.newsTable.hidden=false
            self.newsTable.mj_header.endRefreshing()
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.newsTable)
                //                self.newsTable.hidden=true
                //                let backimage=UIImageView()
                //                backimage.image=UIImage(named: "IMG_0034")
                //                backimage.frame=CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
                //                self.view.addSubview(backimage)
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
            }
            var array = lang?.objectForKey("articles") as! Array<AnyObject>
            for index in 0...count-1 {
                self.newsArray.append(array[index])
            }
            self.articleID = self.newsArray[self.newsArray.count-1].objectForKey("id") as! Int
            self.newsTable.reloadData()
            self.newsTable.mj_footer.endRefreshing()
            }) { (nsurl:NSURLSessionDataTask?, error:NSError) -> Void in
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.newsTable)
                self.newsTable.mj_footer.endRefreshing()
        }
    }
    
    //    横幅滚动更新pagecontroller
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if pageInited {
            let pageWidth = scrollview.frame.width
            let page = Int(floor((scrollview.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
            pageControl.currentPage=page
            self.slidetitle.text = slideArray[page].objectForKey("title") as? String
        }
    }
    
    //    横幅点击事件
    func scrollViewClick() {
        let wv=UIStoryboard.init(name:"Main", bundle: nil)
        let push = wv.instantiateViewControllerWithIdentifier("webview") as! WebViewController
        push.hidesBottomBarWhenPushed = true
        push.id = (slideArray[pageControl.currentPage].objectForKey("id") as? Int)!
        push.from = "rx"
        self.navigationController?.pushViewController(push, animated: true)
    }
    
    //    使cell取消选中状态
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.newsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

