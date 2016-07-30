//
//  PageNewFriendActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public class PageNewFriendActions: PageJumpActions {
    private var TargetView: PageNewFriendBodyView? = nil
    private var GetFriendListApi: YMAPIUtility? = nil
    private var AgreeFriendApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = self.Target as? PageNewFriendBodyView
        
        GetFriendListApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIEND,
                                        success: GetNewFriendSuccess, error: GetNewFriendError)
        
        AgreeFriendApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_AGREE_FRIEND_APPLY,
                                      success: AgreeSuccess, error: AgreeError)
        
    }
    
    public func GetNewFriendSuccess(data: NSDictionary?) {
        let friends = data?["friends"] as? [[String: AnyObject]]
        if(nil == friends) {
            return
        }
        
        TargetView?.LoadData(friends!)
    }
    
    public func GetNewFriendError(error: NSError) {
        
    }
    
    public func AgreeSuccess(_: NSDictionary?) {
    }
    
    public func AgreeError(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
//            YMPageModalMessage.ShowErrorInfo("服务器繁忙，请稍后再试。", nav: self.NavController!)
        } else {
//            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
    }
    
    
    public func GetList() {
        GetFriendListApi?.YMGetRelationNewFriends()
    }
    
    public func Agree(button: YMButton) {
        let data = button.UserObjectData as! [String: AnyObject]
        
        let userId = "\(data["id"]!)"
        button.backgroundColor = YMColors.None
        button.enabled = false
        AgreeFriendApi?.YMAgreeFriendById(userId)
    }
}