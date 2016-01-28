//
//  extendFunction.swift
//  rxNewsApp
//
//  Created by Geetion on 16/1/16.
//  Copyright © 2016年 Geetion. All rights reserved.
//

import Foundation

let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.height

var userDefault = NSUserDefaults.standardUserDefaults()

var myStoryBoard = UIStoryboard(name: "Main", bundle: nil)

extension UIViewController{
    
    func saveData(array:NSArray,localDataName:String){
        
        let localData = NSKeyedArchiver.archivedDataWithRootObject(array)
        
        userDefault.setObject(localData, forKey: localDataName as String)
    }
    
    func getlocalData(localDataName:String)->NSArray?{
        
        if let data = userDefault.dataForKey(localDataName){
            
            let localData = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSArray
            
            return localData
            
        }else{
            return nil
        }
    }
    
    func hideTabBar(){
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y + 50, width: frame!.width, height: frame!.height)
        }
    }
    
    func showTabBar(){
        UIView.animateWithDuration(0.3) { () -> Void in
            let frame = self.tabBarController?.tabBar.frame
            self.tabBarController?.tabBar.frame = CGRect(x: frame!.origin.x, y: frame!.origin.y - 50, width: frame!.width, height: frame!.height)
        }
    }
}
