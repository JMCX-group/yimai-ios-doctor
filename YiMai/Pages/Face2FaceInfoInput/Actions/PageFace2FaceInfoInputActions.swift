//
//  PageFace2FaceInfoInputActions.swift
//  YiMai
//
//  Created by why on 16/4/26.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageFace2FaceInfoInputActions: PageJumpActions{
    public func GoToF2FSetting(sender: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAEG_ADMISSION_CHARGE_SETTING_NAME)
    }
}