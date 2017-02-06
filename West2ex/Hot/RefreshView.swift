//
//  RefreshView.swift
//  West2ex
//
//  Created by 麻哲源 on 2017/1/19.
//  Copyright © 2017年 West2. All rights reserved.
//

import UIKit

private let kScreenHeight: CGFloat = 120.0

protocol RefreshViewDelegate: class {
    func RefreshViewDidRefresh(refreshView: RefreshView)
}

class RefreshView: UIView, UIScrollViewDelegate {

    private unowned var scrollView: UIScrollView
    private var progress: CGFloat = 0.0
    
    var refreshItems = [RefreshItem]()
    weak var delegate: RefreshViewDelegate?
    var isRefreshing: Bool = false
    
    init(frame: CGRect, scrollView: UIScrollView) {
        self.scrollView = scrollView
        super.init(frame: frame)
        //backgroundColor = UIColor.green
        updateBackgroundColor()
        setupRefreshItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupRefreshItems() {
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        let sunImageView = UIImageView(image: UIImage(named: "sun"))
        let catImageView = UIImageView(image: UIImage(named: "cat"))
        let capeBackImageView = UIImageView(image: UIImage(named: "cape_back"))
        let capeFrontImageView = UIImageView(image: UIImage(named: "cape_front"))
        let cloud1ImageView = UIImageView(image: UIImage(named: "cloud_1"))
        let cloud2ImageView = UIImageView(image: UIImage(named: "cloud_2"))
        let cloud3ImageView = UIImageView(image: UIImage(named: "cloud_3"))
        refreshItems = [
            RefreshItem(view: cloud1ImageView, centerEnd: CGPoint(x: bounds.midX * 0.5, y: -kScreenHeight * 0.1), parallaxRatio: 0, sceneHeight: kScreenHeight),
            RefreshItem(view: cloud2ImageView, centerEnd: CGPoint(x: bounds.midX, y: -kScreenHeight * 0.1), parallaxRatio: 0, sceneHeight: kScreenHeight),
            RefreshItem(view: cloud3ImageView, centerEnd: CGPoint(x: bounds.midX * 1.5, y: -kScreenHeight * 0.1), parallaxRatio: 0, sceneHeight: kScreenHeight),
            RefreshItem(view: buildingsImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - groundImageView.bounds.height - (buildingsImageView.bounds.height / 2)), parallaxRatio: 1.5, sceneHeight: kScreenHeight),
            RefreshItem(view: sunImageView, centerEnd: CGPoint(x: bounds.midX * 0.3, y: bounds.height - groundImageView.bounds.height - sunImageView.bounds.height), parallaxRatio: 3.0, sceneHeight: kScreenHeight),
            RefreshItem(view: groundImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - (groundImageView.bounds.height / 2)), parallaxRatio: 0.5, sceneHeight: kScreenHeight),
            RefreshItem(view: capeBackImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - (groundImageView.bounds.height / 2) - (catImageView.bounds.height / 2)), parallaxRatio: -1.0, sceneHeight: kScreenHeight),
            RefreshItem(view: catImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - (groundImageView.bounds.height / 2) - (catImageView.bounds.height / 2)), parallaxRatio: 1.0, sceneHeight: kScreenHeight),
            RefreshItem(view: capeFrontImageView, centerEnd: CGPoint(x: bounds.midX, y: bounds.height - (groundImageView.bounds.height / 2) - (catImageView.bounds.height / 2)), parallaxRatio: -1.0, sceneHeight: kScreenHeight)
        ]
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }
    
    func initRefreshing() {
        progress = 1
        updateBackgroundColor()
        updateRefreshItemsPositions()
        beginRefreshing()
    }
    
    func beginRefreshing() {
        isRefreshing = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset.top += kScreenHeight
        }) { (_) in
        }
        let cape = refreshItems[6].view
        let cat = refreshItems[7].view
        let buildings = refreshItems[3].view
        let ground = refreshItems[5].view
        let cloud1 = refreshItems[0].view
        let cloud2 = refreshItems[1].view
        let cloud3 = refreshItems[2].view
        let sun = refreshItems[4].view
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseInOut, animations: {
            ground.center.y += kScreenHeight
            buildings.center.y += kScreenHeight
        }, completion: nil)
        cape.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI/32))
        cat.transform = CGAffineTransform(translationX: 1.0, y: 0.0)
        UIView.animate(withDuration: 0.2, delay: 0, options: [.repeat,.autoreverse], animations: { 
            cape.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI/32))
            cat.transform = CGAffineTransform(translationX: -1.0, y: 0.0)
        }, completion: nil)
        UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseIn,.repeat], animations: {
            cloud1.center.y += kScreenHeight * 2.3
            cloud2.center.y += kScreenHeight * 2
            cloud3.center.y += kScreenHeight * 2.6
            sun.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
            sun.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI*Double(2.0)))
        }, completion: nil)
    }
    func endRefreshing() {
        UIView.animate(withDuration: 0.8, delay: 1, options: .curveEaseInOut, animations: {
            self.scrollView.contentInset.top -= kScreenHeight
        }) { (_) in
            self.isRefreshing = false
            let cape = self.refreshItems[6].view
            let cat = self.refreshItems[7].view
            let cloud1 = self.refreshItems[0].view
            let cloud2 = self.refreshItems[1].view
            let cloud3 = self.refreshItems[2].view
            let sun = self.refreshItems[4].view
            cape.layer.removeAllAnimations()
            cat.layer.removeAllAnimations()
            cloud1.layer.removeAllAnimations()
            cloud2.layer.removeAllAnimations()
            cloud3.layer.removeAllAnimations()
            sun.layer.removeAllAnimations()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress == 1 {
            print(targetContentOffset.pointee.y)
            print(scrollView.contentInset.top)
            print(scrollView.contentOffset.y)
            beginRefreshing()
            print(targetContentOffset.pointee.y)
            print(scrollView.contentInset.top)
            print(scrollView.contentOffset.y)
            targetContentOffset.pointee.y = -scrollView.contentInset.top
            delegate?.RefreshViewDidRefresh(refreshView: self)
        }
    }
    
    
    func updateRefreshItemsPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(percentage: progress)
        }
    }
    func updateBackgroundColor() {
        backgroundColor = UIColor(white: 0.7 * progress + 0.2, alpha: 1.0)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        //1-先拿到刷新视图可见区域的高度
        let refreshViewVisibleHeight = max(0, -scrollView.contentOffset.y - scrollView.contentInset.top)
        //2-计算当前滚动进度
        progress = min(1, refreshViewVisibleHeight / kScreenHeight)
        //3-根据进度改变背景颜色
        updateBackgroundColor()
        //4-根据进度更新视图位置
        updateRefreshItemsPositions()
    }
    
}
