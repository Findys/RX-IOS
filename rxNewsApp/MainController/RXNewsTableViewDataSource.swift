//
//  RXNewsTableViewDataSource.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/31.
//  Copyright © 2016年 Findys. All rights reserved.
//

import UIKit

extension MainViewController:UITableViewDataSource,UITableViewDelegate,SlideScrollViewDelegate {
    
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
            return 106
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
            
            let cell = UITableViewCell()
            
            let slideImgArray = NSMutableArray()
            let slideTtlArray = NSMutableArray()
            
            for each in slideData{
                
                let item = each as! rxNewsSlideItem
                
                slideImgArray.addObject(item.thumb)
                slideTtlArray.addObject(item.title)
            }
            
            let shadow = UIImage(named: "shadow")
            
            let cellFrame = CGRect(x: 0, y: 0, width: WINDOW_WIDTH, height: 204)
            
            let myslideView = SlideScrollView(myFrame: cellFrame,imgArr:slideImgArray,titArr:slideTtlArray,backShadowImage: shadow)
            
            myslideView.mydelegate = self
            
            cell.contentView.addSubview(myslideView)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("rxCell")
            
            let item = dataSource[indexPath.row] as! rxNewsItem
            
            let title = cell!.viewWithTag(1) as! UILabel
            let click = cell!.viewWithTag(2) as! UILabel
            let info = cell!.viewWithTag(3) as! UILabel
            let image = cell!.viewWithTag(4) as! UIImageView
            
            title.text = item.title
            
            click.text = String(item.click)
            
            info.text = item.info
            
            let nsurl = NSURL(string:item.thumb)
            
            image.sd_setImageWithURL(nsurl)
            
            return cell!
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.section != 0{
            
            let item = dataSource[indexPath.row] as! rxNewsItem
            
            let push = WebViewController()
            
            push.id = item.id
            
//            mark the origin
            push.from = "rx"
            
            self.navigationController?.pushViewController(push, animated: true)
        }
        
        self.newsTable.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 2
    }
}
