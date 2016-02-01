//
//  ViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/10/3.
//  Copyright (c) 2015年 Geetion. All rights reserved.
//
import UIKit
import Alamofire

class MainViewController: UIViewController{
    
    var slideData = NSMutableArray()
    
    var dataSource = NSMutableArray()
    
    var articleID = Int()
    
    @IBOutlet weak var newsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //                if cahces exist load cache data
        if let cache = self.getlocalData("rxNewsCache") as? NSMutableArray{
            self.dataSource = cache
        }
        
        if let slideCache = self.getlocalData("rxNewsSlideCache") as? NSMutableArray{
            self.slideData = slideCache
        }
        
        requestData()
        
        //        set view subtract navigation bar‘s height and status bar’s height
        self.edgesForExtendedLayout = UIRectEdge.Bottom
        
        //        Set cell’s hight self - change
        self.newsTable.estimatedRowHeight = 114
        self.newsTable.rowHeight = UITableViewAutomaticDimension
        
        //        set refresh header and footer
        self.newsTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        
        self.newsTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreData(self.articleID)
        })
    }
    
    func requestData() {
        
        Alamofire.request(.GET, "http://app.ecjtu.net/api/v1/index").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let normal = resp.result.value!.objectForKey("normal_article")
                
                let slide = resp.result.value!.objectForKey("slide_article")
                
                let newsArray = normal?.objectForKey("articles") as! NSArray
                
                let slideArray = slide?.objectForKey("articles") as! NSArray
                
                let currentData = NSMutableArray()
                
                let currentSlideData = NSMutableArray()
                
                for each in newsArray{
                    
                    let item = rxNewsItem(object: each)
                    
                    currentData.addObject(item)
                }
                
                for each in slideArray{
                    
                    let item = rxNewsSlideItem(object: each)
                    
                    currentSlideData.addObject(item)
                }
                
                self.saveData(currentData, localDataName: "rxNewsCache")
                self.saveData(currentSlideData,localDataName: "rxNewsSlideCache")
                
                self.slideData = currentSlideData
                
                self.dataSource = currentData
                
                self.newsTable.reloadData()
                
                self.newsTable.mj_header.endRefreshing()

            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                self.newsTable.mj_header.endRefreshing()
            }
        }
    }
    
    func requestMoreData(id:Int) {
        
        if id == 0{
            self.newsTable.mj_footer.endRefreshingWithNoMoreData()
        }else{
            
            Alamofire.request(.GET, "http://app.ecjtu.net/api/v1/index?until=\(id)").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
                if resp.result.isSuccess{
                    
                    let lang = resp.result.value!.objectForKey("normal_article")
                    
                    let array = lang!.objectForKey("articles") as! NSArray
                    
                    for each in array{
                        
                        let item = rxNewsItem(object: each)
                        
                        self.dataSource.addObject(item)
                    }
                    
                    self.newsTable.reloadData()
                    
                    self.newsTable.mj_header.endRefreshing()
                    
                }else{
                    MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                    self.newsTable.mj_footer.endRefreshing()
                }
            }
        }
    }
    
    
}

