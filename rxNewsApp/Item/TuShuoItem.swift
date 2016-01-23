//
//  TuShuoItem.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/19.
//  Copyright © 2016年 Findys. All rights reserved.
//

import Foundation

class TuShuoItem:NSObject,NSCoding{
    
    var click = String()
    var title = String()
    var info = String()
    var thumb = String()
    var time = String()
    var pid = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! String
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.pid = aDecoder.decodeObjectForKey("pid") as! String
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
        self.time = aDecoder.decodeObjectForKey("time") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(click, forKey: "click")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(info, forKey: "info")
        aCoder.encodeObject(pid, forKey: "pid")
        aCoder.encodeObject(thumb, forKey: "thumb")
        aCoder.encodeObject(time, forKey: "time")
    }
}