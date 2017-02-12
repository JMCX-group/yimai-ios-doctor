//
//  PageAdmissionTimeSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftyJSON
import SwiftDate

public class PageAdmissionFixedTimeSettingBodyView: PageBodyView {
    var SettingActions: PageAdmissionTimeSettingActions!
    
    private let WeekdayPanel = UIView()
    private var AMLineArr: [YMButton] = [YMButton]()
    private var PMLineArr: [YMButton] = [YMButton]()
    
    private let FixedTitleLabel = UILabel()
    
    private let CalendarPanel = UIView()
    
    public var CurrentDay = NSDate()
    
    private var SelectDict = [Int: String]()
    private var DayCellMapByWeek = [Int: [YMTouchableView]]()
    
    var FlexibleSetting = [String: [String: String]]()
    var FlexibleSettingFlag = [String: Bool]()
    
    var PrevMonthArrow: YMTouchableView? = nil
    var NextMonthArrow: YMTouchableView? = nil
    
    public var SettingData: [[String: AnyObject]] = [
        ["week":"sun", "am": false, "pm": false],
        ["week":"mon", "am": false, "pm": false],
        ["week":"tue", "am": false, "pm": false],
        ["week":"wed", "am": false, "pm": false],
        ["week":"thu", "am": false, "pm": false],
        ["week":"fri", "am": false, "pm": false],
        ["week":"sat", "am": false, "pm": false]
    ]

    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = self.Actions as! PageAdmissionTimeSettingActions
        DrawFixedSchedule()
    }
    
    public func LoadData() {
        let settingString = YMVar.MyUserInfo["admission_set_fixed"] as? String
        if (nil == settingString) {
//            UnselectAll()
            return
        }
        
        let setting = JSON.parse(settingString!)
        if (nil == setting) {
//            UnselectAll()
            return
        }
        
        TransformFlexibleData()

        for (idx,daySet) in setting.arrayValue.enumerate() {
            var targetStatus = "none"
            var amBtnSelectedStatus = false
            var pmBtnSelectedStatus = false

            if (false == daySet["pm"].boolValue && false == daySet["am"].boolValue) {
                targetStatus = "none"
            } else if (true == daySet["pm"].boolValue && false == daySet["am"].boolValue) {
                targetStatus = "pm"
                pmBtnSelectedStatus = true
            } else if (false == daySet["pm"].boolValue && true == daySet["am"].boolValue) {
                targetStatus = "am"
                amBtnSelectedStatus = true
            } else {
                targetStatus = "day"
                amBtnSelectedStatus = true
                pmBtnSelectedStatus = true
            }
//            ToggleWeekdayStatus(targetStatus, weekdayIdx: idx)
            SelectDict[idx] = targetStatus
            
            SettingData[idx] = [
                "week": daySet["week"].stringValue,
                "am": daySet["am"].boolValue,
                "pm": daySet["pm"].boolValue
            ]
            
            if(true == amBtnSelectedStatus) {
                AMLineArr[idx].backgroundColor = YMColors.WeekdaySelectedColor
                AMLineArr[idx].setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
            } else {
                AMLineArr[idx].backgroundColor = YMColors.None
                AMLineArr[idx].setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
            }
            
            if(true == pmBtnSelectedStatus) {
                PMLineArr[idx].backgroundColor = YMColors.WeekdaySelectedColor
                PMLineArr[idx].setTitleColor(YMColors.FontBlue, forState: UIControlState.Normal)
            } else {
                PMLineArr[idx].backgroundColor = YMColors.None
                PMLineArr[idx].setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
            }
        }
    }
    
    private func UnselectAll() {
        ToggleWeekdayStatus("none", weekdayIdx: 0)
        ToggleWeekdayStatus("none", weekdayIdx: 1)
        ToggleWeekdayStatus("none", weekdayIdx: 2)
        ToggleWeekdayStatus("none", weekdayIdx: 3)
        ToggleWeekdayStatus("none", weekdayIdx: 4)
        ToggleWeekdayStatus("none", weekdayIdx: 5)
        ToggleWeekdayStatus("none", weekdayIdx: 6)
    }
    
    public func DrawTopTabButton(topVeiw: UIView) {
        let tabBtn = UISegmentedControl(items: ["固定排班", "灵活排班"])
        topVeiw.addSubview(tabBtn)
        
        tabBtn.anchorToEdge(Edge.Bottom, padding: 20.LayoutVal(),
                            width: 344.LayoutVal(), height: 50.LayoutVal())
        
        tabBtn.tintColor = YMColors.White
        
        tabBtn.setTitleTextAttributes([NSFontAttributeName : YMFonts.YMDefaultFont(24.LayoutVal())!],
                                      forState: UIControlState.Normal)
        
        tabBtn.selectedSegmentIndex = 0
        
        tabBtn.addTarget(SettingActions!, action: "TabTouched:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    public func DrawTopConfirmButton(topView: UIView) {
        let button = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "SaveSetting:".Sel())
        
        button.backgroundColor = YMColors.None
        
        let buttonBkg = YMLayout.GetSuitableImageView("TopViewSmallButtonBkg")
        let label = UILabel()
        label.text = "保存"
        label.textColor = YMColors.White
        label.font = YMFonts.YMDefaultFont(30.LayoutVal())
        label.sizeToFit()
        
        button.addSubview(buttonBkg)
        button.addSubview(label)
        
        topView.addSubview(button)
        button.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 24.LayoutVal(), width: buttonBkg.width, height: buttonBkg.height)
        
        buttonBkg.anchorInCenter(width: buttonBkg.width, height: buttonBkg.height)
        label.anchorInCenter(width: label.width, height: label.height)
    }
    
    private func DrawWeekdayPanel() {
        BodyView.addSubview(WeekdayPanel)
        WeekdayPanel.anchorToEdge(Edge.Top, padding: 60.LayoutVal(), width: YMSizes.PageWidth, height: 238.LayoutVal())
        
        let firstLinePanel = UIView()
        let amLinePanel = UIView()
        let pmLinePanel = UIView()
        
        WeekdayPanel.addSubview(firstLinePanel)
        WeekdayPanel.addSubview(amLinePanel)
        WeekdayPanel.addSubview(pmLinePanel)
        
        firstLinePanel.anchorToEdge(Edge.Top, padding: 0, width: WeekdayPanel.width, height: 79.LayoutVal())
        amLinePanel.align(Align.UnderMatchingLeft, relativeTo: firstLinePanel, padding: 0,
                          width:  WeekdayPanel.width, height: 79.LayoutVal())
        pmLinePanel.align(Align.UnderMatchingLeft, relativeTo: amLinePanel, padding: 0,
                          width:  WeekdayPanel.width, height: 79.LayoutVal())
        
        let firstLineTitle = ["日", "一", "二", "三", "四", "五", "六"]
        var firstLineArr: [UILabel] = [UILabel]()
        let cellTouchedSel = "AMorPMCellTouched:".Sel()
        
        for (idx, val) in firstLineTitle.enumerate() {
            SelectDict[idx] = "none"
            DayCellMapByWeek[idx] = [YMTouchableView]()
            let weekDayCell = UILabel()
            weekDayCell.text = val
            weekDayCell.font = YMFonts.YMDefaultFont(26.LayoutVal())
            weekDayCell.textColor = YMColors.FontBlue
            weekDayCell.textAlignment = NSTextAlignment.Center
            weekDayCell.backgroundColor = YMColors.White
            firstLineArr.append(weekDayCell)
            firstLinePanel.addSubview(weekDayCell)
            
            let amCell = YMButton()
            amCell.setTitle("上午", forState: UIControlState.Normal)
            amCell.setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
            amCell.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
            amCell.addTarget(SettingActions!, action: cellTouchedSel, forControlEvents: UIControlEvents.TouchUpInside)
            amCell.UserObjectData = ["weekDay": idx, "AMorPM": "am"]
            AMLineArr.append(amCell)
            amLinePanel.addSubview(amCell)
            
            let pmCell = YMButton()
            pmCell.setTitle("下午", forState: UIControlState.Normal)
            pmCell.setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
            pmCell.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
            pmCell.addTarget(SettingActions!, action: cellTouchedSel, forControlEvents: UIControlEvents.TouchUpInside)
            pmCell.UserObjectData = ["weekDay": idx, "AMorPM": "pm"]
            PMLineArr.append(pmCell)
            pmLinePanel.addSubview(pmCell)
            
            if(0 == idx || 6 == idx) {
                amCell.backgroundColor = YMColors.SearchCellBorder
                pmCell.backgroundColor = YMColors.SearchCellBorder
            }
        }
        
        firstLinePanel.groupAndFill(group: Group.Horizontal, views: firstLineArr.map({$0 as UILabel}), padding: 0)
        amLinePanel.groupAndFill(group: Group.Horizontal, views: AMLineArr.map({$0 as YMButton}), padding: 0)
        pmLinePanel.groupAndFill(group: Group.Horizontal, views: PMLineArr.map({$0 as YMButton}), padding: 0)
        
        let baseLeft = 107.0.LayoutVal()
        for i in 1...6 {
            let divider = UIView()
            WeekdayPanel.addSubview(divider)
            divider.backgroundColor = YMColors.WeekdayLineColor
            divider.anchorToEdge(Edge.Left, padding: baseLeft * CGFloat(i), width: YMSizes.OnPx, height: WeekdayPanel.height)
        }
        
        let baseTop = 79.LayoutVal()
        for i in 0...3 {
            let divider = UIView()
            WeekdayPanel.addSubview(divider)
            divider.backgroundColor = YMColors.WeekdayLineColor
            divider.anchorToEdge(Edge.Top, padding: baseTop * CGFloat(i), width: WeekdayPanel.width, height: YMSizes.OnPx)
        }
    }
    
    private func DrawDateTitleLabel() {
        FixedTitleLabel.text = "您的接诊时间"
        FixedTitleLabel.textColor = YMColors.FontGray
        FixedTitleLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        FixedTitleLabel.textAlignment = NSTextAlignment.Center
        FixedTitleLabel.backgroundColor = YMColors.BackgroundGray
        
        BodyView.addSubview(FixedTitleLabel)
        FixedTitleLabel.align(Align.UnderMatchingLeft, relativeTo: WeekdayPanel, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
    }
    
    func ClearDayCellMap() {
        for (k, _) in DayCellMapByWeek {
            DayCellMapByWeek[k]?.removeAll()
        }
    }

    public func DrawCalendar(curDate: NSDate, showLeftArrow: Bool = false, showRightArrow: Bool = true) {
        YMLayout.ClearView(view: CalendarPanel)
        BodyView.addSubview(CalendarPanel)
        CalendarPanel.align(Align.UnderMatchingLeft, relativeTo: FixedTitleLabel, padding: 0, width: YMSizes.PageWidth, height: 744.LayoutVal())

        let monthPanel = YMTouchableView()
        let leftArrow = YMLayout.GetSuitableImageView("CommonLeftArrowIcon")
        let rightArrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
        
        let leftArrowBtn = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "PrevFixedMonth:".Sel())
        let rightArrowBtn = YMLayout.GetTouchableView(useObject: SettingActions!, useMethod: "NextFixedMonth:".Sel())
        
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
        
        leftArrowBtn.hidden = !showLeftArrow
        rightArrowBtn.hidden = !showRightArrow
        
        monthPanel.addSubview(monthLabel)
        monthLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        monthLabel.textColor = YMColors.FontBlue
        monthLabel.text = YMDatetimeString.YYYYMMinChinese(curDate)
        monthLabel.sizeToFit()
        monthLabel.anchorInCenter(width: monthLabel.width, height: monthLabel.height)

        
        DrawCalendarGrid(curDate, parent: CalendarPanel, prev: monthPanel)
    }
    
    private func BuildDisabledDayCell(day: Int, weekdayIdx: Int, showDay: Bool = false) -> YMTouchableView {
        let cell = YMTouchableView()
        
        let dayLabel = UILabel()

        if(showDay) {
            dayLabel.text = "\(day)"
        } else {
            dayLabel.text = ""
        }
        dayLabel.textColor = YMColors.WeekdayDisabledFontColor
        dayLabel.font = YMFonts.YMDefaultFont(32.LayoutVal())
        dayLabel.sizeToFit()

        cell.addSubview(dayLabel)

        cell.UserObjectData = ["label": dayLabel, "weekdayIdx": weekdayIdx]
        cell.UserStringData = "0"
        return cell
    }
    
    private func BuildNormalDayCell(day: Int, weekdayIdx: Int, initFlexible: Bool = false) -> YMTouchableView {
        let cellDate = NSDate(year: CurrentDay.year, month: CurrentDay.month, day: day)
        let today = NSDate()
        if (cellDate.timeIntervalSince1970 < today.timeIntervalSince1970) {
            return BuildDisabledDayCell(day, weekdayIdx: weekdayIdx, showDay: true)
        }

        let cell = YMLayout.GetTouchableView(useObject: SettingActions, useMethod: "FlexibleCellTouched:".Sel()) //YMTouchableView()
        
        let dayLabel = UILabel()
        dayLabel.text = "\(day)"
        dayLabel.textColor = YMColors.FontBlue
        dayLabel.font = YMFonts.YMDefaultFont(32.LayoutVal())
        dayLabel.sizeToFit()
        
        cell.addSubview(dayLabel)
//        if(0 == weekdayIdx || 6 == weekdayIdx) {
//            cell.backgroundColor = YMColors.None
//        } else {
//            cell.backgroundColor = YMColors.White
//        }
        
        cell.backgroundColor = YMColors.White

        let amIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingAMIcon")
        let pmIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingPMIcon")
      
        amIcon.hidden = true
        pmIcon.hidden = true
        
        cell.addSubview(amIcon)
        cell.addSubview(pmIcon)
        
        let cellDateStr = GetDayKey(cellDate)
        let month = GetMonthKey(cellDate)

        DayCellMapByWeek[weekdayIdx]?.append(cell)
        cell.UserObjectData = ["label": dayLabel, "weekdayIdx": weekdayIdx, "amIcon": amIcon, "pmIcon": pmIcon, "status": "none", "date": cellDate]
        cell.UserStringData = "1"

        var status = SelectDict[weekdayIdx]
        var flexibleStatus: String? = nil
        let flexible = IsFlexible(cellDate)

        if(initFlexible) {
            if("none" != status) {
                FlexibleSetting[month]![cellDateStr] = status
            }
        } else {
            flexibleStatus = FlexibleSetting[month]![cellDateStr]
        }

        if(flexible && nil != flexibleStatus) {
            status = flexibleStatus!
        } else {
            if(status != flexibleStatus && nil != flexibleStatus) {
//                if("none" != flexibleStatus!) {
                    status = flexibleStatus!
//                }
            }
        }

        if("day" == status) {
            SetDaySelected(cell, setByFlexible: flexible)
        } else if("am" == status) {
            SetDayCellAMSelected(cell, ignorePrev: flexible)
        } else if("pm" == status) {
            SetDayCellPMSelected(cell, ignorePrev: flexible)
        } else {
            SetDayUnSelected(cell, setByFlexible: flexible)
        }
        
        return cell
    }
    
    func GetMonthKey(date: NSDate) -> String {
        return  date.toString(DateFormat.Custom("YYYY-MM"))!
    }
    
    func GetDayKey(date: NSDate) -> String {
        return  date.toString(DateFormat.Custom("YYYY-MM-dd"))!
    }
    
    func GetCurrentDayFlexibleSetting(date: NSDate) -> String? {
        let dateStr = GetDayKey(date)
        let currentMonth = GetMonthKey(date)
        
        let setting =  FlexibleSetting[currentMonth]
        if(nil == setting) {
            return nil
        }

        return setting![dateStr]
    }
    
    func SetCurrentDayFlexibleSetting(date: NSDate, status: String?) {
        let dateStr = GetDayKey(date)
        let currentMonth = GetMonthKey(date)

        FlexibleSetting[currentMonth]?[dateStr] = status
    }
    
    func IsFlexible(date: NSDate) -> Bool {
        let key = GetDayKey(date)
        
        let ret = FlexibleSettingFlag[key]
        if(nil != ret) {
            return ret!
        } else {
            return false
        }
    }
    
    func SetFlexibleFlag(date: NSDate) {
        let key = GetDayKey(date)
        FlexibleSettingFlag[key] = true
    }
    
    func ClearFlexibleFlag(date: NSDate) {
        let key = GetDayKey(date)
        FlexibleSettingFlag.removeValueForKey(key)
    }

    func ClearFlexibleSetting(date: NSDate, cell: YMTouchableView) {
        ClearFlexibleFlag(date)
        let month = GetMonthKey(date)
        let dateStr = GetDayKey(date)
        FlexibleSetting[month]?.removeValueForKey(dateStr)
        
        let weekdayIdx = date.weekday - 1
        let setting = SettingData[weekdayIdx]
        let pm = setting["pm"] as! Bool
        let am = setting["am"] as! Bool
        
        if(pm && am) {
            SetDaySelected(cell)
        } else if(!pm && !am){
            SetDayUnSelected(cell)
        } else {
            if(pm) {
                SetDayCellPMSelected(cell)
            } else {
                SetDayCellAMSelected(cell)
            }
        }
    }
    
    func SetDayCellAMSelected(cell: YMTouchableView, ignorePrev: Bool = false) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        let date = cellData["date"] as! NSDate

        let flexibled = IsFlexible(date)

        if(ignorePrev) {
            amIcon.hidden = false
            pmIcon.hidden = true
            cellData["status"] = "am"
            SetCurrentDayFlexibleSetting(date, status: "am")
            SetFlexibleFlag(date)
            cell.backgroundColor = YMColors.WeekdaySelectedColor
        } else {
            if(flexibled) {
            } else {
                amIcon.hidden = false
                pmIcon.hidden = true
                cellData["status"] = "am"
                SetCurrentDayFlexibleSetting(date, status: "am")
                cell.backgroundColor = YMColors.WeekdaySelectedColor
            }
        }

        cell.UserObjectData = cellData
    }
    
    func SetDayCellPMSelected(cell: YMTouchableView, ignorePrev: Bool = false) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        let date = cellData["date"] as! NSDate

        let flexibled = IsFlexible(date)

        if(ignorePrev) {
            amIcon.hidden = true
            pmIcon.hidden = false
            cellData["status"] = "pm"
            cell.backgroundColor = YMColors.FontLightBlue
            SetCurrentDayFlexibleSetting(date, status: "pm")
            SetFlexibleFlag(date)
            cell.backgroundColor = YMColors.WeekdaySelectedColor
        } else {
            if(flexibled) {
            } else {
                amIcon.hidden = true
                pmIcon.hidden = false
                cellData["status"] = "pm"
                SetCurrentDayFlexibleSetting(date, status: "pm")
                cell.backgroundColor = YMColors.WeekdaySelectedColor
            }
        }
        
        cell.UserObjectData = cellData
    }
    
    func SetDaySelected(cell: YMTouchableView, setByFlexible: Bool = false) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        let date = cellData["date"] as! NSDate

        let flexibled = IsFlexible(date)

        if(setByFlexible) {
            amIcon.hidden = false
            pmIcon.hidden = false
            SetCurrentDayFlexibleSetting(date, status: "day")
            SetFlexibleFlag(date)
            cell.backgroundColor = YMColors.WeekdaySelectedColor
        } else {
            if(flexibled) {
            } else {
                amIcon.hidden = false
                pmIcon.hidden = false
                cellData["status"] = "day"
                SetCurrentDayFlexibleSetting(date, status: "day")
                cell.backgroundColor = YMColors.WeekdaySelectedColor
            }
        }

        cell.UserObjectData = cellData
    }
    
    func SetDayUnSelected(cell: YMTouchableView, setByFlexible: Bool = false) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        let date = cellData["date"] as! NSDate
        let flexibled = IsFlexible(date)
        
        if("0" == cell.UserStringData) {
            return
        }
        
        if(setByFlexible) {
            amIcon.hidden = true
            pmIcon.hidden = true
            SetCurrentDayFlexibleSetting(date, status: "none")
            cell.backgroundColor = YMColors.White
            SetFlexibleFlag(date)
        } else {
            if(flexibled) {
            } else {
                amIcon.hidden = true
                pmIcon.hidden = true
                cellData["status"] = "none"
                SetCurrentDayFlexibleSetting(date, status: "none")
                cell.backgroundColor = YMColors.White
            }
        }
        
        cell.UserObjectData = cellData
    }
    
    public func ToggleWeekdayAM(weekdayIdx: Int) -> Bool {
        var targetSelectDictVal = "none"
        var targetKey: Int = -1
        for (k, v) in SelectDict {
            if(k == weekdayIdx) {
                targetKey = k
                if("am" == v) {
                    targetSelectDictVal = "none"
                } else if("pm" == v) {
                    targetSelectDictVal = "day"
                } else if("day" == v) {
                    targetSelectDictVal = "pm"
                } else {
                    targetSelectDictVal = "am"
                }
                break
            }
        }
        
        if(targetKey != -1){
            SelectDict[targetKey] = targetSelectDictVal
        }
        
        ToggleWeekdayStatus(targetSelectDictVal, weekdayIdx: weekdayIdx)
        
        return ("am" == targetSelectDictVal || "day" == targetSelectDictVal)
    }
    
    public func ToggleWeekdayPM(weekdayIdx: Int) -> Bool {
        var targetSelectDictVal = "none"
        var targetKey: Int = -1
        for (k, v) in SelectDict {
            if(k == weekdayIdx) {
                targetKey = k
                if("pm" == v) {
                    targetSelectDictVal = "none"
                } else if("am" == v) {
                    targetSelectDictVal = "day"
                } else if("day" == v) {
                    targetSelectDictVal = "am"
                } else {
                    targetSelectDictVal = "pm"
                }
                break
            }
        }
        
        if(targetKey != -1){
            SelectDict[targetKey] = targetSelectDictVal
        }
        
        ToggleWeekdayStatus(targetSelectDictVal, weekdayIdx: weekdayIdx)
        
        return ("pm" == targetSelectDictVal || "day" == targetSelectDictVal)
    }
    
    private func ToggleWeekdayStatus(status: String, weekdayIdx: Int) {
        if("none" == status) {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDayUnSelected(v)
                SettingData[weekdayIdx]["am"] = false
                SettingData[weekdayIdx]["pm"] = false
            }
        } else if("day" == status) {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDaySelected(v)
                SettingData[weekdayIdx]["am"] = true
                SettingData[weekdayIdx]["pm"] = true
            }
        }  else if("pm" == status) {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDayCellPMSelected(v)
                SettingData[weekdayIdx]["am"] = false
                SettingData[weekdayIdx]["pm"] = true
            }
        }  else {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDayCellAMSelected(v)
                SettingData[weekdayIdx]["am"] = true
                SettingData[weekdayIdx]["pm"] = false
            }
        }
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

        let month = GetMonthKey(CurrentDay)
        let flexible = FlexibleSetting[month]
        var flexibleInit = false
        if(nil == flexible) {
            FlexibleSetting[month] = [String: String]()
            flexibleInit = true
        }

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
                    cell = BuildNormalDayCell(day, weekdayIdx: weekdayIdx, initFlexible: flexibleInit)
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
    
    func FillFlexibleSetting(date: NSDate) {
        let month = GetMonthKey(date)
        let monthSetting = FlexibleSetting[month]
        if(nil == monthSetting) {
            FlexibleSetting[month] = [String: String]()
        }
        
        print(FlexibleSetting[month]?.count)
        if(0 == FlexibleSetting[month]!.count){
            
            for i in 1 ... date.monthDays {
                let thisDay = NSDate(year: date.year, month: date.month, day: i)
                let dateKey = GetDayKey(thisDay)
                let weekdayIdx = thisDay.weekday - 1
                let setting = SettingData[weekdayIdx]
                let pm = setting["pm"] as! Bool
                let am = setting["am"] as! Bool

//                print("!!!")
//                print("\(date.year) - \(date.month) - \(i)")
//                print("setting: \(setting) for \(weekdayIdx)")
//                print("!!!")

                let flexible = IsFlexible(thisDay)
                if(!flexible) {
                    if(pm && am) {
                        FlexibleSetting[month]![dateKey] = "day"
                    } else if(!pm && !am){
                        FlexibleSetting[month]![dateKey] = "none"
                    } else {
                        if(pm) {
                            FlexibleSetting[month]![dateKey] = "pm"
                        } else {
                            FlexibleSetting[month]![dateKey] = "am"
                        }
                    }
                }
            }
        }
    }

    func GetFlexibleSetting() -> String {
        var ret = [[String: AnyObject]]()
        
        let today = NSDate()
        let firstMonthDay = NSDate(year: today.year, month: today.month, day: 1)
        let nextMonthDay = firstMonthDay.add(0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, nanoseconds: 0)
        let dayAfterNextMonthDay = nextMonthDay.add(0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, nanoseconds: 0)

        FillFlexibleSetting(firstMonthDay)
        FillFlexibleSetting(nextMonthDay)
        FillFlexibleSetting(dayAfterNextMonthDay)

        for (_, setting) in FlexibleSetting {
            for (k, v) in setting {
                
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
        }
        
        let jsonData = try! NSJSONSerialization.dataWithJSONObject(ret, options: NSJSONWritingOptions.PrettyPrinted)
        let strJson = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        return strJson
    }
    
//    func GetFlexibleSettingKey(date: NSDate) -> String {
//        return "\(date.year)-\(date.month)"
//    }
    
    func TransformFlexibleData() {
        let settingString = YMVar.MyUserInfo["admission_set_flexible"] as? String
        let firstMonthDay = NSDate(year: CurrentDay.year, month: CurrentDay.month, day: 1)
        let nextMonthDay = firstMonthDay.add(0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, nanoseconds: 0)
        let dayAfterNextMonthDay = nextMonthDay.add(0, months: 1, weeks: 0, days: 0, hours: 0, minutes: 0, seconds: 0, nanoseconds: 0)
        
        FlexibleSetting[GetMonthKey(firstMonthDay)] = [String: String]()
        FlexibleSetting[GetMonthKey(nextMonthDay)] = [String: String]()
        FlexibleSetting[GetMonthKey(dayAfterNextMonthDay)] = [String: String]()
        
        if(nil != settingString) {
            let setting = JSON.parse(settingString!)

            for (_, setting) in setting.arrayValue.enumerate() {
                let date = setting["date"].stringValue
                let pm = setting["pm"].boolValue
                let am = setting["am"].boolValue
                
                if(YMValueValidator.IsBlankString(date)) {
                    continue
                }
                
                let dateComponent = date.componentsSeparatedByString("-")
                
                let monthStr = dateComponent[0] + "-" + dateComponent[1]
                if(nil == FlexibleSetting[monthStr]) {
                    FlexibleSetting[monthStr] = [String: String]()
                }

                if(pm && am) {
                    FlexibleSetting[monthStr]![date] = "day"
                } else if(pm && !am) {
                    FlexibleSetting[monthStr]![date] = "pm"
                } else if(!pm && am) {
                    FlexibleSetting[monthStr]![date] = "am"
                } else {
                    FlexibleSetting[monthStr]![date] = "none"
                }
            }
        }
    }
    
    func DrawFixedSchedule() {
        DrawWeekdayPanel()
        DrawDateTitleLabel()
//        TransformFlexibleData()
        LoadData()
        DrawCalendar(CurrentDay)
    }
}


















