//
//  LatestTableViewController.swift
//  West2ex
//
//  Created by 麻哲源 on 2017/1/21.
//  Copyright © 2017年 West2. All rights reserved.
//

import UIKit
import SafariServices

private let kRefreshViewHeight: CGFloat = 200


class LatestTableViewController: UITableViewController, RefreshViewDelegate {
    
    private var refreshView: RefreshView!
    private var firstLoadingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textAttr = [ NSForegroundColorAttributeName: UIColor.white ]
        navigationController?.navigationBar.titleTextAttributes = textAttr
        refreshView = RefreshView(frame: CGRect(x: 0, y: -kRefreshViewHeight, width: view.bounds.width, height: kRefreshViewHeight), scrollView: tableView)
        refreshView.delegate = self
        view.insertSubview(refreshView, at: 0)
        firstLoadingView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        firstLoadingView.backgroundColor = UIColor.white
        view.insertSubview(firstLoadingView, aboveSubview: refreshView)
        
        refreshView.initRefreshing()
        v2netTool.getLatestTopic(success: { () -> Void in
            self.tableView.reloadData()
            self.firstLoadingView.removeFromSuperview()
            self.refreshView.endRefreshing()
        }, failure: {})
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
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
        v2netTool.getLatestTopic(success: { () -> Void in
            self.tableView.reloadData()
            self.refreshView.endRefreshing()
        }, failure: {})
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return latestTopicCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "latestTopicCell")
        // Configure the cell...
        let latest = latestTopicData[indexPath.row]
        let title = cell?.viewWithTag(101) as! UILabel
        let member = cell?.viewWithTag(102) as! UILabel
        let memberAvatar = cell?.viewWithTag(103) as! UIImageView
        let node = cell?.viewWithTag(104) as! UILabel
        let time = cell?.viewWithTag(105) as! UILabel
        let replies = cell?.viewWithTag(106) as! UILabel

        title.text = latest.title
        member.text = latest.memberUsername
        
        let memberWidthConstraint = member.constraints.filter{
            return $0.identifier == "memberWidth"
            }.first
        memberWidthConstraint?.constant = getTextWidth(string: latest.memberUsername, font: member.font) + 5.0
        memberAvatar.layer.masksToBounds = true
        memberAvatar.layer.cornerRadius = 3
        memberAvatar.layer.borderWidth = 1
        memberAvatar.layer.borderColor = UIColor.gray.cgColor
        node.layer.masksToBounds = true
        node.layer.cornerRadius = 3

        let url = URL(string: "https:" + latest.memberAvatarUrl)
        //  异步刷新图片
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url!) {
                DispatchQueue.main.async {
                    memberAvatar.image = UIImage(data: data)
                }
            }
        }
        node.adjustsFontSizeToFitWidth = true
        node.text = latest.nodeTitle
        
        let nodeWidthConstraint = node.constraints.filter{
            return $0.identifier == "nodeWidth"
            }.first
        nodeWidthConstraint?.constant = getTextWidth(string: latest.nodeTitle, font: node.font) + 5.0
        
        time.text = dateTransform.transformFromUnix(latest.lastTouchUnixTime)
        let timeWidthConstraint = time.constraints.filter{
            return $0.identifier == "timeWidth"
            }.first
        timeWidthConstraint?.constant = getTextWidth(string: time.text!, font: time.font) + 5.0
        
        if latest.replies == 0 {
            replies.backgroundColor = UIColor.white
        }
        else{
            replies.backgroundColor = UIColor.lightGray
        }
        replies.layer.masksToBounds = true
        replies.layer.cornerRadius = 4
        replies.text = "\(latest.replies)"
        let repliesWidthConstraint = replies.constraints.filter{
            return $0.identifier == "repliesWidth"
            }.first
        repliesWidthConstraint?.constant = getTextWidth(string: replies.text!, font: replies.font) + 5.0
        
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = URL(string: latestTopicData[indexPath.row].url)
        let safariController = SFSafariViewController(url: url!, entersReaderIfAvailable: false)
        self.present(safariController, animated: true, completion: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
