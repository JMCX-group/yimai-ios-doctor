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
    override func ExtInit() {
        
    }
    
    public func SaveVerifyStatus(sender: UISwitch) {
        YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.PRIVATE_FRIEND_VERIFY_KEY, data: sender.on)
    }
    
    public func SaveAllowStatus(sender: UISwitch) {
        YMLocalData.SavePrivateInfo(YMPersonalPrivateStrings.ALLOW_APPOINTMENT_KEY, data: sender.on)
    }
    
    func BlacklistTouched(sender: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_BLACKLIST_NAME)
    }
}