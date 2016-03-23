//
//  SlideScrollView.swift
//  ZhihuDaily
//
//  Created by Geetion on 14-6-12.
//  Copyright (c) 2014年 Geetion. All rights reserved.
//

import UIKit
import SDWebImage

protocol SlideScrollViewDelegate {
    
    func SlideScrollViewDidClicked(index:Int)
    
}



class SlideScrollView: UIView,UIScrollViewDelegate{
    
    var scrollView = UIScrollView()
    var imageArray = NSArray()
    var titleArray = NSArray()
    var pageControl = UIPageControl()
    var noteTitle = UILabel()
    var currentPage = Int()
    var myFrame:CGRect?
    
    var mydelegate:SlideScrollViewDelegate?
    
    init(frame:CGRect,imgArr:NSArray,titArr:NSArray,backShadowImage:UIImage?){
        super.init(frame: frame)
        
        myFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height-0.5)
        
        imageArray = imgArr
        titleArray = titArr
        
        self.userInteractionEnabled = true
        
        let pageCount = imageArray.count
        
        scrollView.frame = myFrame!
        scrollView.pagingEnabled = true
        
        let contentWidth = WINDOW_WIDTH*CGFloat(pageCount)
        
        scrollView.contentSize = CGSize(width: contentWidth, height: myFrame!.height)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.scrollsToTop = false
        scrollView.delegate = self
        
        for i in 0 ..< pageCount {
            let imgURL = imageArray[i] as! String
            let imgView = UIImageView()
            
            let viewWidth = Int(frame.size.width)*i
            imgView.sd_setImageWithURL(NSURL(string: imgURL), completed: { (img:UIImage!, error:NSError!, cacheType, nsurl:NSURL!) -> Void in
                imgView.frame = CGRect(origin: CGPoint(x: CGFloat(viewWidth), y:CGFloat(0)),size: CGSize(width: self.myFrame!.width,height:self.myFrame!.width/img.size.width*img.size.height))
            })
            
            imgView.contentMode = UIViewContentMode.ScaleToFill
            imgView.userInteractionEnabled = true
            imgView.tag = i
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SlideScrollView.imagePressed(_:)))
            
            imgView.addGestureRecognizer(tap)
            
            scrollView.addSubview(imgView)
        }
        
        scrollView.contentOffset = CGPoint(x:0, y:0)
        
        self.addSubview(scrollView)
        
        if backShadowImage != nil{
            let shadowImg = UIImageView()
            shadowImg.frame = CGRect(origin: CGPoint(x: 0,y: myFrame!.height-80),size: CGSize(width: 320,height: 80))
            shadowImg.image = backShadowImage
            self.addSubview(shadowImg)
        }
        
        pageControl = UIPageControl()
        pageControl.frame.size = CGSize(width: 100, height: 50)
        pageControl.center = CGPoint(x: myFrame!.width/2, y: myFrame!.height-10)
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        pageControl.userInteractionEnabled = false
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
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(SlideScrollView.autoShowNextPage), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoShowNextPage() {
        
        if pageControl.currentPage + 1 < titleArray.count {
            currentPage = pageControl.currentPage + 1
            self.changeCurrentPage()
        }else{
            currentPage = 0;
            self.changeCurrentPage()
        }
    }
    
    func changeCurrentPage (){
        
        let offX = scrollView.frame.size.width * CGFloat(currentPage)
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
        mydelegate?.SlideScrollViewDidClicked(tap.view!.tag)
    }
    
}
