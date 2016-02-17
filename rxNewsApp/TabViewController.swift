//
//  TabViewController.swift
//  rxNewsApp
//
//  Created by Geetion on 15/12/18.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController,UITabBarControllerDelegate {
    
    var currentIndex = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self

    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        currentIndex = tabBarController.selectedIndex
        return true
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
//        play animations when switch view
        if tabBarController.selectedIndex != currentIndex{
            viewController.view.viewWithTag(1)?.alpha = 0
            
            UIView.animateWithDuration(0.5) { () -> Void in
                
                viewController.view.viewWithTag(1)?.alpha = 1
                
            }
        }
        
//        When switch to personal settings，determine whether the user has logged in
        if tabBarController.selectedIndex == 3{
            
            let iflogin = userDefault.boolForKey("iflogin")
            
            if iflogin == false{
                
                let vc = myStoryBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
        }
    }
    

}
