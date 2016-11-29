
![效果图](https://github.com/pengshengsongcode/CycleImageView/blob/master/123.gif)

首先感谢右侧链接代码中的图片素材😁~[大神使用UICollectionView实现的轮播图](http://www.code4app.com/forum.php?mod=viewthread&tid=11742&extra=page%3D1)

据说此三方好多好多人用[强大的第三方框架SDCycleScrollView](https://github.com/gsdios/SDCycleScrollView)

###轮播图的实现方式
>1. 使用UIScrollView通过contentSize设置UIImageView的展示预处理
>2. 使用UICollectionView通过设置item
>3. 使用UISwipeGestureRecognizeror或者TouchesBegan等方法

网络上大部分是使用UIScrollView配合三个或者两个UIImageView来实现的轮播图，就再想可不可以使用一个UIImgeView实现，从而第三种实现方式也就诞生了，虽然不是特别实用，但是也算是一种简单思维

-----

###UISwipeGestureRecognizeror（清扫手势）逻辑
>1. 通过UIImageView添加向左向右的轻扫手势
>2. 当触发轻扫手势的响应事件时，重新设置Index
>3. 使用CATransition的Type（Push）和SubType（Left/Right）来进行实现对应的向左向右的转场动画
>4. 更改完Index时，在CATransition动画中从img数组中取出对应图片并赋值给UIImageView
>5. 赋值图片的同时更改pageControl的currentPage来实现轮播图的精仿

-----

###TouchesBegan等方法的逻辑

>1. 写一个UIImageView的子类，并在其中实现Began、Move、End方法
>1. 和使用UIBezierPath绘制画板同理，首先在Touch等方法中获取对应的点
>2. 根据点的位置改变来判断向左滑还是向右滑
>3. 使用CATransition的Type（Push）和SubType（Left/Right）来进行实现对应的向左向右的转场动画
>4. 更改完Index时，在CATransition动画中从img数组中取出对应图片并赋值给UIImageView
>5. 赋值图片的同时更改pageControl的currentPage来实现轮播图的精仿

---

>主要以UISwipeGestureRecognizeror为例子🌰

###UISwipeGestureRecognizeror（清扫手势）相关代码

> 一些懒加载，注释已经标明清楚

```
    var selectedIndex = 0//当前图片
   
    lazy var imageView: UIImageView = {//展示image
        let imageview = UIImageView()
        imageview.image = UIImage(named: "\(self.selectedIndex)")
        return imageview
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
    
```

```

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)

        //重要！！！！！！！ 给imageView添加手势需要将isUserInteractionEnabled设置为true
        imageView.isUserInteractionEnabled = true
        
        //添加向左手势
        imageView.addGestureRecognizer(swipeLeft)

        //添加向右手势
        imageView.addGestureRecognizer(swipeRight)
        
        //获取page的size
        let pageSize = page.size(forNumberOfPages: dataList.count)
        
        page.frame = CGRect(x: 0, y: imageView.frame.maxY - pageSize.height, width: pageSize.width, height: pageSize.height)
        
        page.center.x = imageView.frame.width / 2
        
        view.addSubview(imageView)
        
        view.addSubview(page)
        
    }

```

> 从左往右滑动的响应事件


```
    func tapRightAction() {//从左往右滑动
        
        //使用CA转场动画来改变方式
        
        let transition = CATransition()
        
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromLeft

        //这句话也就是最重要的，根据selectedIndex的值来确定是否已经到最左侧，如果到最左侧，将selectedIndex重置为10
        selectedIndex = selectedIndex <= 0 ? 10 : selectedIndex - 1
        
        page.currentPage = selectedIndex
        
        imageView.image = UIImage(named: "\(dataList[selectedIndex])")
        
        imageView.layer.add(transition, forKey: "right")
        
    }
    
```

> 从右往左滑动的响应事件

```
    func tapRightAction() {//从左往右滑动

        //使用CA转场动画来改变方式
        
        let transition = CATransition()
        
        transition.type = kCATransitionPush
        
        transition.subtype = kCATransitionFromRight
                
        //这句话也就是最重要的，根据selectedIndex的值来确定是否已经到最左侧，如果到最右侧，将selectedIndex重置为0
        selectedIndex = selectedIndex >= 10 ? 0 : selectedIndex + 1
        
        page.currentPage = selectedIndex
        
        imageView.image = UIImage(named: "\(dataList[selectedIndex])")
        
        imageView.layer.add(transition, forKey: "left")
                
    }

```

Touches基本同理，再此不一一赘述了

----

>总结
1. 使用UISwipeGestureRecognizer无需考虑UIImageView的复用问题，因为只有一个imaegView
2. 轮播图分为手动和自动，本文为手动控制没有加timer，如果改为自动，只需要在在定时调用方法即可
3. 使用UISwipeGestureRecognizer实现，手指滑动一点点，再划回来，这个暂时没有好的解决方式，但是可以使用Touches的相关方法解决，因为手指离开才回去调用End方法

----

> 小尾巴~~~

为什么很多人不用这种方法，坐等各位大神回复，个人觉得没有什么问题，完全可以精仿

>demo地址
[github]()
