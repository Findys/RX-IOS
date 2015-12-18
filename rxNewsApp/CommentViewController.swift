//
//  CommentViewController.swift
//  rxNewsApp
//
//  Created by Geek on 15/11/30.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController,UITextViewDelegate {
    var content = UITextView()
    var commit = UIButton()
    var id = NSNumber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        content.frame = CGRect(x: 10, y: self.view.frame.height-30, width: self.view.frame.width-90, height: 30)
        content.backgroundColor = UIColor.whiteColor()
        content.delegate = self
        content.clipsToBounds = true
        content.layer.borderWidth = 1
        content.layer.borderColor = UIColor.blackColor().CGColor
        content.layer.cornerRadius = 5
        self.view.addSubview(content)
        
        commit.frame = CGRect(x: self.view.frame.width - 75 , y: self.view.frame.height - 30 , width: 70, height: 30)
        commit.setTitle("提交", forState: UIControlState.Normal)
        commit.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        commit.backgroundColor = UIColor.whiteColor()
        commit.clipsToBounds = true
        commit.layer.borderWidth = 1
        commit.layer.borderColor = UIColor.blackColor().CGColor
        commit.layer.cornerRadius = 5
        commit.addTarget(self, action: "commitComment", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(commit)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
