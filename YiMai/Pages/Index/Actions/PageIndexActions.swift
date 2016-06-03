//
//  PageIndexActions.swift
//  YiMai
//
//  Created by why on 16/4/21.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageIndexActions: PageJumpActions {
    public func JumpToAppointment(sender: UIGestureRecognizer) {
        PageAppointmentViewController.NewAppointment = true
        DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
    }
}