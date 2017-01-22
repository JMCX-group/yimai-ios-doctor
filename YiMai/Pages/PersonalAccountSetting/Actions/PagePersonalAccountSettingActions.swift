//
//  PagePersonalAccountSettingActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/19.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalAccountSettingActions: PageJumpActions {
    var TargetView: PagePersonalAccountSettingBodyView!
    var SettingApi: YMAPIUtility!
    var LogoutApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PagePersonalAccountSettingBodyView
        SettingApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-fromAccountSetting", success: SettingSuccess, error: SettingError)
        LogoutApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-fromAccountLogout", success: LogoutSuccess, error: LogoutError)
    }
    
    func LogoutSuccess(data: NSDictionary?) {
        ClearCaches()
    }
    
    func LogoutError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        ClearCaches()
    }
    
    func ClearCaches() {
        YMCoreDataEngine.Clear()
        YMLocalData.ClearLogin()
        YMVar.Clear()
        YMBackgroundRefresh.Stop()
        //        YMAPICommonVariable.ClearCallbackMap()
        PagePersonalIntroEditViewController.IntroText = ""
        PagePersonalNameEditViewController.UserName = ""
        PageRegisterPersonalInfoViewController.NeedInit = true
        PagePersonalIDNumInputBodyView.IDNum = ""
        PageYiMaiRecentContactList.PrevData.removeAll()
        TargetView.FullPageLoading.Hide()
        
        self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
    }
    
    func SettingSuccess(data: NSDictionary?) {
        if(nil != data) {
            YMVar.MyUserInfo = data!["data"] as! [String: AnyObject]
        }
        
        let targetView = Target as! PagePersonalAccountSettingBodyView
        targetView.FullPageLoading.Hide()
        targetView.LoadData()
    }
    func SettingError(_: NSError) {}
    
    func GoToAuthPage(gr: UIGestureRecognizer) {
        let authStatus = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "is_auth")

        if("processing" == authStatus) {
            DoJump(YMCommonStrings.CS_PAGE_AUTH_PROCESSING)
        } else if("completed" == authStatus) {
            DoJump(YMCommonStrings.CS_PAGE_AUTH_COMPLETE)
        } else if("fail" == authStatus) {
            DoJump(YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME, ignoreExists: false, userData: "fail")
        } else {
            DoJump(YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME)
        }
    }
    
    public func Logout(_: UIGestureRecognizer) {
        TargetView.FullPageLoading.Show()
        LogoutApi.YMChangeUserInfo(["device_token": ""])
    }
    
    func EmailCellTouched(gr: UIGestureRecognizer) {
        let targetView = Target as! PagePersonalAccountSettingBodyView
        PageCommonTextInputViewController.TitleString = "输入电子邮箱"
        PageCommonTextInputViewController.Placeholder = "请输入电子邮箱（最多40字符）"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Email
        PageCommonTextInputViewController.InputMaxLen = 40
        PageCommonTextInputViewController.Result = targetView.AddEmail
        
        DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }
}