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

    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        
        if tabBarController.selectedIndex == 3{
            
            let iflogin = userDefault.objectForKey("iflogin") as! Bool
            
            if iflogin == false{
                
                let vc = myStoryBoard.instantiateViewControllerWithIdentifier("login") as! LoginViewController
                
                self.presentViewController(vc, animated: true, completion: nil)
                
            }
        }
    }
    

}
