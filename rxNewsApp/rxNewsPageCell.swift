//
//  rxNewsPageCell.swift
//  rxNewsApp
//
//  Created by Shakugan on 15/10/15.
//  Copyright © 2015年 Shakugan. All rights reserved.
//

import UIKit

class rxNewsPageCell: UITableViewCell {
    
    var controller = ViewController()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        var pageControl = controller.pageControl
        let scrollview = self.viewWithTag(1) as! UIScrollView
        scrollview.scrollEnabled = true
        scrollview.pagingEnabled = true
        scrollview.scrollsToTop = false
        scrollview.delegate = controller
        if self.viewWithTag(112) == nil {
            pageControl = UIPageControl(frame: CGRectMake(controller.view.frame.width-90,0,100,(self.viewWithTag(111)!.frame.height)))
            pageControl.currentPageIndicatorTintColor=UIColor.blackColor()
            pageControl.hidesForSinglePage=true
            pageControl.backgroundColor=UIColor.clearColor()
            pageControl.numberOfPages=3
            pageControl.pageIndicatorTintColor=UIColor.lightGrayColor()
            pageControl.hidesForSinglePage=true
            pageControl.tag=112
            self.viewWithTag(111)?.addSubview(pageControl)
        }
        for i in 0...2 {
            var view = UIImageView()
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "click"))
            view.userInteractionEnabled=true
            if scrollview.viewWithTag(i+20) == nil {
                self.controller.slidetitle = self.viewWithTag(11) as! UILabel
                self.controller.slidetitle.text = controller.slideArray[0].objectForKey("title") as? String
                view.tag = i+20
                scrollview.addSubview(view)
            } else {
                view = scrollview.viewWithTag(i+20) as! UIImageView
            }
            let url = controller.slideArray[i].objectForKey("thumb") as! String
            view.sd_setImageWithURL(NSURL(string:url), completed: { (uiImage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                view.frame = CGRectMake(CGFloat(Int(self.frame.width)*i),
                    CGFloat(0),self.frame.width,self.frame.width/uiImage.size.width*uiImage.size.height)
                scrollview.contentSize = CGSizeMake(CGFloat(Int(self.frame.width)*3),0)
            })
        }
        controller.newsTable.reloadData()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
