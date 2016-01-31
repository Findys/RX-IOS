//
//  TuShuoTableViewDataSource.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/31.
//  Copyright © 2016年 Findys. All rights reserved.
//

import Foundation
extension TushuoViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tushuoCell")
        
        let view = cell!.viewWithTag(1)
        let title = cell!.viewWithTag(2) as! UILabel
        let click = cell!.viewWithTag(3) as! UILabel
        let info = cell!.viewWithTag(4) as! UILabel
        let time = cell!.viewWithTag(5) as! UILabel
        
        let item = dataSource[indexPath.row] as! TuShuoItem
        
        title.text = item.title as String
        click.text = item.click
        info.text = item.info as String
        time.text = timeStampToString(item.time)
        
        let url = "http://\(item.thumb)" as NSString
        
        var image = UIImageView()
        
        if view?.viewWithTag(6) == nil {
            
            view?.addSubview(image)
            image.tag = 6
        } else {
            image = view?.viewWithTag(6) as! UIImageView
        }
        image.sd_setImageWithURL(NSURL(string:url as String), completed: { (UIimage:UIImage!, error:NSError!, SDImageCacheType cacheType, nsurl:NSURL!) -> Void in
            
            image.frame = CGRectMake(CGFloat(0),
                CGFloat(0),cell!.frame.width,cell!.frame.width/UIimage.size.width*UIimage.size.height)
        })
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let push = tsShowCardViewController()
        
        let item = dataSource[indexPath.row] as! TuShuoItem
        
        push.pid = Int(item.pid)!
        
        self.navigationController?.pushViewController(push, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}