//
//  PageAdmissionTimeSettingBodyView.swift
//  YiMai
//
//  Created by superxing on 16/7/14.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAdmissionTimeSettingBodyView: PageBodyView {
    var SettingActions: PageAdmissionTimeSettingActions? = nil
    
    private let WeekdayPanel = UIView()
    private var AMLineArr: [YMButton] = [YMButton]()
    private var PMLineArr: [YMButton] = [YMButton]()
    
    private let FixedTitleLabel = UILabel()
    
    private let CalendarPanel = UIView()
    
    override func ViewLayout() {
        super.ViewLayout()
        SettingActions = PageAdmissionTimeSettingActions(navController: NavController!,
                                                         target: self)

        DrawFixedSchedule()
        DrawFlexibleSchedule()
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
            amCell.backgroundColor = YMColors.DividerLineGray
            amCell.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
            amCell.addTarget(SettingActions!, action: cellTouchedSel, forControlEvents: UIControlEvents.TouchUpInside)
            amCell.UserObjectData = ["weekDay": idx, "AMorPM": "am"]
            AMLineArr.append(amCell)
            amLinePanel.addSubview(amCell)
            
            let pmCell = YMButton()
            pmCell.setTitle("下午", forState: UIControlState.Normal)
            pmCell.setTitleColor(YMColors.WeekdayDisabledFontColor, forState: UIControlState.Normal)
            pmCell.backgroundColor = YMColors.DividerLineGray
            pmCell.titleLabel?.font = YMFonts.YMDefaultFont(26.LayoutVal())
            pmCell.addTarget(SettingActions!, action: cellTouchedSel, forControlEvents: UIControlEvents.TouchUpInside)
            amCell.UserObjectData = ["weekDay": idx, "AMorPM": "pm"]
            PMLineArr.append(pmCell)
            pmLinePanel.addSubview(pmCell)
        }
        
        firstLinePanel.groupAndFill(group: Group.Horizontal, views: firstLineArr.map({$0 as UILabel}), padding: 0)
        amLinePanel.groupAndFill(group: Group.Horizontal, views: AMLineArr.map({$0 as YMButton}), padding: 0)
        pmLinePanel.groupAndFill(group: Group.Horizontal, views: PMLineArr.map({$0 as YMButton}), padding: 0)
        
        let baseLeft = 106.0.LayoutVal()
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

    private func DrawCalendar(curDate: NSDate) {
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
        
        CalendarPanel.addSubview(monthLabel)
        monthLabel.font = YMFonts.YMDefaultFont(26.LayoutVal())
        monthLabel.textColor = YMColors.FontBlue
        monthLabel.text = ""
        monthLabel.sizeToFit()
        monthLabel.anchorInCenter(width: monthLabel.width, height: monthLabel.height)
        
        DrawCalendarGrid(curDate, parent: CalendarPanel, prev: monthLabel)
    }
    
    private func BuildDisabledDayCell(day: Int) -> YMTouchableView {
        return YMTouchableView()
    }
    
    private func BuildNormalDayCell(day: Int) -> YMTouchableView {
        return YMTouchableView()
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
            for day in week {
                var cell: YMTouchableView!
                if(day < 0) {
                    let realDay = -day
                    cell = BuildDisabledDayCell(realDay)
                } else if(day >= 100) {
                    let realDay = day / 100
                    cell = BuildDisabledDayCell(realDay)
                } else {
                    cell = BuildNormalDayCell(day)
                }
                
                cellArr.append(cell)
            }
            
            weekLine.UserObjectData = cellArr
        }
    }
    
    private func DrawFixedSchedule() {
        DrawWeekdayPanel()
        DrawDateTitleLabel()
        DrawCalendar(NSDate())
        
    }
    
    private func DrawFlexibleSchedule() {
        
    }
}


















