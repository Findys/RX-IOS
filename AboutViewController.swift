//
//  AboutViewController.swift
//  rxNewsApp
//
//  Created by HuJian on 15/11/22.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class AboutViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 89/255.0, green: 166/255.0, blue: 223/255.0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}