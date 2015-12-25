//
//  SlideScrollView.swift
//  ZhihuDaily
//
//  Created by XuDong Jin on 14-6-12.
//  Copyright (c) 2014年 XuDong Jin. All rights reserved.
//

import UIKit

protocol SlideScrollViewDelegate {
    
    func SlideScrollViewDidClicked(index:Int)
    
}



class SlideScrollView: UIView,UIScrollViewDelegate {

    var viewSize:CGRect = CGRect()
    var scrollView:UIScrollView = UIScrollView()
    var imageArray:NSArray = NSArray()
    var titleArray:NSArray = NSArray()
    var pageControl:UIPageControl = UIPageControl()
    var currentPageIndex:Int = 0
    var noteTitle:UILabel = UILabel()
    var currentPage = Int()
    var view = UIView()
    
    var delegate:SlideScrollViewDelegate?
    
    init(rect:CGRect,imgArr:NSArray,titArr:NSArray){
        super.init(frame: rect)
        view.frame = rect
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func initWithFrameRect(rect:CGRect,imgArr:NSArray,titArr:NSArray)->AnyObject{
        self.userInteractionEnabled = true;
        
        imageArray = imgArr
        titleArray = titArr
        viewSize = rect
        let pageCount:Int = imageArray.count
        scrollView = UIScrollView(frame:CGRect(origin: CGPoint(x: 0,y: 0),size: CGSize(width: rect.size.width,height: rect.size.height)))
        scrollView.pagingEnabled = true
        let contentWidth = WINDOW_WIDTH*CGFloat(pageCount)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: rect.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        scrollView.bounces = false
        
        for var i = 0; i<pageCount; i++ {
            let imgURL = imageArray[i] as! String
            let imgView:UIImageView=UIImageView()
            
            let viewWidth = Int(viewSize.size.width)*i
            imgView.sd_setImageWithURL(NSURL(string: imgURL), completed: { (img:UIImage!, error:NSError!, cache:SDImageCacheType, nsurl:NSURL!) -> Void in
                imgView.frame = CGRect(origin: CGPoint(x: CGFloat(viewWidth), y:CGFloat(0)),size: CGSize(width: rect.width,height:rect.width/img.size.width*img.size.height))
            })

            imgView.contentMode = UIViewContentMode.ScaleToFill
            imgView.userInteractionEnabled = true
            imgView.tag = i
            
            let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "imagePressed:")

            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            imgView.addGestureRecognizer(tap)
            scrollView.addSubview(imgView)
        }
        
        scrollView.contentOffset = CGPoint(x:0, y:0)
        
        self.addSubview(scrollView)

        //文字层
        let shadowImg:UIImageView = UIImageView()
        shadowImg.frame = CGRect(origin: CGPoint(x: 0,y: rect.height-80),size: CGSize(width: 320,height: 80))
        shadowImg.image = UIImage(named:"shadow.png")
        self.addSubview(shadowImg)
        
        pageControl = UIPageControl()
        pageControl.frame.size = CGSize(width: 100, height: 50)
        pageControl.center = CGPoint(x: rect.width/2, y: rect.height-10)
        pageControl.currentPage = Int(scrollView.contentOffset.x/WINDOW_WIDTH)
        pageControl.numberOfPages = pageCount
        self.addSubview(pageControl)
        
        noteTitle = UILabel()
        noteTitle.textColor = UIColor.whiteColor()
        noteTitle.font = UIFont.boldSystemFontOfSize(16)
        noteTitle.numberOfLines = 0
        noteTitle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        if titleArray.count != 0{
            noteTitle.text = titleArray[pageControl.currentPage] as? String
        }
        noteTitle.frame = CGRect(origin: CGPoint(x: 10,y: 140),size: CGSize(width: 300,height: 50))
        self.addSubview(noteTitle)

        NSTimer.scheduledTimerWithTimeInterval(4, target: self, selector: "autoShowNextPage", userInfo: nil, repeats: true)
        
        return self
    }
    
    func autoShowNextPage() {

        if pageControl.currentPage + 1 < titleArray.count {
            currentPageIndex = pageControl.currentPage + 1
            self.changeCurrentPage()
        }else{
            currentPageIndex = 0;
            self.changeCurrentPage()
        }
    }
    
    func changeCurrentPage (){
        let offX = scrollView.frame.size.width * CGFloat(currentPageIndex)
        scrollView.setContentOffset(CGPoint(x:offX, y:scrollView.frame.origin.y), animated:true)
        self.scrollViewDidScroll(scrollView);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        currentPage = Int(scrollView.contentOffset.x/WINDOW_WIDTH)
        pageControl.currentPage = currentPage
        if titleArray.count != 0{
            noteTitle.text = titleArray[pageControl.currentPage] as? String
        }
    }
    
    func imagePressed (tap:UITapGestureRecognizer){
        delegate?.SlideScrollViewDidClicked(tap.view!.tag)
    }

}
