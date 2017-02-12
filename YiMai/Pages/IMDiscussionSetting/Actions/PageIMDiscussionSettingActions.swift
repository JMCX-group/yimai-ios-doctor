//
//  PageIMDiscussionSettingActions.swift
//  YiMai
//
//  Created by why on 2017/2/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMDiscussionSettingActions: PageJumpActions {
    var TargetView: PageIMDiscussionSettingBodyView!
    var GetInfoApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageIMDiscussionSettingBodyView
        
        GetInfoApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_RECENTLY_CONTACT,
                                  success: GetListSuccess, error: GetListError)
    }
    
    func GetListSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        
        YMLocalData.SaveData(realData, key: YMLocalDataStrings.DISCUSSION_MEMBER + TargetView.DiscussionId)
        TargetView.LoadData(realData)
    }
    
    func GetListError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试。", nav: NavController!)
        TargetView.FullPageLoading.Hide()
    }
}






























