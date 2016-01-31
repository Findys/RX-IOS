//
//  TushuoViewController.swift
//
//
//  Created by Geetion on 15/10/5.
//
//

import UIKit
import Alamofire

class TushuoViewController: UIViewController {
    
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
        
        Alamofire.request(.GET, "http://pic.ecjtu.net/api.php/list").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
            }else{
                
            }
        }
        
        let afmanager = AFHTTPSessionManager()
        
        afmanager.GET("http://pic.ecjtu.net/api.php/list", parameters: nil,progress: nil, success: { (nsurl:NSURLSessionDataTask, resp:AnyObject?) -> Void in
            
            let newsArray = resp!.objectForKey("list") as! NSArray
            
            self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! String
            
            let currentData = NSMutableArray()
            
            for each in newsArray{
                
                let item = TuShuoItem(object: each)
                
                currentData.addObject(item)
            }
            
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
    
    func requestMoreData(id:String) {
        
        Alamofire.request(.GET, "http://pic.ecjtu.net/api.php/list?before=\(id)").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let count = resp.result.value!.objectForKey("count") as! Int
                
                if count==0 {
                    
                    self.tushuoTable.mj_footer.endRefreshingWithNoMoreData()
                    
                }else{
                    
                    let newsArray = resp.result.value!.objectForKey("list") as! NSArray
                    
                    self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! String
   
                    for each in newsArray{
                        
                        let item = TuShuoItem(object: each)
                        
                        self.dataSource.addObject(item)
                    }
                }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.tushuoTable.reloadData()
                    
                    self.tushuoTable.mj_footer.endRefreshing()
                })
                
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                self.tushuoTable.mj_footer.endRefreshing()
            }
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

}
