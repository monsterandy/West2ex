//
//  TabBarViewController.swift
//  West2ex
//
//  Created by 麻哲源 on 2017/2/14.
//  Copyright © 2017年 West2. All rights reserved.
//

import UIKit


class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
//        v2netTool.getHotTopic(success: { () -> Void in
//            HotTableViewController.tableView.reloadData()
//            HotTableViewController.refreshView.endRefreshing()
//            HotTableViewController.refreshData(HotTableViewController)
//        }, failure: {})
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
