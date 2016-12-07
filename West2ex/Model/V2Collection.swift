//
//  V2Collection.swift
//  West2ex
//
//  Created by 一折 on 2016/12/7.
//  Copyright © 2016年 West2. All rights reserved.
//

import Foundation

let v2collection = V2Collection()

// A demo class of data, complete yours in other .swift file.
class DemoData{
    var username:String
    var password:String
    var isLogin:Bool
    
    init(usr:String,pwd:String,login:Bool) {
        self.username = usr
        self.password = pwd
        self.isLogin = login
    }
}

// A class contains collections used in this program.
class V2Collection{
    
    var demoData:DemoData?
    
}
