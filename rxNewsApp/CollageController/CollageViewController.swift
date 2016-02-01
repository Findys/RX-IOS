//
//  CollageViewController.swift
//
//
//  Created by Geetion on 15/10/5.
//
//

import UIKit
import Alamofire

class CollageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var articleID = Int()
    
    var dataSource = NSMutableArray()
    
    @IBOutlet weak var collageTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cache = self.getlocalData("CollageCache") as? NSMutableArray{
            
            self.dataSource = cache
            
        }
        
        requestData()
        
        //        set view subtract navigation bar‘s height and status bar’s height
        self.edgesForExtendedLayout = UIRectEdge.Bottom

        self.collageTable.mj_header = MJRefreshNormalHeader(refreshingBlock: { () -> Void in
            self.requestData()
        })
        self.collageTable.mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: { () -> Void in
            self.requestMoreData(self.articleID)
        })
    }
    
    func requestData() {
        
        Alamofire.request(.GET, "http://app.ecjtu.net/api/v1/schoolnews").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let newsArray = resp.result.value!.objectForKey("articles") as! Array<AnyObject>
                
                self.articleID = newsArray[newsArray.count-1].objectForKey("id") as! Int
                
                let currentData = NSMutableArray()
                
                for each in newsArray{
                    
                    let item = CollageItem(object: each)
                    
                    currentData.addObject(item)
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.saveData(currentData, localDataName: "CollageCache")
                    
                    self.dataSource = currentData
                    
                    self.collageTable.reloadData()
                    
                    self.collageTable.mj_header.endRefreshing()
                })
            }else{
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                self.collageTable.mj_header.endRefreshing()
            }
        }
    }
    
    
    func requestMoreData(id:Int) {
        
        Alamofire.request(.GET, "http://app.ecjtu.net/api/v1/schoolnews?until=\(id)").responseJSON { (resp:Response<AnyObject, NSError>) -> Void in
            
            if resp.result.isSuccess{
                
                let count = resp.result.value!.objectForKey("count") as! Int
                
                if count==0 {
                    
                    self.collageTable.mj_footer.endRefreshingWithNoMoreData()
                    
                }else{
                    
                    let newsArray = resp.result.value!.objectForKey("list") as! Array<AnyObject>
                    
                    self.articleID = newsArray[newsArray.count-1].objectForKey("pubdate") as! Int
                    
                    for each in newsArray{
                        
                        let item = CollageItem(object: each)
                        
                        self.dataSource.addObject(item)
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.collageTable.reloadData()
                    
                    self.collageTable.mj_footer.endRefreshing()
                })
            }else{
                
                MozTopAlertView.showWithType(MozAlertTypeError, text: "网络超时", parentView:self.view)
                
                self.collageTable.mj_footer.endRefreshing()
            }
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
