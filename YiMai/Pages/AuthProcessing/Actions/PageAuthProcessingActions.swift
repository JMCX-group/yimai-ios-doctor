//
//  PageAuthProcessingActions.swift
//  YiMai
//
//  Created by old-king on 16/11/6.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageAuthProcessingActions: PageJumpActions {
    var TargetView: PageAuthProcessingBodyView!
    
    override func ExtInit() {
        super.ExtInit()

        TargetView = Target as! PageAuthProcessingBodyView
    }
}










