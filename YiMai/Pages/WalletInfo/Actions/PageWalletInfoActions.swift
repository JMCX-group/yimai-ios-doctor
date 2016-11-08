//
//  PageWalletInfoActions.swift
//  YiMai
//
//  Created by superxing on 16/11/8.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

class PageWalletInfoActions: PageJumpActions {
    var TargetView: PageWalletInfoBodyView!
    
    override func ExtInit() {
        super.ExtInit()
        
        TargetView = Target as! PageWalletInfoBodyView
    }
}







