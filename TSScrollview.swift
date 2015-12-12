//
//  TSScrollview.swift
//  rxNewsApp
//
//  Created by Findys on 15/12/12.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

let WINDOW_WIDTH = UIScreen.mainScreen().bounds.width
let WINDOW_HEIGHT = UIScreen.mainScreen().bounds.height

class TSScrollview: UIView,UIScrollViewDelegate {
    var picArray = Array<AnyObject>()
    let text = UILabel()
    let background = UIView()
    var imagearray=Array<UIImage>()
    var picheight = Int()
    var myView = UIView()
    var ifheight = false
    var scrollView = UIScrollView()
    var ifloading = Bool()
    
    func loadScroll(picarry:Array<UIImage>){
        
        for index in 0..<picArray.count {
            var url = picArray[index].objectForKey("url") as! String
            let detail = picArray[0].objectForKey("detail") as! String
            
            text.text="1/"+String(picArray.count)+"   "+detail
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            text.frame=CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
            text.lineBreakMode=NSLineBreakMode.ByWordWrapping
            text.numberOfLines=0
            text.textColor=UIColor.whiteColor()
            text.font=UIFont.boldSystemFontOfSize(15)
            
            background.frame=CGRectMake(0, WINDOW_HEIGHT-size.height-60, WINDOW_WIDTH, size.height+60)
            background.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            url = "http://pic.ecjtu.net/\(url)"
            let image = UIImageView()
            image.sd_setImageWithURL(NSURL(string:url), completed: { (UIimage:UIImage!, error:NSError!, cacheType:SDImageCacheType, nsurl:NSURL!) -> Void in
                image.frame = CGRectMake(CGFloat(index)*WINDOW_WIDTH,WINDOW_HEIGHT/2-WINDOW_WIDTH/UIimage.size.width*UIimage.size.height/2-10
                    ,WINDOW_WIDTH,WINDOW_WIDTH/UIimage.size.width*UIimage.size.height)
                self.imagearray.append(UIimage)
                let longpress = UILongPressGestureRecognizer.init(target: self, action: "longPress")
                longpress.allowableMovement = 10
                longpress.minimumPressDuration = 1
                longpress.numberOfTouchesRequired = 1
                let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*WINDOW_WIDTH,y:-70
                    ,width: self.myView.frame.width,height: self.myView.frame.height), andImage: UIimage)
                photoview.userInteractionEnabled = true
                photoview.addGestureRecognizer(longpress)
                if self.ifheight == false{
                    self.picheight = Int(image.frame.height)
                }
                else{
                    if Int(image.frame.width)>self.picheight{
                        self.picheight = Int(image.frame.width)
                    }
                }
                self.scrollView.addSubview(photoview)
            })
            myView.addSubview(background)
            background.addSubview(text)
        }
        self.scrollView.contentSize = CGSizeMake(myView.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))
    }
    
    
    //     页面滑动时重载UI
    func scrollViewDidScroll(scrollView: UIScrollView){
        if ifloading{
            let detail = picArray[Int(scrollView.contentOffset.x/WINDOW_WIDTH)].objectForKey("detail") as! NSString
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            let current = String(Int(scrollView.contentOffset.x/WINDOW_WIDTH + 1))
            let count = String(picArray.count)
            text.text = current+"/"+count+"   "+(detail as String)
            background.frame = CGRect(x: 0, y: WINDOW_HEIGHT-size.height-60, width: WINDOW_WIDTH, height: size.height+60)
            text.frame = CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
        }
    }
    
    func longPress(){
        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "保存到图库", doText: "是的", doBlock: { () -> Void in
            let img = self.imagearray[Int(self.scrollView.contentOffset.x/WINDOW_WIDTH)] as UIImage
            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
            }, parentView: myView)
    }
    
    
}
