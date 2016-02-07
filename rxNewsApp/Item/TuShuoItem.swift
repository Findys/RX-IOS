//
//  TuShuoItem.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/19.
//  Copyright © 2016年 Geetion. All rights reserved.
//

import Foundation

class TuShuoItem:NSObject,NSCoding{
    
    var click = String()
    var title = String()
    var thumb = String()
    var time = String()
    var pid = String()
    
    init(object:AnyObject) {
        super.init()
        
        self.thumb = object.objectForKey("thumb") as! String
        self.title = object.objectForKey("title") as! String
        self.click = object.objectForKey("click") as! String
        self.pid = object.objectForKey("pid") as! String
        self.time = object.objectForKey("pubdate") as! String
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.pid = aDecoder.decodeObjectForKey("pid") as! String
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
        self.time = aDecoder.decodeObjectForKey("time") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(click, forKey: "click")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(pid, forKey: "pid")
        aCoder.encodeObject(thumb, forKey: "thumb")
        aCoder.encodeObject(time, forKey: "time")
    }
}