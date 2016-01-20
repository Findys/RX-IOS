//
//  extendFunction.swift
//  rxNewsApp
//
//  Created by 胡健 on 16/1/16.
//  Copyright © 2016年 Findys. All rights reserved.
//

import Foundation
extension UIViewController{
    func saveData(array:NSArray,localDataName:String){
        
        let localData = NSKeyedArchiver.archivedDataWithRootObject(array)
        
        userDefault.setObject(localData, forKey: localDataName as String)
    }
    
    func getlocalData(localDataName:String)->NSArray?{
        
        if let data = userDefault.objectForKey(localDataName){
            
            let localData = NSKeyedUnarchiver.unarchiveObjectWithData(data as! NSData) as! NSArray
            
            return localData
            
        }else{
            return nil
        }
    }
}
