//
//  AppDelegate.swift
//  rxNewsApp
//
//  Created by Geetion on 15/10/3.
//  Copyright (c) 2015年 Geetion. All rights reserved.
//

import UIKit
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        firstLaunch()
        
//        shareSDKset()
        
        getToken()
        
        return true
        
        
        
        
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getToken(){

        if let account = userDefault.stringForKey("account"){
            
            let password = userDefault.stringForKey("password")
            
            let params = ["username": account, "password":password!]
            
            Alamofire.request(.POST, "http://user.ecjtu.net/api/login", parameters: params, encoding: .URL, headers: nil).responseJSON(completionHandler: { (resp:Response<AnyObject, NSError>) -> Void in
                if resp.result.isSuccess{
                    
                    let token = resp.result.value!.objectForKey("token")!
                    
                    userDefault.setObject(token, forKey: "token")
                }else{
                    
                }
            })
        }
    }
    
    
//    func shareSDKset(){
//        ShareSDK.registerApp("iosv1101",
//            activePlatforms :
//            [
//                SSDKPlatformType.TypeSinaWeibo.rawValue,
//                //                SSDKPlatformType.TypeDouBan.rawValue,
//                SSDKPlatformType.TypeCopy.rawValue,
//                //                SSDKPlatformType.TypeMail.rawValue,
//                SSDKPlatformType.TypeWechat.rawValue,
//                SSDKPlatformType.TypeQQ.rawValue,
//            ],
//            // onImport 里的代码,需要连接社交平台SDK时触发
//            onImport: {(platform : SSDKPlatformType) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.TypeSinaWeibo:
//                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
//                case SSDKPlatformType.TypeWechat:
//                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
//                case SSDKPlatformType.TypeQQ:
//                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
//                default:
//                    break
//                }
//            },
//            onConfiguration: {(platform : SSDKPlatformType,appInfo : NSMutableDictionary!) -> Void in
//                switch platform
//                {
//                case SSDKPlatformType.TypeSinaWeibo:
//                    //已设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
//                    appInfo.SSDKSetupSinaWeiboByAppKey("512695859",
//                        appSecret : "6723a7a263f99558ba086895654f39a2",
//                        redirectUri : "http://www.sharesdk.cn",
//                        authType : SSDKAuthTypeBoth)
//                    
//                case SSDKPlatformType.TypeWechat:
//                    //设置微信应用信息
//                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret: "64020361b8ec4c99936c0e3999a9f249")
//                    
//                case SSDKPlatformType.TypeQQ:
//                    //设置QQ应用信息
//                    appInfo.SSDKSetupQQByAppId("100371282",
//                        appKey : "aed9b0303e3ed1e27bae87c33761161d",
//                        authType : SSDKAuthTypeWeb)
//                    
//                    
//                case SSDKPlatformType.TypeDouBan:
//                    //设置豆瓣应用信息
//                    appInfo.SSDKSetupDouBanByApiKey("02e2cbe5ca06de5908a863b15e149b0b", secret: "9f1e7b4f71304f2f", redirectUri: "http://www.sharesdk.cn")
//                    
//                    //设置印象笔记（中国版）应用信息
//                case SSDKPlatformType.TypeYinXiang:
//                    appInfo.SSDKSetupEvernoteByConsumerKey("sharesdk-7807", consumerSecret: "d05bf86993836004", sandbox: true)
//                    
//                    
//                default:
//                    break
//                }
//        })
//        
//    }
//    
    func firstLaunch(){
        
        if (userDefault.objectForKey("everlaunched") == nil){
            userDefault.setBool(false, forKey: "iflogin")
            userDefault.setBool(true, forKey: "everlaunched")
        }
    }
    
}

