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
    
    public func Logout(_: UIGestureRecognizer) {
        YMCoreDataEngine.Clear()
        YMLocalData.ClearLogin()
        YMAPICommonVariable.ClearCallbackMap()
        self.DoJump(YMCommonStrings.CS_PAGE_LOGIN_NAME)
    }
}