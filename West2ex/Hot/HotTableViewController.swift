//
//  HotTableViewController.swift
//  West2ex
//
//  Created by 麻哲源 on 2017/1/17.
//  Copyright © 2017年 West2. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

private let kRefreshViewHeight: CGFloat = 200


class HotTableViewController: UITableViewController, UITabBarDelegate, RefreshViewDelegate {
    private var refreshView: RefreshView!
    private var firstLoadingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        let textAttr = [ NSForegroundColorAttributeName: UIColor.black ]
//        navigationController?.navigationBar.titleTextAttributes = textAttr
//        self.navigationController?.navigationBar.subviews[0].removeFromSuperview()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        
        
        refreshView = RefreshView(frame: CGRect(x: 0, y: -kRefreshViewHeight, width: view.bounds.width, height: kRefreshViewHeight), scrollView: tableView)
        refreshView.delegate = self
        
        view.insertSubview(refreshView, at: 0)
        firstLoadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        firstLoadingView.backgroundColor = UIColor.white
        view.insertSubview(firstLoadingView, aboveSubview: refreshView)
        
        refreshView.initRefreshing()
        v2netTool.getHotTopic(success: { () -> Void in
            self.tableView.reloadData()
            self.firstLoadingView.removeFromSuperview()
            self.refreshView.endRefreshing()
        }, failure: {})
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        
        
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        self.tableView.reloadData()
//    }
    //  检测下拉动作
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //  将滚动通知传递给refreshView
        refreshView.scrollViewDidScroll(scrollView)
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    //  MARK: - Refresh view delegate
    //  检测到刷新动作时会调用此方法
    func RefreshViewDidRefresh(refreshView: RefreshView) {
        v2netTool.getHotTopic(success: { () -> Void in
            self.tableView.reloadData()
            self.refreshView.endRefreshing()
        }, failure: {})
    }
    
    //  MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hotTopicCount
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hotTopicCell")
        let hot = hotTopicData[indexPath.row]
        let title = cell?.viewWithTag(101) as! UILabel
        let member = cell?.viewWithTag(102) as! UILabel
        let memberAvatar = cell?.viewWithTag(103) as! UIImageView
        let node = cell?.viewWithTag(104) as! UILabel
        let time = cell?.viewWithTag(105) as! UILabel
        let replies = cell?.viewWithTag(106) as! UILabel
        
        title.text = hot.title
        member.text = hot.memberUsername
        
        let memberWidthConstraint = member.constraints.filter{
            return $0.identifier == "memberWidth"
        }.first
        memberWidthConstraint?.constant = getTextWidth(string: hot.memberUsername, font: member.font) + 5.0
        memberAvatar.layer.masksToBounds = true
        memberAvatar.layer.cornerRadius = 3
        memberAvatar.layer.borderWidth = 1
        memberAvatar.layer.borderColor = UIColor.lightGray.cgColor
        node.layer.masksToBounds = true
        node.layer.cornerRadius = 3
        
        let url = URL(string: "https:" + hot.memberAvatarUrl)
        //  异步刷新图片
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    memberAvatar.image = UIImage(data: data)
                }
            }
        }
        node.adjustsFontSizeToFitWidth = true
        node.text = hot.nodeTitle
        
        let nodeWidthConstraint = node.constraints.filter{
            return $0.identifier == "nodeWidth"
        }.first
        nodeWidthConstraint?.constant = getTextWidth(string: hot.nodeTitle, font: node.font) + 5.0
        
        time.text = dateTransform.transformFromUnix(hot.lastTouchUnixTime)
        let timeWidthConstraint = time.constraints.filter{
            return $0.identifier == "timeWidth"
        }.first
        timeWidthConstraint?.constant = getTextWidth(string: time.text!, font: time.font) + 5.0
        
        replies.layer.masksToBounds = true
        replies.layer.cornerRadius = 4
        replies.text = "\(hot.replies)"
        let repliesWidthConstraint = replies.constraints.filter{
            return $0.identifier == "repliesWidth"
        }.first
        repliesWidthConstraint?.constant = getTextWidth(string: replies.text!, font: replies.font) + 5.0
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: hotTopicData[indexPath.row].url)
        let safariController = SFSafariViewController(url: url!, entersReaderIfAvailable: false)
        self.present(safariController, animated: true, completion: nil)
    }
    

    
    
    
}
