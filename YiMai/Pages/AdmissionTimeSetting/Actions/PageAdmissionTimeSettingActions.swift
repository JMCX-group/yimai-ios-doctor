//
//  PageAdmissionTimeSettingActions.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit

public class PageAdmissionTimeSettingActions: PageJumpActions {
    override func ExtInit() {
        super.ExtInit()
    }
    
    public func TabTouched(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    public func AMorPMCellTouched(sender: YMButton) {
        
    }
    
    public func PrevFixedMonth(sender: UIGestureRecognizer) {
        
    }
    
    public func NextFixedMonth(sender: UIGestureRecognizer) {
        
    }
}