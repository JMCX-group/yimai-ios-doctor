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

public class PageLoginActions : PageJumpActions {
    private var PageLoginBody: PageLoginBodyView? = nil
    private var LoginSuccessTargetStroyboard: String = ""
    private let LoginActionKey = "YMLoginAction"
    private var ApiUtility : YMAPIUtility? = nil
    
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

        YMCoreDataEngine.SaveData(YMCoreDataKeyStrings.CS_USER_TOKEN, data: realData["token"]!)
        YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_NAME_INIT_DATA).YMGetAPPInitData()
        self.DoJump(LoginSuccessTargetStroyboard)
    }

    public func LoginErrorCallback(error: NSError) {
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