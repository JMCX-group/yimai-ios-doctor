//
//  PageIMHistoryListActions.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMHistoryListActions: PageJumpActions {
    var TargetView: PageIMHistoryListBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageIMHistoryListBodyView
    }
}























