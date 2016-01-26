//
//  rxNewsItem.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/24.
//  Copyright © 2015年 Geetion. All rights reserved.
//

import Foundation

class rxNewsItem:NSObject {
    
    var click = Int()
    var title = String()
    var info = String()
    var id = Int()
    var thumb = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.click = aDecoder.decodeObjectForKey("click") as! Int
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.info = aDecoder.decodeObjectForKey("info") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! Int
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


