//
//  TSScrollview.swift
//  rxNewsApp
//
//  Created by Findys on 15/12/12.
//  Copyright © 2015年 Findys. All rights reserved.
//

import UIKit

class TSScrollview: UIView,UIScrollViewDelegate {
    var picArray = Array<AnyObject>()
    let text = UILabel()
    let background = UIView()
    var imagearray=Array<UIImage>()
    var picheight = Int()
    var myView = UIView()
    var ifheight = false
    var scrollView = UIScrollView()
    var detailArry = NSArray()
    var ifloading = Bool()
    
    func initWithImg(rect:CGRect,imgArrURL:NSArray,textArr:NSArray){
        myView.frame = rect
        myView.backgroundColor = UIColor.blackColor()
        detailArry = textArr
        picArray = imgArrURL as Array<AnyObject>
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, myView.frame.width, myView.frame.height)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        for index in 0..<picArray.count {
            var url = picArray[index] as! String
            let detail = detailArry[index] as! String
            
            text.text="1/"+String(picArray.count)+"   "+detail
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            text.frame=CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
            text.lineBreakMode=NSLineBreakMode.ByWordWrapping
            text.numberOfLines=0
            text.textColor=UIColor.whiteColor()
            text.font=UIFont.boldSystemFontOfSize(15)
            
            background.frame=CGRectMake(0, WINDOW_HEIGHT-size.height-60, WINDOW_WIDTH, size.height+60)
            background.backgroundColor=UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
            
            let imageView = UIImageView()
            let img = picArray[index] as! UIImage
            imageView.frame = CGRectMake(CGFloat(index)*rect.width,rect.height/2-rect.width/img.size.width*img.size.height/2-10
                ,WINDOW_WIDTH,WINDOW_WIDTH/img.size.width*img.size.height)
            self.imagearray.append(img)
            let longpress = UILongPressGestureRecognizer.init(target: self, action: "longPress")
            longpress.minimumPressDuration = 1
            longpress.numberOfTouchesRequired = 1
            let photoview = VIPhotoView.init(frame:CGRect(x: CGFloat(index)*WINDOW_WIDTH,y:-70
                ,width: self.myView.frame.width,height: self.myView.frame.height), andImage: img)
            photoview.userInteractionEnabled = true
            photoview.addGestureRecognizer(longpress)
            if self.ifheight == false{
                self.picheight = Int(imageView.frame.height)
            }
            else{
                if Int(imageView.frame.width)>self.picheight{
                    self.picheight = Int(imageView.frame.width)
                }
            }
            self.scrollView.addSubview(photoview)

            myView.addSubview(background)
            background.addSubview(text)
        }
        self.scrollView.contentSize = CGSizeMake(myView.frame.size.width * CGFloat(picArray.count),CGFloat(picheight))
        myView.addSubview(scrollView)
    }
    
    
    //     页面滑动时重载UI
    func scrollViewDidScroll(scrollView: UIScrollView){
        if ifloading{
            let detail = detailArry[Int(scrollView.contentOffset.x/WINDOW_WIDTH)]as! NSString
            let size = detail.boundingRectWithSize(CGSize(width: WINDOW_WIDTH, height: 300), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:text.font], context: nil).size
            let current = String(Int(scrollView.contentOffset.x/WINDOW_WIDTH + 1))
            let count = String(picArray.count)
            text.text = current+"/"+count+"   "+(detail as String)
            background.frame = CGRect(x: 0, y: WINDOW_HEIGHT-size.height-60, width: WINDOW_WIDTH, height: size.height+60)
            text.frame = CGRect(x: 10, y:0, width: WINDOW_WIDTH-20, height: size.height+20)
        }
    }
    
//    图片长按操作
//    func longPress(){
//        MozTopAlertView.showWithType(MozAlertTypeInfo, text: "保存到图库", doText: "是的", doBlock: { () -> Void in
//            let img = self.imagearray[Int(self.scrollView.contentOffset.x/WINDOW_WIDTH)] as UIImage
//            UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
//            }, parentView: myView)
//    }
    
    
}
