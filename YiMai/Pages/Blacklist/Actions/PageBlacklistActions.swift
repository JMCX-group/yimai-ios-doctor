//
//  PageBlacklistActions.swift
//  YiMai
//
//  Created by why on 2016/12/13.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageBlacklistActions: PageJumpActions {
    var TargetView: PageBlacklistBodyView!
    var DocApi: YMAPIUtility!
    var BlacklistApi: YMAPIUtility!
    var RemovePreResult = ""
    
    override func ExtInit() {
        super.ExtInit()
        
        DocApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_DOCTOR_BY_ID + "fromBlacklist",
                              success: GetDocListSuccess, error: GetDocListError)
        
        BlacklistApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_BLACKLIST + "fromBlacklist",
                                    success: RemoveSuccess, error: RemoveError)
        TargetView = Target as! PageBlacklistBodyView
    }
    
    func RemoveSuccess(data: NSDictionary?) {
        YMVar.MyUserInfo["blacklist"] = RemovePreResult
        TargetView.LoadData(TargetView.DocList)
        TargetView.FullPageLoading.Hide()
    }
    
    func RemoveError(error: NSError) {
//        TargetView.LoadData(TargetView.DocList)
        TargetView.FullPageLoading.Hide()

        YMPageModalMessage.ShowErrorInfo("网络繁忙，请稍后再试。", nav: self.NavController!)
    }
    
    func GetDocListSuccess(data: NSDictionary?) {
        let realData = data!["data"] as! [[String: AnyObject]]
        TargetView.LoadData(realData)
        TargetView.FullPageLoading.Hide()
    }
    
    func GetDocListError(error: NSError) {
        TargetView.LoadData([[String: AnyObject]]())
        TargetView.FullPageLoading.Hide()
    }
    
    func RemoveFromBlacklist(sender: YMButton) {
        let curListStr = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist")
        let curList = curListStr.componentsSeparatedByString(",")
        
        var newList = [String]()
        for id in curList {
            if(id != sender.UserStringData){
                newList.append(id)
            }
        }
        
        RemovePreResult = newList.joinWithSeparator(",")
        TargetView.FullPageLoading.Show()
        if("" == RemovePreResult) {
            RemovePreResult = "blank"
        }
        BlacklistApi.YMChangeUserInfo(["blacklist": RemovePreResult])
    }
}




