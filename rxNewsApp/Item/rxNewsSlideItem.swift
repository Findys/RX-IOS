//
//  rxNewsSlideItem.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/19.
//  Copyright © 2016年 Findys. All rights reserved.
//

import Foundation

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
