//
//  PageAdmissionTimeSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

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

    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = self.Actions as! PageAdmissionTimeSettingActions
        DrawFixedSchedule()
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

    public func DrawCalendar(curDate: NSDate) {
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
        let cell = YMTouchableView()
        
        let dayLabel = UILabel()
        dayLabel.text = "\(day)"
        dayLabel.textColor = YMColors.FontBlue
        dayLabel.font = YMFonts.YMDefaultFont(32.LayoutVal())
        dayLabel.sizeToFit()
        
        cell.addSubview(dayLabel)
        if(0 == weekdayIdx || 6 == weekdayIdx) {
            cell.backgroundColor = YMColors.None
        } else {
            cell.backgroundColor = YMColors.White
        }
        
        let amIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingAMIcon")
        let pmIcon = YMLayout.GetSuitableImageView("PageAdmissionTimeSettingPMIcon")
      
        amIcon.hidden = true
        pmIcon.hidden = true
        
        cell.addSubview(amIcon)
        cell.addSubview(pmIcon)
        
        cell.UserObjectData = ["label": dayLabel, "weekdayIdx": weekdayIdx, "amIcon": amIcon, "pmIcon": pmIcon, "status": "none"]
        cell.UserStringData = "1"

        DayCellMapByWeek[weekdayIdx]?.append(cell)
        return cell
    }
    
    private func SetDayCellAMSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = false
        pmIcon.hidden = true
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "am"
        cell.UserObjectData = cellData
    }
    
    private func SetDayCellPMSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = true
        pmIcon.hidden = false
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "pm"
        cell.UserObjectData = cellData
    }
    
    private func SetDaySelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = false
        pmIcon.hidden = false
        
        cell.backgroundColor = YMColors.WeekdaySelectedColor
        cellData["status"] = "day"
        cell.UserObjectData = cellData
    }
    
    private func SetDayUnSelected(cell: YMTouchableView) {
        var cellData = cell.UserObjectData as! [String: AnyObject]
        let amIcon = cellData["amIcon"] as! UIImageView
        let pmIcon = cellData["pmIcon"] as! UIImageView
        
        amIcon.hidden = true
        pmIcon.hidden = true
        
        cell.backgroundColor = YMColors.White
        cellData["status"] = "none"
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
            }
        } else if("day" == status) {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDaySelected(v)
            }
        }  else if("pm" == status) {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDayCellPMSelected(v)
            }
        }  else {
            for v in DayCellMapByWeek[weekdayIdx]! {
                SetDayCellAMSelected(v)
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
    
    private func DrawFixedSchedule() {
        DrawWeekdayPanel()
        DrawDateTitleLabel()
        DrawCalendar(CurrentDay)
    }
}


















