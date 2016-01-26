//
//  CollageItem.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/19.
//  Copyright © 2016年 Geetion. All rights reserved.
//

import Foundation

class CollageItem:NSObject {
    var click = Int()
    var title = NSString()
    var info = NSString()
    var time = NSString()
    var id = Int()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! Int
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! Int
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
