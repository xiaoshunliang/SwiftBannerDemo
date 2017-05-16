//
//  ViewController.swift
//  SwiftBanner
//
//  Created by xiaoshunliang on 2017/5/16.
//  Copyright © 2017年 bodaokeji. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BannerScrollViewDelegate {
    
    let _dataArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //获取本地json数据
        let path = Bundle.main.path(forResource: "Data", ofType: "json")
        guard let dataString = try? NSString(contentsOfFile: path!, encoding: String.Encoding.utf8.rawValue) else {
            return
        }
        let data = dataString.data(using: String.Encoding.utf8.rawValue)
        
        let dic:NSDictionary = try! JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
        let focusImgs = dic["focusImgs"] as! NSArray
        //解析数据KVC
        for item in focusImgs {
            let dataModel = DataModel()
            dataModel.setValuesForKeys(item as! [String : AnyObject])
            _dataArray.add(dataModel)
        }
        
        let _topScrollView = BannerScrollView(frame: CGRect(x: 0, y: 64, width: WIDTH, height: 170))
        _topScrollView.delegate = self
        _topScrollView.updateImgDataArray(imgArr:_dataArray);
        self.view.addSubview(_topScrollView)
        
    }
    
    
    //
    func didClickScrollViewItem(_ index: NSInteger) {
        
        print("点击图片的索引值=====",index);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

