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
    private var targetController: PageAdmissionTimeSettingViewController!
    override func ExtInit() {
        super.ExtInit()
        
        targetController = self.Target as! PageAdmissionTimeSettingViewController
    }
    
    public func TabTouched(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    public func AMorPMCellTouched(sender: YMButton) {
        let userData = sender.UserObjectData as! [String: AnyObject]
        let weekday = userData["weekDay"] as! Int
        if(0 == weekday || 6 == weekday) {
            return
        }
        
        var buttonSelectedStatus = false
        if("am" == (userData["AMorPM"] as! String)) {
            buttonSelectedStatus = targetController.FixedSettingBodyView!.ToggleWeekdayAM(userData["weekDay"] as! Int)
        } else {
            buttonSelectedStatus = targetController.FixedSettingBodyView!.ToggleWeekdayPM(userData["weekDay"] as! Int)
        }
        
        if(true == buttonSelectedStatus) {
            sender.backgroundColor = YMColors.WeekdaySelectedColor
            sender.setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
        } else {
            sender.backgroundColor = YMColors.None
            sender.titleLabel?.textColor = YMColors.WeekdayDisabledFontColor
        }
    }
    
    public func PrevFixedMonth(sender: UIGestureRecognizer) {
        
    }
    
    public func NextFixedMonth(sender: UIGestureRecognizer) {
        
    }
}