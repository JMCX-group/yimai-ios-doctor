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
    override func ExtInit() {
        super.ExtInit()
    }
    
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
        self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
    }
}