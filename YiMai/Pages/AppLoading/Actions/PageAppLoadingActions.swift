//
//  PageAppLoadingActions.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAppLoadingActions: PageJumpActions {
    private var TargetController: PageAppLoadingViewController? = nil
    
    override func ExtInit() {
        super.ExtInit()
        self.TargetController = self.Target as? PageAppLoadingViewController
    }
    
    public func JumpToLogin() {
        DoJump("PageLogin")
    }
}