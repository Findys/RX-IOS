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
}

class rxNewsSlideItem:NSObject {
    var title = String()
    var id = NSNumber()
    var thumb = String()
}

class CollageItem:NSObject {
    var click = NSNumber()
    var title = NSString()
    var info = NSString()
    var time = NSString()
    var id = NSNumber()
}

class TuShuoItem:NSObject{
    var click = String()
    var title = String()
    var info = String()
    var thumb = String()
    var time = String()
    var pid = String()
}