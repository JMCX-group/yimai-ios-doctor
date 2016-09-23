//
//  PagePersonalActions.swift
//  YiMai
//
//  Created by why on 16/4/22.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PagePersonalActions: PageJumpActions{
    public func QRButtonTouched(sender: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAGE_MY_INFO_CARD)
    }
    
    public func GoToPersonalDetail(_: UIGestureRecognizer) {
        PagePersonalDetailViewController.DoctorId = YMVar.MyDoctorId
        DoJump(YMCommonStrings.CS_PAGE_PERSONAL_DETAIL_NAME)
    }
}