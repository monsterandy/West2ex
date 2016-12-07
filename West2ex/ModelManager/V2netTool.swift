//
//  V2netTool.swift
//  West2ex
//
//  Created by Yizhe on 2016/12/7.
//  Copyright © 2016年 West2. All rights reserved.
//

import Foundation
import Alamofire

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
    
}
