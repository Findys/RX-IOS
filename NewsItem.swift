//
//  rxNewsItem.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/24.
//  Copyright © 2015年 Findys. All rights reserved.
//

import Foundation

class rxNewsItem:NSObject {
    
    var click = NSNumber()
    var title = String()
    var info = String()
    var id = NSNumber()
    var thumb = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! NSNumber
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! NSNumber
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(click, forKey: "click")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(info, forKey: "info")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(thumb, forKey: "thumb")
    }
}

class rxNewsSlideItem:NSObject {
    var title = String()
    var id = NSNumber()
    var thumb = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! NSNumber
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(thumb, forKey: "thumb")
    }
}

class CollageItem:NSObject {
    var click = NSNumber()
    var title = NSString()
    var info = NSString()
    var time = NSString()
    var id = NSNumber()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! NSNumber
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! NSNumber
        self.time = aDecoder.decodeObjectForKey("time") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(click, forKey: "click")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(info, forKey: "info")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(time, forKey: "time")
    }
}

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