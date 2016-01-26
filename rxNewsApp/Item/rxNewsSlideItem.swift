//
//  rxNewsSlideItem.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/19.
//  Copyright © 2016年 Geetion. All rights reserved.
//

import Foundation

class rxNewsSlideItem:NSObject {
    var title = String()
    var id = Int()
    var thumb = String()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder){
        self.title = aDecoder.decodeObjectForKey("title") as! String
        self.id = aDecoder.decodeObjectForKey("id") as! Int
        self.thumb = aDecoder.decodeObjectForKey("thumb") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder){
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(id, forKey: "id")
        aCoder.encodeObject(thumb, forKey: "thumb")
    }
}
