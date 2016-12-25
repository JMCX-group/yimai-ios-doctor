//
//  PageAppointmentRecordBodyView.swift
//  YiMai
//
//  Created by why on 16/6/23.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageAppointmentRecordBodyView: PageBodyView {
    private var RecordActions: PageAppointmentRecordActions? = nil
    
    let TabPanel = UIView()
    public var TabWaitButton: YMTouchableView? = nil
    public var TabAlreadyButton: YMTouchableView? = nil

    private var WaitList = UIScrollView()
    private var AlreadyList = UIScrollView()

    private var CurrentListType = ""
    
    private var RecordListMap = [String: UIView]()
    
    private var WaitRecord: [[String: AnyObject]]? = nil
    private var AlreadyRecord: [[String: AnyObject]]? = nil
    
    public var Loading: YMPageLoadingView? = nil

    override func ViewLayout() {
        super.ViewLayout()
        self.RecordActions = PageAppointmentRecordActions(navController: self.NavController!, target: self)
        Loading = YMPageLoadingView(parentView: self.ParentView!)
        Loading?.MaskBackground.layer.zPosition = 10.0

        RecordListMap[YMAppointmentRecordStrings.RECORD_ALREAD_STATUS] = AlreadyList
        RecordListMap[YMAppointmentRecordStrings.RECORD_WAIT_STATUS] = WaitList

        DrawTabTitle()
    }
    
    private func DrawTabTitle() {
        TabWaitButton = YMLayout.GetTouchableView(useObject: RecordActions!, useMethod: "WaitTabTouched:".Sel())
        TabAlreadyButton = YMLayout.GetTouchableView(useObject: RecordActions!, useMethod: "AlreadyTabTouched:".Sel())
        
        BodyView.addSubview(TabPanel)
        TabPanel.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 80.LayoutVal())
        
        TabPanel.backgroundColor = YMColors.BackgroundGray
        
        TabPanel.addSubview(TabWaitButton!)
        TabPanel.addSubview(TabAlreadyButton!)
        
        TabPanel.groupAndFill(group: Group.Horizontal, views: [TabWaitButton!, TabAlreadyButton!], padding: 0)
        
        func DrawTabLabel(tabButton: UIView, text: String) -> [String: UILabel] {
            let title = UILabel()
            let bottomLine = UILabel()
            
            title.text = text
            title.font = YMFonts.YMDefaultFont(30.LayoutVal())
            title.textColor = YMColors.None
            title.sizeToFit()
            
            tabButton.addSubview(title)
            title.anchorInCenter(width: title.width, height: title.height)
            
            bottomLine.backgroundColor = YMColors.None
            
            tabButton.addSubview(bottomLine)
            bottomLine.anchorToEdge(Edge.Bottom, padding: 0, width: tabButton.width, height: 4.LayoutVal())
            
            return [YMAppointmentRecordStrings.TAB_LABEL_TEXT_KEY: title, YMAppointmentRecordStrings.TAB_LABEL_BORDER_KEY: bottomLine]
        }
        
        TabWaitButton?.UserObjectData = DrawTabLabel(TabWaitButton!, text: "待回复")
        TabAlreadyButton?.UserObjectData = DrawTabLabel(TabAlreadyButton!, text: "已回复")
    }
    
    private func DrawAppointmentCell(parent: UIView, data: [String: AnyObject], prev: YMTouchableView? = nil) -> YMTouchableView? {
        let docNameString = YMVar.GetStringByKey(data, key: "doctor_name", defStr: "请您代选")
        let appointmentTime = YMVar.GetStringByKey(data, key: "time")
        let userHead = YMVar.GetStringByKey(data, key: "doctor_head_url")
        let jobTitleStr = YMVar.GetStringByKey(data, key: "doctor_job_title", defStr: "医生")
        let statusCode = YMVar.GetStringByKey(data, key: "status_code")
        let statusString = YMVar.GetStringByKey(data, key:"status")
        
        if("wait-0" != statusCode) {
            if(YMValueValidator.IsBlankString(docNameString)) {
                return prev
            }
        }
        
        if(YMValueValidator.IsBlankString(appointmentTime)) {
            return prev
        }
        
        let cell = YMLayout.GetTouchableView(useObject: RecordActions!, useMethod: "RecordSelected:".Sel())
        parent.addSubview(cell)
        if(nil != prev) {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 151.LayoutVal())
        } else {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 151.LayoutVal())
        }
        
        cell.UserObjectData = data
        
        
        let borderBottom = UIView()
        borderBottom.backgroundColor = YMColors.DividerLineGray
        
        cell.addSubview(borderBottom)
        borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        let headImage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let name = UILabel()
        let jobTitle = UILabel()
        let patientIcon = YMLayout.GetSuitableImageView("YMIconPatient")
        let timeIcon = YMLayout.GetSuitableImageView("YMIconClockBlue")
        let time = UILabel()
        let patient = UILabel()
        let status = UILabel()
        let divider = UIView()
        let bottom = UIView()

        cell.addSubview(headImage)
        cell.addSubview(name)
        cell.addSubview(jobTitle)
        cell.addSubview(patientIcon)
        cell.addSubview(timeIcon)
        cell.addSubview(time)
        cell.addSubview(patient)
        cell.addSubview(status)
        cell.addSubview(divider)
        cell.addSubview(bottom)
        
        headImage.anchorInCorner(Corner.TopLeft,
            xPad: 40.LayoutVal(), yPad: 20.LayoutVal(),
            width: headImage.width, height: headImage.height)
        YMLayout.LoadImageFromServer(headImage, url: userHead, fullUrl: nil, makeItRound: true)
        
        name.text = docNameString
        name.textColor = YMColors.FontBlue
        name.font = YMFonts.YMDefaultFont(30.LayoutVal())
        name.sizeToFit()
        name.anchorInCorner(Corner.TopLeft,
            xPad: 180.LayoutVal(), yPad: 30.LayoutVal(),
            width: name.width, height: name.height)
        
        divider.backgroundColor = YMColors.FontBlue
        divider.align(Align.ToTheRightCentered, relativeTo: name, padding: 14.LayoutVal(),
            width: YMSizes.OnPx, height: 20.LayoutVal())
        
        jobTitle.text = jobTitleStr
        jobTitle.textColor = YMColors.FontGray
        jobTitle.font = YMFonts.YMDefaultFont(20.LayoutVal())
        jobTitle.sizeToFit()
        jobTitle.align(Align.ToTheRightCentered, relativeTo: divider,
            padding: 14.LayoutVal(), width: jobTitle.width, height: jobTitle.height)
        
        patientIcon.align(Align.UnderMatchingLeft, relativeTo: name,
            padding: 12.LayoutVal(),
            width: patientIcon.width, height: patientIcon.height)
        
        let patientNameString = YMVar.GetStringByKey(data, key: "patient_name")
        patient.text = "患者 \(patientNameString)"
        patient.textColor = YMColors.FontBlue
        patient.font = YMFonts.YMDefaultFont(20.LayoutVal())
        patient.sizeToFit()
        patient.align(Align.ToTheRightCentered, relativeTo: patientIcon,
            padding: 12.LayoutVal(), width: patient.width, height: patient.height)
        
        timeIcon.align(Align.UnderCentered, relativeTo: patientIcon,
            padding: 12.LayoutVal(), width: timeIcon.width, height: timeIcon.height)
        
        time.text = appointmentTime//data["time"] as? String
        time.textColor = YMColors.FontLightGray
        time.font = YMFonts.YMDefaultFont(20.LayoutVal())
        time.sizeToFit()
        time.align(Align.UnderMatchingLeft, relativeTo: patient,
            padding: 8.LayoutVal(), width: time.width, height: time.height)
        
        status.text = statusString
        if("医生关闭" == statusString) {
            status.textColor = YMColors.FontGray
        } else if("患者关闭" == statusString) {
            status.textColor = YMColors.FontGray
        } else if("待面诊" == statusString) {
            status.textColor = YMColors.WarningFontColor
        } else if ("已过期" == statusString) {
            status.textColor = YMColors.FontGray
        } else if ("面诊完成" == statusString) {
            status.textColor = YMColors.FontBlue
        } else {
            status.textColor = YMColors.FontBlue
        }
        status.font = YMFonts.YMDefaultFont(24.LayoutVal())
        status.sizeToFit()
        status.anchorInCorner(Corner.TopRight,
            xPad: 40.LayoutVal(), yPad: 36.LayoutVal(),
            width: status.width, height: status.height)

        return cell
    }
    
    private func DrawWaitList() {
        BodyView.addSubview(WaitList)
        WaitList.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: BodyView.height - YMSizes.NormalTopSize.height - TabPanel.height)

        var noRecordIcon: UIImageView? = nil
        
        if(nil == WaitRecord) {
            noRecordIcon = YMLayout.GetSuitableImageView("NoAppointmentRecord")
            WaitList.addSubview(noRecordIcon!)
            noRecordIcon!.anchorInCenter(width: noRecordIcon!.width, height: noRecordIcon!.height)
            return
        }
        
        if(0 == WaitRecord!.count) {
            noRecordIcon = YMLayout.GetSuitableImageView("NoAppointmentRecord")
            WaitList.addSubview(noRecordIcon!)
            noRecordIcon!.anchorInCenter(width: noRecordIcon!.width, height: noRecordIcon!.height)
            return
        }
        
        var prev: YMTouchableView? = nil
        for v in WaitRecord! {
            prev = self.DrawAppointmentCell(WaitList, data: v, prev: prev)
        }
    
        YMLayout.SetVScrollViewContentSize(WaitList, lastSubView: prev)
    }
    
    private func DrawAlreadyList() {
        BodyView.addSubview(AlreadyList)
        AlreadyList.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: BodyView.height - YMSizes.NormalTopSize.height - TabPanel.height)
        
        var noRecordIcon: UIImageView? = nil
        
        if(nil == WaitRecord) {
            noRecordIcon = YMLayout.GetSuitableImageView("NoAppointmentRecord")
            AlreadyList.addSubview(noRecordIcon!)
            noRecordIcon!.anchorInCenter(width: noRecordIcon!.width, height: noRecordIcon!.height)
            return
        }
        
        if(0 == WaitRecord!.count) {
            noRecordIcon = YMLayout.GetSuitableImageView("NoAppointmentRecord")
            AlreadyList.addSubview(noRecordIcon!)
            noRecordIcon!.anchorInCenter(width: noRecordIcon!.width, height: noRecordIcon!.height)
            return
        }
        
        var prev: YMTouchableView? = nil
        for v in AlreadyRecord! {
            prev = self.DrawAppointmentCell(AlreadyList, data: v, prev: prev)
        }
        
        YMLayout.SetVScrollViewContentSize(AlreadyList, lastSubView: prev)
    }
    
    private func SetTabSelected() {
        let waitControls = TabWaitButton!.UserObjectData as! [String: UILabel]
        let alreadyControls = TabAlreadyButton!.UserObjectData as! [String: UILabel]
        
        switch CurrentListType {
        case YMAppointmentRecordStrings.RECORD_WAIT_STATUS:
            TabWaitButton?.backgroundColor = YMColors.White
            waitControls[YMAppointmentRecordStrings.TAB_LABEL_BORDER_KEY]!.backgroundColor = YMColors.FontBlue
            waitControls[YMAppointmentRecordStrings.TAB_LABEL_TEXT_KEY]!.textColor = YMColors.FontBlue
            
            TabAlreadyButton?.backgroundColor = YMColors.None
            alreadyControls[YMAppointmentRecordStrings.TAB_LABEL_BORDER_KEY]!.backgroundColor = YMColors.None
            alreadyControls[YMAppointmentRecordStrings.TAB_LABEL_TEXT_KEY]!.textColor = YMColors.FontGray
            break
            
        case YMAppointmentRecordStrings.RECORD_ALREAD_STATUS:
            TabWaitButton?.backgroundColor = YMColors.None
            waitControls[YMAppointmentRecordStrings.TAB_LABEL_BORDER_KEY]!.backgroundColor = YMColors.None
            waitControls[YMAppointmentRecordStrings.TAB_LABEL_TEXT_KEY]!.textColor = YMColors.FontGray
            
            TabAlreadyButton?.backgroundColor = YMColors.White
            alreadyControls[YMAppointmentRecordStrings.TAB_LABEL_BORDER_KEY]!.backgroundColor = YMColors.FontBlue
            alreadyControls[YMAppointmentRecordStrings.TAB_LABEL_TEXT_KEY]!.textColor = YMColors.FontBlue
            break
            
        default:
            break
        }
    }
    
    public func GetAppointmentRecord() {
        Loading?.Show()
        RecordActions?.GetAppointmentList()
    }
    
    public func ShowList(wich: String) {
        if(CurrentListType == wich) { return }
        CurrentListType = wich
        
        switch CurrentListType {
        case YMAppointmentRecordStrings.RECORD_ALREAD_STATUS:
            WaitList.hidden = true
            AlreadyList.hidden = false
            break
            
        case YMAppointmentRecordStrings.RECORD_WAIT_STATUS:
            WaitList.hidden = false
            AlreadyList.hidden = true
            break
            
        default:
            break
        }
        
        SetTabSelected()
    }
    
    public func LoadData(data: NSDictionary?) {
        WaitRecord = data!["wait"] as? [[String:AnyObject]]
        AlreadyRecord = data!["already"] as? [[String:AnyObject]]
        
        DrawWaitList()
        DrawAlreadyList()
        
        ShowList(YMAppointmentRecordStrings.RECORD_WAIT_STATUS)
        Loading?.Hide()
    }
    
    public func Clear() {
        WaitRecord = nil
        AlreadyRecord = nil

        RecordListMap.removeAll()

        YMLayout.ClearView(view: WaitList)
        YMLayout.ClearView(view: AlreadyList)
        
        WaitList.removeFromSuperview()
        AlreadyList.removeFromSuperview()
        
        WaitList.contentSize = CGSizeMake(0, 0)
        AlreadyList.contentSize = CGSizeMake(0, 0)
    }
}



























