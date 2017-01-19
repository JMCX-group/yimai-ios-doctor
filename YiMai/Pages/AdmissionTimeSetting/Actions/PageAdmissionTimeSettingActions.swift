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
import SwiftDate

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
        
        YMAPIUtility.PrintErrorInfo(error)
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
//        let weekday = userData["weekDay"] as! Int
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
        let today = NSDate()

        let showLeftArrow = (newDay.month != today.month)
        targetController!.FixedSettingBodyView!.CurrentDay = newDay
        targetController!.FixedSettingBodyView!.DrawCalendar(newDay, showLeftArrow: showLeftArrow)
    }
    
    public func NextFixedMonth(sender: UIGestureRecognizer) {
        let today = NSDate()
        let threeMonthLatter = today.add(0, months: 2, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, nanoseconds: 0).month
        let newDay = GetNextMonthDay(targetController!.FixedSettingBodyView!.CurrentDay)
        
        let showRightArrow = (threeMonthLatter != newDay.month)
        targetController!.FixedSettingBodyView!.CurrentDay = newDay
        targetController!.FixedSettingBodyView!.DrawCalendar(newDay, showLeftArrow: true, showRightArrow: showRightArrow)
    }
    
//    public func PrevFlexibleMonth(sender: UIGestureRecognizer) {
//        let newDay = GetPrevMonthDay(targetController!.FlexibleSettingBodyView!.CurrentDay)
//        targetController!.FlexibleSettingBodyView!.CurrentDay = newDay
//        targetController!.FlexibleSettingBodyView!.DrawCalendar(newDay)
//    }
//    
//    public func NextFlexibleMonth(sender: UIGestureRecognizer) {
//        let newDay = GetNextMonthDay(targetController!.FlexibleSettingBodyView!.CurrentDay)
//        targetController!.FlexibleSettingBodyView!.CurrentDay = newDay
//        targetController!.FlexibleSettingBodyView!.DrawCalendar(newDay)
//    }
    
    public func SetFlexibleCellStatus(cell: YMTouchableView, status: String) {
//        if("am" == status) {
//            targetController.FlexibleSettingBodyView?.SetDayCellAMSelected(cell)
//        } else if("pm" == status) {
//            targetController.FlexibleSettingBodyView?.SetDayCellPMSelected(cell)
//        } else if("day" == status) {
//            targetController.FlexibleSettingBodyView?.SetDaySelected(cell)
//        } else {
//            targetController.FlexibleSettingBodyView?.SetDayUnSelected(cell)
//        }
        
        let cellData = cell.UserObjectData
        let date = cellData!["date"] as! NSDate
        if("auto" == status) {
            targetController!.FixedSettingBodyView?.ClearFlexibleSetting(date, cell: cell)
//            targetController!.FixedSettingBodyView?.DrawCalendar(targetController!.FixedSettingBodyView!.CurrentDay, clearMap: false)
        } else if("am" == status) {
            targetController.FixedSettingBodyView?.SetDayCellAMSelected(cell, ignorePrev: true)
        } else if("pm" == status) {
            targetController.FixedSettingBodyView?.SetDayCellPMSelected(cell, ignorePrev: true)
        } else if("day" == status) {
            targetController.FixedSettingBodyView?.SetDaySelected(cell, setByFlexible: true)
        } else {
            targetController.FixedSettingBodyView?.SetDayUnSelected(cell, setByFlexible: true)
        }
    }
    
    public func FlexibleCellTouched(sender: UIGestureRecognizer) {
        let cell = sender.view as! YMTouchableView
        let isEnabledCell = cell.UserStringData
        
        let cellData = cell.UserObjectData as! [String: AnyObject]

        let weekdayIdx = cellData["weekdayIdx"] as! Int
        let date = cellData["date"] as! NSDate
//        if(0 == weekdayIdx || 6 == weekdayIdx) {
//            return
//        }
        if("0" == isEnabledCell) {
            return
        }
        
        let title = date.toString(DateFormat.Custom("YYYY-MM-dd 排班"))!
        
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        let auto = UIAlertAction(title: "固定排班", style: .Default,
                                 handler: {
                                    action in
                                    self.SetFlexibleCellStatus(cell, status: "auto")
        })

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
        
        auto.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        am.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        pm.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        day.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        cancel.setValue(YMColors.WarningFontColor, forKey: "titleTextColor")
        
        alertController.addAction(auto)
        alertController.addAction(am)
        alertController.addAction(pm)
        alertController.addAction(day)
        alertController.addAction(cancel)
        self.NavController!.presentViewController(alertController, animated: true, completion: nil)    }
    
    public func SaveSetting(sender: UIGestureRecognizer) {
        targetController.LoadingView?.Show()
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(targetController.FixedSettingBodyView!.SettingData, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        
        let flexibleSetting = targetController.FixedSettingBodyView!.GetFlexibleSetting() //targetController.FlexibleSettingBodyView!.GetSettingData()
        print(flexibleSetting)
        SaveApi?.YMChangeUserInfo(["admission_set_fixed": strJson, "admission_set_flexible": flexibleSetting])
    }
}



























