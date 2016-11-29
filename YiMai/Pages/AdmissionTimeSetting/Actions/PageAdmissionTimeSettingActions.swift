//
//  PageAdmissionTimeSettingActions.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

public class PageAdmissionTimeSettingActions: PageJumpActions {
    private var targetController: PageAdmissionTimeSettingViewController!
    private var SaveApi: YMAPIUtility? = nil

    override func ExtInit() {
        super.ExtInit()
        
        targetController = self.Target as! PageAdmissionTimeSettingViewController
        
        SaveApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_USER + "-admissionTimeSetting",
                               success: SaveSuccess, error: SaveError)
    }

    public func SaveSuccess(data: NSDictionary?) {
        targetController.LoadingView?.Hide()
        YMLocalData.SaveUserInfo(data!["data"]!)
        YMVar.MyUserInfo = data!["data"] as! [String : AnyObject]
        
        let jobTitle = YMVar.MyUserInfo["job_title"] as? String
        if(nil == jobTitle) {
            YMVar.MyUserInfo["job_title"] = "医生"
        }

        self.NavController!.popViewControllerAnimated(true)
    }
    
    public func SaveError(error: NSError) {
        targetController.LoadingView?.Hide()
        let errInfo = JSON(data: error.userInfo["com.alamofire.serialization.response.error.data"] as! NSData)
        print(errInfo)
    }
    
    public func TabTouched(sender: UISegmentedControl) {
        if(0 == sender.selectedSegmentIndex) {
            targetController.FixedSettingBodyView?.BodyView.hidden = false
            targetController.FlexibleSettingBodyView?.BodyView.hidden = true
        } else {
            targetController.FixedSettingBodyView?.BodyView.hidden = true
            targetController.FlexibleSettingBodyView?.BodyView.hidden = false
        }
    }
    
    public func AMorPMCellTouched(sender: YMButton) {
        let userData = sender.UserObjectData as! [String: AnyObject]
        let weekday = userData["weekDay"] as! Int
//        if(0 == weekday || 6 == weekday) {
//            return
//        }
        
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
            sender.setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
        }
    }
    
    private func GetNextMonthDay(curDate: NSDate) -> NSDate {
        var month = curDate.month
        var year = curDate.year
        
        if(12 == month) {
            month = 1
            year = year + 1
        } else {
            month = month + 1
        }
        
        return NSDate(year: year, month: month, day: 1)
    }
    
    private func GetPrevMonthDay(curDate: NSDate) -> NSDate {
        let now = NSDate()
        
        var month = curDate.month
        var year = curDate.year
        
        let nowMonth = now.month
        let nowYear = now.year
        
        let curMonthNum = year * 100 + month
        let nowMonthNum = nowYear * 100 + nowMonth
        
        if(curMonthNum <= nowMonthNum) {
            return now
        }
        
        if(1 == month) {
            month = 12
            year = year - 1
        } else {
            month = month - 1
        }
        
        return NSDate(year: year, month: month, day: 1)
    }
    
    public func PrevFixedMonth(sender: UIGestureRecognizer) {
        let newDay = GetPrevMonthDay(targetController!.FixedSettingBodyView!.CurrentDay)
        targetController!.FixedSettingBodyView!.CurrentDay = newDay
        targetController!.FixedSettingBodyView!.DrawCalendar(newDay)
    }
    
    public func NextFixedMonth(sender: UIGestureRecognizer) {
        let newDay = GetNextMonthDay(targetController!.FixedSettingBodyView!.CurrentDay)
        targetController!.FixedSettingBodyView!.CurrentDay = newDay
        targetController!.FixedSettingBodyView!.DrawCalendar(newDay)
    }
    
    public func PrevFlexibleMonth(sender: UIGestureRecognizer) {
        let newDay = GetPrevMonthDay(targetController!.FlexibleSettingBodyView!.CurrentDay)
        targetController!.FlexibleSettingBodyView!.CurrentDay = newDay
        targetController!.FlexibleSettingBodyView!.DrawCalendar(newDay)
    }
    
    public func NextFlexibleMonth(sender: UIGestureRecognizer) {
        let newDay = GetNextMonthDay(targetController!.FlexibleSettingBodyView!.CurrentDay)
        targetController!.FlexibleSettingBodyView!.CurrentDay = newDay
        targetController!.FlexibleSettingBodyView!.DrawCalendar(newDay)
    }
    
    public func SetFlexibleCellStatus(cell: YMTouchableView, status: String) {
        if("am" == status) {
            targetController.FlexibleSettingBodyView?.SetDayCellAMSelected(cell)
        } else if("pm" == status) {
            targetController.FlexibleSettingBodyView?.SetDayCellPMSelected(cell)
        } else if("day" == status) {
            targetController.FlexibleSettingBodyView?.SetDaySelected(cell)
        } else {
            targetController.FlexibleSettingBodyView?.SetDayUnSelected(cell)
        }
    }
    
    public func FlexibleCellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view as! YMTouchableView
        let isEnabledCell = cell.UserStringData
        
        let cellData = cell.UserObjectData as! [String: AnyObject]

        let weekdayIdx = cellData["weekdayIdx"] as! Int
//        if(0 == weekdayIdx || 6 == weekdayIdx) {
//            return
//        }
        if("0" == isEnabledCell) {
            return
        }
        
        let alertController = UIAlertController(title: "选择时间段", message: nil, preferredStyle: .Alert)
        let am = UIAlertAction(title: "上午", style: .Default,
                                   handler: {
                                    action in
                                    self.SetFlexibleCellStatus(cell, status: "am")
        })
        
        let pm = UIAlertAction(title: "下午", style: .Default,
                                 handler: {
                                    action in
                                    self.SetFlexibleCellStatus(cell, status: "pm")
        })
        
        let day = UIAlertAction(title: "全天", style: .Default,
                               handler: {
                                action in
                                self.SetFlexibleCellStatus(cell, status: "day")
        })
        
        let cancel = UIAlertAction(title: "不出诊", style: .Default,
                                handler: {
                                    action in
                                    self.SetFlexibleCellStatus(cell, status: "none")
        })
        
        am.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        pm.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        day.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        cancel.setValue(YMColors.WarningFontColor, forKey: "titleTextColor")
        
        alertController.addAction(am)
        alertController.addAction(pm)
        alertController.addAction(day)
        alertController.addAction(cancel)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)    }
    
    public func SaveSetting(sender: UIGestureRecognizer) {
        targetController.LoadingView?.Show()
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(targetController.FixedSettingBodyView!.SettingData, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        
        let flexibleSetting = targetController.FlexibleSettingBodyView!.GetSettingData()
        SaveApi?.YMChangeUserInfo(["admission_set_fixed": strJson, "admission_set_flexible": flexibleSetting])
    }
}



























