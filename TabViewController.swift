//
//  TabViewController.swift
//  rxNewsApp
//
//  Created by Findys on 15/12/18.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem){
        print(self.tabBarController?.selectedViewController)
        if item.title! == "我"{
            let iflogin = userDefault.objectForKey("iflogin") as! Bool
            if iflogin == false{
                let vc = myStoryBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
    }

}
