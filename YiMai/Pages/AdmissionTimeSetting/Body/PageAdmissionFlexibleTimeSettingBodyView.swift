//
//  PageAdmissionFlexibleTimeSettingBodyView.swift
//  YiMai
//
//  Created by ios-dev on 16/7/30.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftyJSON
import SwiftDate

public class PageAdmissionFlexibleTimeSettingBodyView: PageBodyView {
    var SettingActions: PageAdmissionTimeSettingActions!
    
    private let WeekdayPanel = UIView()
    private var AMLineArr: [YMButton] = [YMButton]()
    private var PMLineArr: [YMButton] = [YMButton]()
    
    private let TitlePanel = UIView()
    private let LeftTitle = UILabel()
    private let RightTitle = UILabel()
    
    private let CalendarPanel = UIView()
    
    public var CurrentDay = NSDate()
    
    var SelectDict = [String: String]()
    private var DayCellMapByWeek = [Int: [YMTouchableView]]()

    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = self.Actions as! PageAdmissionTimeSettingActions
        DrawFlexibleSchedule()
    }

    func SetSelectDict(key key: NSDate, status: String, remove: Bool = false) {
        let keyStr = key.toString(DateFormat.ISO8601Format(ISO8601Type.Date))!
        if(remove) {
            SelectDict[keyStr] = nil
        } else {
            SelectDict[keyStr] = status
        }
    }
    
    func GetDateStatus(key key: NSDate) -> String? {
        let keyStr = key.toString(DateFormat.ISO8601Format(ISO8601Type.Date))!
        return SelectDict[keyStr]
    }
    
    private func DrawDateTitleLabel() {
        BodyView.addSubview(TitlePanel)
        TitlePanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        TitlePanel.backgroundColor = YMColors.BackgroundGray
        
        LeftTitle.text = "您的接诊时间"
        LeftTitle.font = YMFonts.YMDefaultFont(26.LayoutVal())
        LeftTitle.textColor = YMColors.FontGray
        LeftTitle.sizeToFit()
        TitlePanel.addSubview(LeftTitle)
        LeftTitle.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: LeftTitle.width, height: LeftTitle.height)
        
        RightTitle.text = "请点选您可接诊的时间"
        RightTitle.font = YMFonts.YMDefaultFont(26.LayoutVal())
        RightTitle.textColor = YMColors.FontGray
        RightTitle.sizeToFit()
        TitlePanel.addSubview(RightTitle)
        RightTitle.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: RightTitle.width, height: RightTitle.height)
    }
    
    public func DrawCalendar(curDate: NSDate) {
        YMLayout.ClearView(view: CalendarPanel)
        BodyView.addSubview(CalendarPanel)
        CalendarPanel.align(Align.UnderMatchingLeft, relativeTo: TitlePanel, padding: 0, width: YMSizes.PageWidth, height: 744.LayoutVal())
        
        let monthPanel = YMTouchableView()
        let leftArrow = YMLayout.GetSuitableImageView("CommonLeftArrowIcon")
        let rightArrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
        
        let leftArrowBtn = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "PrevFlexibleMonth:".Sel())
        let rightArrowBtn = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "NextFlexibleMonth:".Sel())
        
        let monthLabel = UILabel()
        
        CalendarPanel.addSubview(monthPanel)
        monthPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 100.LayoutVal())
        monthPanel.backgroundColor = YMColors.White
        
        monthPanel.addSubview(leftArrowBtn)
        monthPanel.addSubview(rightArrowBtn)
        
        leftArrowBtn.anchorAndFillEdge(Edge.Left, xPad: 0, yPad: 0, otherSize: 100.LayoutVal())
        rightArrowBtn.anchorAndFillEdge(Edge.Right, xPad: 0, yPad: 0, otherSize: 100.LayoutVal())
        
        leftArrowBtn.addSubview(leftArrow)
        rightArrowBtn.addSubview(rightArrow)
        
        leftArrow.anchorInCenter(width: leftArrow.width, height: leftArrow.height)
        rightArrow.anchorInCenter(width: rightArrow.width, height: rightArrow.height)
        
        monthPanel.addSubview(monthLabel)
        monthLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        monthLabel.textColor = YMColors.FontBlue
        monthLabel.text = YMDatetimeString.YYYYMMinChinese(curDate)
        monthLabel.sizeToFit()
        monthLabel.anchorInCenter(width: monthLabel.width, height: monthLabel.height)
        
        DrawCalendarGrid(curDate, parent: CalendarPanel, prev: monthPanel)
    }
    
    
    private func BuildDisabledDayCell(day: Int, weekdayIdx: Int) -> YMTouchableView {
        let cell = YMTouchableView()
        
        let dayLabel = UILabel()
        dayLabel.text = "\(day)"
        dayLabel.textColor = YMColors.WeekdayDisabledFontColor
        dayLabel.font = YMFonts.YMDefaultFont(32.LayoutVal())
        dayLabel.sizeToFit()
        
        cell.addSubview(dayLabel)
        
        cell.UserObjectData = ["label": dayLabel, "weekdayIdx": weekdayIdx]
        cell.UserStringData = "0"
        return cell
    }
    
    private func BuildNormalDayCell(day: Int, weekdayIdx: Int) -> YMTouchableView {
        let cell = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "FlexibleCellTouched:".Sel())
        let curMonth = CurrentDay.month
        let curYear = CurrentDay.year
        
        let cellDate = NSDate(year: curYear, month: curMonth, day: day)
        
        let dayLabel = UILabel()
        dayLabel.text = "\(day)"
        dayLabel.textColor = YMColors.FontBlue
        dayLabel.font = YMFonts.YMDefaultFont(32.LayoutVal())
        dayLabel.sizeToFit()
        
        cell.addSubview(dayLabel)
        if(0 == weekdayIdx || 6 == weekdayIdx) {
            cell.backgroundColor = YMColors.White
        } else {
            cell.backgroundColor = YMColors.White
        }
        
        let amIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingAMIcon")
        let pmIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingPMIcon")
        
        amIcon.hidden = true
        pmIcon.hidden = true
        
        cell.addSubview(amIcon)
        cell.addSubview(pmIcon)
        
        
        cell.UserObjectData = ["date": cellDate, "label": dayLabel, "weekdayIdx": weekdayIdx, "amIcon": amIcon, "pmIcon": pmIcon, "status": "none"]
        cell.UserStringData = "1"
        
        DayCellMapByWeek[weekdayIdx]?.append(cell)
        
        let status = GetDateStatus(key: cellDate)
        if(nil != status) {
            let statusStr = status!
            if("am" == statusStr) {
                SetDayCellAMSelected(cell)
            } else if("pm" == statusStr) {
                SetDayCellPMSelected(cell)
            } else if("day" == statusStr){
                SetDaySelected(cell)
            }
        }

        return cell
    }
    
    public func SetDayCellAMSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = false
        pmIcon.hidden = true
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "am"
        cell.UserObjectData = cellData
        
        let date = cellData["date"] as! NSDate
        SetSelectDict(key: date, status: "am")
    }
    
    public func SetDayCellPMSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = true
        pmIcon.hidden = false
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "pm"
        cell.UserObjectData = cellData
        
        let date = cellData["date"] as! NSDate
        SetSelectDict(key: date, status: "pm")
    }
    
    public func SetDaySelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = false
        pmIcon.hidden = false
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "day"
        cell.UserObjectData = cellData
        
        let date = cellData["date"] as! NSDate
        SetSelectDict(key: date, status: "day")
    }
    
    public func SetDayUnSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = true
        pmIcon.hidden = true
        
        cell.backgroundColor = YMColors.White
        cellData["status"] = "none"
        cell.UserObjectData = cellData
        
        let date = cellData["date"] as! NSDate
        SetSelectDict(key: date, status: "none", remove: true)
    }
    
    private func DrawCalendarGridDividerLine(parent: UIView, weekLineCount: Int) {
        let baseLeft = 107.0.LayoutVal()
        for i in 1...6 {
            let divider = UIView()
            parent.addSubview(divider)
            divider.backgroundColor = YMColors.WeekdayLineColor
            divider.anchorToEdge(Edge.Left, padding: baseLeft * CGFloat(i), width: YMSizes.OnPx, height: parent.height)
        }
        
        let baseTop = 107.0.LayoutVal()
        for i in 0...weekLineCount {
            let divider = UIView()
            parent.addSubview(divider)
            divider.backgroundColor = YMColors.WeekdayLineColor
            divider.anchorToEdge(Edge.Top, padding: baseTop * CGFloat(i), width: parent.width, height: YMSizes.OnPx)
        }
    }
    
    private func DrawCalendarGrid(curDate: NSDate, parent: UIView, prev: UIView? = nil) {
        let daysInWeek = YMDateTools.GetMonthDaysArrayInWeek(curDate)
        let gridPanel = UIView()
        parent.addSubview(gridPanel)
        
        let gridHeight = CGFloat(daysInWeek.count) * 107.LayoutVal()
        if(nil != prev) {
            gridPanel.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0,
                            width: YMSizes.PageWidth, height: gridHeight)
        } else {
            gridPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: gridHeight)
        }
        
        var weekLineArr = [YMTouchableView]()
        
        for week in daysInWeek {
            let weekLine = YMTouchableView()
            gridPanel.addSubview(weekLine)
            weekLineArr.append(weekLine)
            
            var cellArr = [YMTouchableView]()
            var weekdayIdx = 0
            for day in week {
                var cell: YMTouchableView!
                if(day < 0) {
                    let realDay = -day
                    cell = BuildDisabledDayCell(realDay, weekdayIdx: weekdayIdx)
                } else if(day >= 100) {
                    let realDay = day / 100
                    cell = BuildDisabledDayCell(realDay, weekdayIdx: weekdayIdx)
                } else {
                    cell = BuildNormalDayCell(day, weekdayIdx: weekdayIdx)
                }
                
                weekdayIdx += 1
                cellArr.append(cell)
                weekLine.addSubview(cell)
            }
            
            weekLine.UserObjectData = cellArr
        }
        
        gridPanel.groupAndFill(group: .Vertical, views: weekLineArr.map({$0 as YMTouchableView}), padding: 0)
        
        for line in weekLineArr {
            let cellArr = line.UserObjectData as! [YMTouchableView]
            line.groupAndFill(group: .Horizontal, views: cellArr.map({$0 as YMTouchableView}), padding: 0)
            
            for cell in cellArr {
                let cellData = cell.UserObjectData as! [String: AnyObject]
                let cellLabel = cellData["label"] as! UILabel
                
                cellLabel.anchorInCenter(width: cellLabel.width, height: cellLabel.height)
                
                if("1" == cell.UserStringData) {
                    let amIcon = cellData["amIcon"] as! UIImageView
                    let pmIcon = cellData["pmIcon"] as! UIImageView
                    
                    amIcon.anchorInCorner(Corner.TopRight, xPad: 0, yPad: 0, width: amIcon.width, height: amIcon.height)
                    pmIcon.anchorInCorner(Corner.BottomRight, xPad: 0, yPad: 0, width: pmIcon.width, height: pmIcon.height)
                }
            }
        }
        
        DrawCalendarGridDividerLine(gridPanel, weekLineCount: daysInWeek.count)
    }
    
    private func DrawFlexibleSchedule() {
        DrawDateTitleLabel()
        DrawCalendar(CurrentDay)
    }
    
    func GetSettingData() -> String {
        var ret = [[String: AnyObject]]()
        for (k, v) in SelectDict {
            
            var entry = [String: AnyObject]()
            entry["date"] = k
            entry["am"] = false
            entry["pm"] = false
            let status = v
            if("am" == status) {
                entry["am"] = true
            } else if("pm" == status) {
                entry["pm"] = true
            } else if("day" == status) {
                entry["am"] = true
                entry["pm"] = true
            }
            
            ret.append(entry)
        }
        
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(ret, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        print(strJson)
        return strJson
    }
    
    func LoadData() {
        let settingString = YMVar.MyUserInfo["admission_set_flexible"] as? String
        CurrentDay = NSDate()
        SelectDict.removeAll()

        if(nil != settingString) {
            let setting = JSON.parse(settingString!)
            
            for (_, setting) in setting.arrayValue.enumerate() {
                let date = setting["date"].stringValue
                let pm = setting["pm"].boolValue
                let am = setting["am"].boolValue
                
                if(YMValueValidator.IsEmptyString(date)) {
                    continue
                }
                
                if(pm && am) {
                    SelectDict[date] = "day"
                } else if(pm && !am) {
                    SelectDict[date] = "pm"
                } else if(!pm && am) {
                    SelectDict[date] = "am"
                }
            }
        }

        DrawCalendar(CurrentDay)
    }
}









