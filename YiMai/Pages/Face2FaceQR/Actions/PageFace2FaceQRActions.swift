//
//  PageFace2FaceQRActions.swift
//  YiMai
//
//  Created by why on 16/4/27.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageFace2FaceQRActions: PageJumpActions{
    public func GoToF2FSetting(sender: UIGestureRecognizer) {
        DoJump(YMCommonStrings.CS_PAEG_ADMISSION_CHARGE_SETTING_NAME)
    }
}