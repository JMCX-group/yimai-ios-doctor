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
    var SettingApi: YMAPIUtility!
    
    override func ExtInit() {
        super.ExtInit()
        
        SettingApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-fromAccountSetting", success: SettingSuccess, error: SettingError)
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
        } else {
            DoJump(YMCommonStrings.CS_PAGE_PERSONAL_DOCTOR_AUTH_NAME)
        }
    }
    
    public func Logout(_: UIGestureRecognizer) {
        YMCoreDataEngine.Clear()
        YMLocalData.ClearLogin()
        YMVar.Clear()
        YMBackgroundRefresh.Stop()
//        YMAPICommonVariable.ClearCallbackMap()
        PagePersonalIntroEditViewController.IntroText = ""
        PagePersonalNameEditViewController.UserName = ""
        PageRegisterPersonalInfoViewController.NeedInit = true
        PagePersonalIDNumInputBodyView.IDNum = ""
        self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
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