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
    var SameDepartmentApi: YMAPIUtility? = nil

    public func ApiError1(error: NSError){
        print("error 1")
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    public func ApiError2(error: NSError){
        print("error 2")
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    public func ApiError3(error: NSError){
        print("error 3")
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    public func ApiError4(error: NSError){
        print("error 4")
        YMAPIUtility.PrintErrorInfo(error)
    }
    
    public func GetSameDepartmentError(error: NSError) {
        print("GetSameDepartmentError")
    }
    
    public func GetSameDepartmentSuccess(data: NSDictionary?) {
        if(nil != data) {
            YMLocalData.SaveData(data!, key: YMLocalDataStrings.SAME_DEPT_CACHE + YMVar.MyDoctorId)
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_SAME_DEPARTMENT, data: data!)
        }
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
        if(nil == data) {
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: [[String:AnyObject]]())
        } else {
            let realData = data!
            YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_NEW_FRIENDS, data: realData["friends"]!)
        }
        
        YMBackgroundRefresh.CheckHasUnreadNewFriends()
    }
    
    init(key: String) {
        super.init()
        self.InitRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_INIT_RELATION + key,
                                       success: self.InitRelationSuccess, error: self.ApiError1)
        
        self.L1RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL1_RELATION + key,
                                            success: self.Level1RelationSuccess, error: self.ApiError2)
        
        self.L2RelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_LEVEL2_RELATION + key,
                                            success: self.Level2RelationSuccess, error: self.ApiError3)
        
        self.NewFriendsRelationApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_NEW_FRIENDS + key,
                                          success: self.NewFriendsSuccess, error: self.ApiError4)
        
        self.SameDepartmentApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_GET_SAME_DEPARTMENT_LIST + key,
                                                  success: self.GetSameDepartmentSuccess, error: self.GetSameDepartmentError)
    }
    
    public func DoApi() {
        InitRelationApi?.YMGetInitRelation()
        L1RelationApi?.YMGetLevel1Relation()
        L2RelationApi?.YMGetLevel2Relation()
        NewFriendsRelationApi?.YMGetRelationNewFriends()
        SameDepartmentApi?.YMGetSameDepartmentList(nil)
    }
}

public class PageLoginActions : PageJumpActions {
    private var PageLoginBody: PageLoginBodyView? = nil
    private var LoginSuccessTargetStroyboard: String = ""
    private let LoginActionKey = "YMLoginAction"
    private var ApiUtility : YMAPIUtility? = nil
    
    private var BackEndApi: LoginBackendProgress = LoginBackendProgress(key: "fromLogin")
    
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

        let handler = YMCoreMemDataOnceHandler(handler: LoginSuccess)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING, handler: handler)
        
        YMLocalData.SaveLogin(userInfo!["phone"]!, pwd: userInfo!["password"]!)
    }
    
    private func LoginSuccess(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        let loginStatus = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS) as? Bool
        
        if(nil == loginStatus) {
            return false
        }
        
        let unpackedStatus = loginStatus!
        if(!unpackedStatus) {
            queue.addOperationWithBlock({ () -> Void in
                YMPageModalMessage.ShowErrorInfo("网络连接异常，请稍后再试。", nav: self.NavController!)
                self.PageLoginBody?.EnableLoginControls()
            })
        } else {
            queue.addOperationWithBlock({ () -> Void in
                self.PageLoginBody?.ClearLoginControls()
                let userInfo = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_INFO) as? [String: AnyObject]
                
                if(nil == userInfo) {
                    self.DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
                    return
                }
                
                let userName = userInfo!["name"] as? String
                let userHos = userInfo!["hospital"] as? [String: AnyObject]
                let userDept = userInfo!["department"] as? [String: AnyObject]
                
                if(YMValueValidator.IsEmptyString(userName)) {
                    self.DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
                    return
                }
                
                if(nil == userHos) {
                    self.DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
                    return
                }
                
                if(nil == userDept) {
                    self.DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
                    return
                }

                let hosName = userHos!["name"] as? String
                let deptName = userDept!["name"] as? String
                
                if(YMValueValidator.IsEmptyString(hosName) || YMValueValidator.IsEmptyString(deptName)) {
                    self.DoJump(YMCommonStrings.CS_PAGE_REGISTER_PERSONAL_INFO_NAME)
                    return
                }

                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME, ignoreExists: false, userData: true)
            })
        }
        
        return true
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
            YMAPIUtility.PrintErrorInfo(error)
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





