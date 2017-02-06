//
//  Topic.swift
//  West2ex
//
//  Created by 麻哲源 on 2016/12/6.
//  Copyright © 2016年 West2. All rights reserved.
//

import UIKit


class TopicModel: NSObject {
    var id: Int
    var title: String
    var url: String
    var replies: Int
    var memberAvatarUrl: String
    var memberUsername: String
    var memberId: Int
    var nodeName: String
    var nodeTitle: String
    var lastTouchUnixTime: Int
    
    init(id: Int,title: String,url: String,replies: Int,memberAvatarUrl: String,memberUsername: String,memberId: Int,nodeName: String,nodeTitle: String,lastTouchUnixTime: Int) {
        self.id = id
        self.title = title
        self.url = url
        self.replies = replies
        self.memberAvatarUrl = memberAvatarUrl
        self.memberUsername = memberUsername
        self.memberId = memberId
        self.nodeName = nodeName
        self.nodeTitle = nodeTitle
        self.lastTouchUnixTime = lastTouchUnixTime
//        let date = dateTransform.transformFromUnix(lastTouchUnixTime)
//        let dformatter = DateFormatter()
//        dformatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
//        print("对应的日期时间：\(dformatter.string(from: date!))")
//        dateTransform.transformFromUnix(lastTouchUnixTime)
    }
    
    
}

    var hotTopicCount: Int = 0
    var hotTopicData: [TopicModel] = []
    var latestTopicCount: Int = 0
    var latestTopicData: [TopicModel] = []

class RefreshItem {
    private var centerStart: CGPoint
    private var centerEnd: CGPoint
    unowned var view: UIView
    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
    func updateViewPositionForPercentage(percentage: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)
    }
}

func getTextWidth(string: String, font: UIFont) -> CGFloat {
    let attributes = [NSFontAttributeName:font]
    let option = NSStringDrawingOptions.usesLineFragmentOrigin
    let rect:CGRect = string.boundingRect(with: CGSize(width: 320.0, height: 999.9), options: option, attributes: attributes, context: nil)
    return rect.width
}

