//
//  BannerScrollView.swift
//  SwiftBanner
//
//  Created by xiaoshunliang on 2017/5/16.
//  Copyright © 2017年 bodaokeji. All rights reserved.
//


import UIKit


//写在类别外面类似于#define
let WIDTH = UIScreen.main.bounds.size.width
let HEIGHT = UIScreen.main.bounds.size.height

protocol BannerScrollViewDelegate {
    
    func didClickScrollViewItem(_ index:NSInteger)
    
}

class BannerScrollView: UIView,UIScrollViewDelegate {
    
    var bannerScrollView = UIScrollView()
    var currentImageView = UIImageView()
    var _currentIndex: NSInteger!
    var _dataArray = NSMutableArray();//图片数组
    var pageControl = UIPageControl();
    var  timer:Timer?;
    var delegate:BannerScrollViewDelegate!
    /*
     *初始化scrollView及其部件
     */
    override init(frame: CGRect) {
        
        super.init(frame:frame)
        //ScrollView
        bannerScrollView.frame = CGRect(x: 0, y: 0, width: WIDTH, height:frame.size.height)
        bannerScrollView.contentSize = CGSize(width: WIDTH*3, height: frame.size.height)
        bannerScrollView.backgroundColor = UIColor.white
        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        bannerScrollView.bounces = false;
        bannerScrollView.contentOffset = CGPoint(x: WIDTH, y: 0)
        self.addSubview(bannerScrollView)
        
        //PageControl
        pageControl.frame = CGRect(x: (frame.size.width - 200)/2, y: frame.size.height - 30, width:200, height:30);
        pageControl.pageIndicatorTintColor = UIColor.gray;
        pageControl.currentPageIndicatorTintColor = UIColor.cyan;
        self.addSubview(pageControl);
        _currentIndex = 0;
        
        // 手势
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapCLick))
        currentImageView.addGestureRecognizer(tap)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    //更新数组
    func updateImgDataArray(imgArr:NSMutableArray) {
        
        _dataArray = imgArr;
        setUpDataDataArray(_dataArray)
        
    }
    
    /*
     *此处为scrollView的复用，比目前网上大部分的同类型控件油画效果好，只需要三张图片依次替换即可实现轮播，不需要有几张图就使scrollView的contentSize为图片数＊宽度
     */
    func setUpDataDataArray(_ dataArray:NSArray) {
        for  view in bannerScrollView.subviews {
            if view.isKind(of: UIImageView.self) {
                view.removeFromSuperview()
            }
        }
        // 中间图
        currentImageView.sd_setImage(with: URL(string: (dataArray[_currentIndex] as! DataModel).imgURL as String))
        currentImageView.isUserInteractionEnabled = true;
        currentImageView.frame = CGRect(x: WIDTH, y: 0, width: WIDTH, height: 170);
        bannerScrollView.addSubview(currentImageView)
        // 左侧图
        let preImageView = UIImageView()
        let imageStr = _currentIndex - 1 >= 0 ? (dataArray[_currentIndex-1] as! DataModel).imgURL as String : (dataArray.lastObject as! DataModel).imgURL as String
        preImageView.isUserInteractionEnabled = true
        preImageView.sd_setImage(with: URL(string: imageStr))
        preImageView.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 170)
        bannerScrollView.addSubview(preImageView)
        // 右侧
        let nextImageView = UIImageView()
        let imageStr1 = _currentIndex + 1 < dataArray.count ? (dataArray[_currentIndex+1] as! DataModel).imgURL as String : (dataArray.firstObject as! DataModel).imgURL as String
        nextImageView.isUserInteractionEnabled = true
        nextImageView.sd_setImage(with: URL(string: imageStr1))
        nextImageView.frame = CGRect(x: WIDTH*2, y: 0, width: WIDTH, height: 170)
        bannerScrollView.addSubview(nextImageView)
        pageControl.numberOfPages = dataArray.count;
        pageControl.currentPage = _currentIndex;
        //开启定时器
        startTimer()
        
    }
    /*
     *图片的代理点击响应方法
     */
    func tapCLick() {
        delegate.didClickScrollViewItem(_currentIndex)
    }
    //开启定时器
    func startTimer() {
        if timer==nil  {
            timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        }
    }
    //摧毁定时器
    func destoryTimer() {
        timer?.invalidate();
        timer=nil;
    }
    /*
     *定时器方法，使banner页无限轮播
     */
    func timerAction() {
        
        if _currentIndex+1 < _dataArray.count {
            _currentIndex = _currentIndex + 1;
        }
        else
        {
            _currentIndex=0;
        }
        pageControl.currentPage = _currentIndex;
        UIView.animate(withDuration: 1, animations: {
            self.bannerScrollView.contentOffset = CGPoint(x: WIDTH*2, y: 0)
        },completion: {
            (finished) in
            self.bannerScrollView.contentOffset = CGPoint(x: WIDTH, y: 0)
            self.setUpDataDataArray(self._dataArray)
        })
    }
    
    
    /*
     *UIScrollViewDelegate  协议方法，拖动图片的处理方法
     */
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        destoryTimer();
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x/WIDTH;
        if index > 1
        {
            _currentIndex = _currentIndex + 1 < _dataArray.count ? _currentIndex+1 : 0;
            
            UIView.animate(withDuration: 1, animations: {
                self.bannerScrollView.contentOffset = CGPoint(x: WIDTH*2, y: 0)
            },completion: {
                (finished) in
                self.bannerScrollView.contentOffset = CGPoint(x: WIDTH, y: 0)
                self.setUpDataDataArray(self._dataArray)
            })
        }
        else if index < 1
        {
            _currentIndex = _currentIndex - 1 >= 0 ? _currentIndex-1 : _dataArray.count - 1;
            UIView.animate(withDuration: 1, animations: {
                self.bannerScrollView.contentOffset = CGPoint(x: 0, y: 0)
            },completion: {
                (finished) in
                self.bannerScrollView.contentOffset = CGPoint(x: WIDTH, y: 0)
                self.setUpDataDataArray(self._dataArray)
            })
            
        }
        else
        {
            print("没滚动不做任何操作")
        }
    }
}
