//
//  PageIMSearchMessageViewController.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMSearchMessageViewController: PageViewController {
    var BodyView: PageIMSearchMessageBodyView!
    
    override func PageLayout() {
        super.PageLayout()
        
        BodyView = PageIMSearchMessageBodyView(parentView: view, navController: NavController!)
        TopView = PageCommonTopView(parentView: view, titleString: "搜索结果", navController: NavController!)
    }
    
    override func PagePreRefresh() {
        if(isMovingToParentViewController()) {
            let userInfo = UserData as! [String: String]
            
            let targetId = YMVar.GetStringByKey(userInfo, key: "id")
            let key = YMVar.GetStringByKey(userInfo, key: "key")
            let type = YMVar.GetStringByKey(userInfo, key: "isDiscussion")
            
            var ret: [RCMessage]? = nil
            if("1" == type) {
                ret = RCIMClient.sharedRCIMClient().searchMessages(RCConversationType.ConversationType_DISCUSSION,
                                                                   targetId: targetId,
                                                                   keyword: key, count: 100000, startTime: 0)
            } else {
                ret = RCIMClient.sharedRCIMClient().searchMessages(RCConversationType.ConversationType_PRIVATE,
                                                                       targetId: targetId,
                                                                       keyword: key, count: 100000, startTime: 0)
            }
            
            if(nil != ret) {
                BodyView.LoadData(ret!, key: key)
            }
        }
    }
    
    override func PageDisapeared() {
        if(isMovingFromParentViewController()) {
            BodyView.Clear()
        }
    }
}


































