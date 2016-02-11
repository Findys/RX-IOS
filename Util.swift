//
//  Util.swift
//  rxNewsApp
//
//  Created by Geetion on 16/2/11.
//  Copyright © 2016年 Findys. All rights reserved.
//

import Foundation

class Delay:NSObject{
    
    
    //声明一个bool值变量标示点击状态
    static var showStatus = true
    
    
    /**
     参数taget:传入上下文以便于执行selector
     参数ti：传入间隔时长
     参数selector：传入一个需要执行的selector
    */
    static func delaySelectorWithTimeInterva(target aTarget: AnyObject,ti: NSTimeInterval,selector aSelector: Selector){
        //判断执行状态如果可以执行则运行代码
        if showStatus{
            //执行传入的selector
            aTarget.performSelector(aSelector)
            //将执行状态设置为false
            showStatus = false
            //延迟一段时间后执行changShowStatus方法将执行状态设置为true
            NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: "changeShowStatus", userInfo: nil, repeats: false)
        }
        
    }
    
     static func changeShowStatus(){
        //将执行状态设置为true
        showStatus = true
    }
}