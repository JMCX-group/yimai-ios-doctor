//
//  PageLoginActions.swift
//  YiMai
//
//  Created by why on 16/4/16.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class LoginBackendProgress: NSObject {
    var InitRelationApi: YMAPIUtility? = nil
    var L1RelationApi: YMAPIUtility? = nil
    var L2RelationApi: YMAPIUtility? = nil
    var NewFriendsRelationApi: YMAPIUtility? = nil
    
    public func ApiError(error: NSError){
        print(error)
    }
    
    public func InitRelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_INIT_FRIENDS, data: friends)
        
        let same = realData["same"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SAME_INFO, data: same)
    }
    
    public func Level1RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L1_FRIENDS, data: friends)
    }
    
    public func Level2RelationSuccess(data: NSDictionary?) {
        let realData = data!
        let count = realData["count"] as! [String:AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS_COUNT_INFO, data: count)
        
        let friends = realData["friends"] as! [AnyObject]
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_L2_FRIENDS, data: friends)
    }
    
    public func NewFriendsSuccess(data: NSDictionary?) {
        let realData = data!
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: realData["friends"]!)
    }
    
    override init() {
        super.init()
        self.InitRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_INIT_RELATION,
                                       success: self.InitRelationSuccess, error: self.ApiError)
        
        self.L1RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL1_RELATION,
                                            success: self.Level1RelationSuccess, error: self.ApiError)
        
        self.L2RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL2_RELATION,
                                            success: self.Level2RelationSuccess, error: self.ApiError)
        
        self.NewFriendsRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIENDS,
                                          success: self.NewFriendsSuccess, error: self.ApiError)
    }
    
    public func DoApi() {
        InitRelationApi?.YMGetInitRelation()
        L1RelationApi?.YMGetLevel1Relation()
        L2RelationApi?.YMGetLevel2Relation()
        NewFriendsRelationApi?.YMGetRelationNewFriends()
    }
}

public class PageLoginActions : PageJumpActions {
    private var PageLoginBody: PageLoginBodyView? = nil
    private var LoginSuccessTargetStroyboard: String = ""
    private let LoginActionKey = "YMLoginAction"
    private var ApiUtility : YMAPIUtility? = nil
    
    private var BackEndApi: LoginBackendProgress = LoginBackendProgress()
    
    private func VarSet(sender: YMButton) {
        if(nil == self.ApiUtility) {
            self.ApiUtility = YMAPIUtility(key: self.LoginActionKey)
        }
        
        if(nil == self.PageLoginBody) {
            self.PageLoginBody = self.Target as? PageLoginBodyView
        }
        
        if("" == self.LoginSuccessTargetStroyboard) {
            self.LoginSuccessTargetStroyboard = sender.UserStringData
        }
    }
    
    public func LoginSuccessCallback(data: NSDictionary?) {
        let realData = data!
        let userInfo = self.PageLoginBody?.GetUserInputInfo()

        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_TOKEN, data: realData["token"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD, data: userInfo!["password"]!)
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA).YMGetAPPInitData()
        BackEndApi.DoApi()

        self.DoJump(LoginSuccessTargetStroyboard)
    }

    public func LoginErrorCallback(error: NSError) {
        if(nil != error.userInfo["com.alamofire.serialization.response.error.response"]) {
            let response = error.userInfo["com.alamofire.serialization.response.error.response"]!
            //let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
            
            if(response.statusCode >= 500) {
                //显示服务器繁忙
                self.PageLoginBody?.ShowErrorInfo("服务器繁忙，请稍后再试。")
            } else if (response.statusCode >= 400) {
                //显示验证失败，用户名或密码错误
                self.PageLoginBody?.ShowErrorInfo("手机号或密码错误！")
            } else {
                //显示服务器繁忙
                self.PageLoginBody?.ShowErrorInfo("服务器繁忙，请稍后再试。")
            }
        } else {
            YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
        }
        
        
        self.PageLoginBody?.EnableLoginControls()
    }

    public func DoLogin(sender:YMButton) {
        if(nil == self.NavController){return}
        VarSet(sender)
        
        let userInfo = self.PageLoginBody?.GetUserInputInfo()
        if(nil == userInfo) {return}

        YMAPICommonVariable.SetJsonCallback(self.LoginActionKey, callback: self.LoginSuccessCallback, update: false)
        YMAPICommonVariable.SetErrorCallback(self.LoginActionKey, callback: self.LoginErrorCallback, update: false)
        
        self.PageLoginBody?.DisableLoginControls()
        self.ApiUtility?.YMUserLogin(userInfo!, progressHandler: nil)
    }
}





