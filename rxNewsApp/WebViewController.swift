//
//  WebViewController.swift
//  
//
//  Created by Shakugan on 15/10/6.
//
//

import UIKit

class WebViewController: UIViewController {
    
    var id = Int()
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let request = NSURLRequest(URL:NSURL(string:"http://app.ecjtu.net/api/v1/article/\(id)/view")!)
        webView.loadRequest(request)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
