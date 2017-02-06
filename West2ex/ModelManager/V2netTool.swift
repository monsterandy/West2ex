//
//  V2netTool.swift
//  West2ex
//
//  Created by Yizhe on 2016/12/7.
//  Copyright © 2016年 West2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let v2netTool = V2netTool()

class V2netTool{
    
    //example packed function
    func getData(username:String,password:String){
        //the url
        let url = "https://fzuhelper.learning2learn.cn/test/login"
        
        //parameters
        let parameters:Parameters = [
            "username":username,
            "password":password
        ]
        
        //request
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON{ response in
            //get data
            guard let data:NSDictionary = response.result.value as! NSDictionary? else{
                return
            }
            
            //analyse data
            let success = data["success"] as!Bool
            
            //store them to your model
            v2collection.demoData = DemoData(usr: username, pwd: password, login: success)
            
            //for debug
            print(v2collection.demoData?.username ?? "fail")
            
        }
    }
    
    //  get hot topic
    func getHotTopic(success:@escaping () -> Void, failure:@escaping () -> Void) {
        // the url
        let url = "https://www.v2ex.com/api/topics/hot.json"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get).responseJSON{ response in
            //  get data
            guard let data = response.result.value else{
                //  network error
                failure()
                return
            }
            let json = JSON(data)
//            print(json.count)
            hotTopicData.removeAll()
            hotTopicCount = json.count
            for i in 0..<json.count {
                hotTopicData.append(TopicModel(id: json[i]["id"].intValue, title: json[i]["title"].stringValue, url: json[i]["url"].stringValue, replies: json[i]["replies"].intValue, memberAvatarUrl: json[i]["member"]["avatar_large"].stringValue, memberUsername: json[i]["member"]["username"].stringValue, memberId: json[i]["member"]["id"].intValue, nodeName: json[i]["node"]["name"].stringValue, nodeTitle: json[i]["node"]["title"].stringValue, lastTouchUnixTime: json[i]["last_touched"].intValue))
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            success()
        }
    }
    
    func getLatestTopic(success:@escaping () -> Void, failure:@escaping () -> Void) {
        let url = "https://www.v2ex.com/api/topics/latest.json"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request(url, method: .get).responseJSON{ response in
            guard let data = response.result.value else{
                failure()
                return
            }
            let json = JSON(data)
            print(json.count)
            latestTopicData.removeAll()
            latestTopicCount = json.count
            for i in 0..<json.count {
                latestTopicData.append(TopicModel(id: json[i]["id"].intValue, title: json[i]["title"].stringValue, url: json[i]["url"].stringValue, replies: json[i]["replies"].intValue, memberAvatarUrl: json[i]["member"]["avatar_large"].stringValue, memberUsername: json[i]["member"]["username"].stringValue, memberId: json[i]["member"]["id"].intValue, nodeName: json[i]["node"]["name"].stringValue, nodeTitle: json[i]["node"]["title"].stringValue, lastTouchUnixTime: json[i]["last_modified"].intValue))
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            success()
        }
    }
    
}
