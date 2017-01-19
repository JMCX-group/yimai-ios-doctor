//
//  PagePersonalPrivateSettingActions.swift
//  YiMai
//
//  Created by ios-dev on 16/6/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalPrivateSettingActions: PageJumpActions {
    var SettingApi: YMAPIUtility!
    var TargetSwitch: UISwitch!
    var TargetView: PagePersonalPrivateSettingBodyView!

    override func ExtInit() {
        super.ExtInit()
        SettingApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER, success: SettingSuccess, error: SettingError)
        TargetView = Target as! PagePersonalPrivateSettingBodyView
    }
    
    func SettingSuccess(data: NSDictionary?) {
        TargetView.FullPageLoading.Hide()
        let realData = data!["data"] as! [String: AnyObject]
        YMVar.MyUserInfo["friends_friends_appointment_switch"] = realData["friends_friends_appointment_switch"]
        YMVar.MyUserInfo["verify_switch"] = realData["verify_switch"]
    }
    
    func SettingError(error: NSError) {
        TargetView.FullPageLoading.Hide()
        YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试", nav: NavController!)
        TargetSwitch.on = !TargetSwitch.on
    }
    
    public func SaveVerifyStatus(sender: UISwitch) {
        let verifyFlag = sender.on
        TargetSwitch = sender
        TargetView.FullPageLoading.Show()
        if(verifyFlag) {
            SettingApi.YMChangeUserInfo(["verify_switch": "1"])
        } else {
            SettingApi.YMChangeUserInfo(["verify_switch": "0"])
        }
//        YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.PRIVATE_FRIEND_VERIFY_KEY, data: sender.on)
    }
    
    public func SaveAllowStatus(sender: UISwitch) {
        let saveFlag = sender.on
        TargetSwitch = sender
        TargetView.FullPageLoading.Show()
        if(saveFlag) {
            SettingApi.YMChangeUserInfo(["friends_friends_appointment_switch": "1"])
        } else {
            SettingApi.YMChangeUserInfo(["friends_friends_appointment_switch": "0"])
        }
//        YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.ALLOW_APPOINTMENT_KEY, data: sender.on)
    }
    
    func BlacklistTouched(sender: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_BLACKLIST_NAME)
    }
}

























