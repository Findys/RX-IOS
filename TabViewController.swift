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
