//
//  DateTransform.swift
//  West2ex
//
//  Created by 麻哲源 on 2017/2/5.
//  Copyright © 2017年 West2. All rights reserved.
//

import Foundation

let dateTransform = DateTransform()
class DateTransform {
    
    func transformFromUnix(_ value: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(value))
        let gregorian = NSCalendar(identifier: NSCalendar.Identifier.gregorian)
        var resultMinute = gregorian?.components(NSCalendar.Unit.minute, from: date, to: Date(), options: [])
        var resultHour = gregorian?.components(NSCalendar.Unit.hour, from: date, to: Date(), options: [])
        var resultDay = gregorian?.components(NSCalendar.Unit.day, from: date, to: Date(), options: [])
        let defaltValue = 0
        if resultDay?.day == 0 {
            if resultHour?.hour == 0 {
                if resultMinute?.minute == 0 {
                    return "刚刚"
                }
                else {
                    return "\(resultMinute?.minute ?? defaltValue)分前"
                }
            }
            else {
                return "\(resultHour?.hour ?? defaltValue)小时\((resultMinute?.minute)! - (resultHour?.hour)! * 60)分前"
            }
        }
        else {
            return "\(resultDay?.day ?? defaltValue)天\(resultHour?.hour ?? defaltValue)小时前"
        }
        
        
        
        
        
    }


}
