//
//  PageIMSearchConversationsActions.swift
//  YiMai
//
//  Created by why on 2017/1/24.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import UIKit

class PageIMSearchConversationsActions: PageJumpActions {
    var TargetView: PageIMSearchConversationsBodyView!

    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageIMSearchConversationsBodyView
    }
}






















