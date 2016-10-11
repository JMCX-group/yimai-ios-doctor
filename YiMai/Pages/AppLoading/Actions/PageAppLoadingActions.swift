//
//  PageAppLoadingActions.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import Graph

public class PageAppLoadingActions: PageJumpActions {
    private var TargetController: PageAppLoadingViewController? = nil
    private var BackEndApi: LoginBackendProgress = LoginBackendProgress(key: "fromLoading")
    private var LoginApi: YMAPIUtility? = nil
    
    override func ExtInit() {
        super.ExtInit()
        self.TargetController = self.Target as? PageAppLoadingViewController
        
        LoginApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_AUTO_LOGIN, success: LoginSuccessCallback, error: LoginError)
    }
    
    public func JumpToLogin() {
        DoJump("PageLogin")
    }
    
    public func LoginSuccessCallback(data: NSDictionary?) {
        let realData = data!
        let loginInfo = TargetController!.LoginInfo
        
        let pwd = loginInfo![YMCoreDataKeyStrings.KEY_PASSWORD] as! String
        
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_TOKEN, data: realData["token"]!)
        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_ORG_PASSWORD, data: pwd)
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA).YMGetAPPInitData()
        BackEndApi.DoApi()
        
        let handler = YMCoreMemDataOnceHandler(handler: LoginSuccess)
        YMCoreDataEngine.SetDataOnceHandler(YMModuleStrings.MODULE_NAME_MY_ACCOUNT_SETTING, handler: handler)
    }
    
    private func LoginSuccess(_: AnyObject?, queue: NSOperationQueue) -> Bool {
        let loginStatus = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_USER_LOGIN_STATUS) as? Bool
        
        if(nil == loginStatus) {
            return false
        }
        
        let unpackedStatus = loginStatus!
        if(!unpackedStatus) {
            queue.addOperationWithBlock({ () -> Void in
                self.TargetController?.LoadingIndc?.Show()
                self.DoLogin()
            })
            return false
        } else {
            queue.addOperationWithBlock({ () -> Void in
                self.TargetController?.LoadingIndc?.Hide()
                
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

                self.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
            })
        }

        return true
    }
    
    private func LoginError(error: NSError) {
        print(error)
        DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
    }
    
    public func DoLogin() {
        let loginInfo = TargetController!.LoginInfo!
        
        let loginName = loginInfo[YMCoreDataKeyStrings.KEY_LOGIN_NAME] as! String
        let pwd = loginInfo[YMCoreDataKeyStrings.KEY_PASSWORD] as! String
        LoginApi?.YMUserLogin(["phone":  loginName, "password": pwd], progressHandler: nil)
    }
}















