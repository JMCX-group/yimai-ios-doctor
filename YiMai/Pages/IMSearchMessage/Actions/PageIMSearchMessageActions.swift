//
//  PageIMSearchMessageActions.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMSearchMessageActions: PageJumpActions {
    var TargetView: PageIMSearchMessageBodyView!

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageIMSearchMessageBodyView!
    }
}




































