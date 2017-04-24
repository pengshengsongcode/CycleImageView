//
//  ViewController.swift
//  预览图片
//
//  Created by 彭盛凇 on 2016/11/28.
//  Copyright © 2016年 huangbaoche. All rights reserved.
//

import UIKit

let screen_width = UIScreen.main.bounds.width
let screen_height = UIScreen.main.bounds.height

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        imageView.isUserInteractionEnabled = true
        
        imageView.addGestureRecognizer(swipeLeft)
        
        imageView.addGestureRecognizer(swipeRight)
        
        imageView.addGestureRecognizer(pinch)
        
        let pageSize = page.size(forNumberOfPages: dataList.count)
        
        page.frame = CGRect(x: 0, y: imageView.frame.maxY - pageSize.height, width: pageSize.width, height: pageSize.height)
        
        page.center.x = imageView.frame.width / 2
        
        scrollView.frame = imageView.frame
        
        scrollView.contentSize = imageView.frame.size;
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(imageView)
        
        view.addSubview(page)
        
    }

    
    var selectedIndex = 0//当前图片
    
    lazy var imageView: UIImageView = {//展示image
        let imageview = UIImageView()
        imageview.image = UIImage(named: "\(self.selectedIndex)")
        return imageview
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    lazy var swipeRight: UISwipeGestureRecognizer = {//从左往右滑手势
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(tapRightAction))
        swipe.direction = .right

        return swipe
    }()

    lazy var swipeLeft: UISwipeGestureRecognizer = {//从右往左滑手势
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(tapLeftAction))
        
        swipe.direction = .left
        return swipe
    }()
    
    lazy var pinch: UIPinchGestureRecognizer = {
        
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction))
        
        return pinch
    }()
    
    lazy var page: UIPageControl = {
        
        let page = UIPageControl()
        
        page.numberOfPages = self.dataList.count
        
        page.currentPage = self.selectedIndex
        
        page.pageIndicatorTintColor = UIColor.green
        
        page.currentPageIndicatorTintColor = UIColor.red
        
        return page
    }()
    
    lazy var dataList: Array<String> = {//image数据源
        
        var arr: Array<String> = []
        
        for i in 0...10 {
            arr.append("\(i)")
        }
        
        return arr
    }()
    
    func tapRightAction() {//从左往右滑动
        
        //使用CA转场动画来改变方式
        
        let transition = CATransition()
        
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromLeft
        
        selectedIndex = selectedIndex <= 0 ? 10 : selectedIndex - 1
        
        page.currentPage = selectedIndex
        
        imageView.image = UIImage(named: "\(dataList[selectedIndex])")
        
        imageView.layer.add(transition, forKey: "right")
        
    }
    
    func tapLeftAction() {  //从右往左滑动
        
        //使用CA转场动画来改变方式
        
        let transition = CATransition()
        
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromRight
        
        selectedIndex = selectedIndex >= 10 ? 0 : selectedIndex + 1
        
        page.currentPage = selectedIndex
        
        imageView.image = UIImage(named: "\(dataList[selectedIndex])")
        
        imageView.layer.add(transition, forKey: "left")
        
        
    }
    
    func pinchAction(sender :UIPinchGestureRecognizer) {
        
        sender.view?.transform = sender.view!.transform.scaledBy(x: sender.scale, y: sender.scale)
        
        scrollView.contentSize = sender.view!.frame.size
        
        sender.scale = 1;
    }
    
}

