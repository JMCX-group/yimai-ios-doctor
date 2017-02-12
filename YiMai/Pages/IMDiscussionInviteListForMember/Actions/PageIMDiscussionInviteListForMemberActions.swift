//
//  PageIMDiscussionInviteListForMemberActions.swift
//  YiMai
//
//  Created by why on 2017/2/2.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMDiscussionInviteListForMemberActions: PageJumpActions {
    var TargetView: PageIMDiscussionInviteListForMemberBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageIMDiscussionInviteListForMemberBodyView
    }
}











