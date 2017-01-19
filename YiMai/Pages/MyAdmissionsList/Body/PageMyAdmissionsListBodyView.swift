//
//  PageMyAdmissionsListBodyView.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import QuartzCore

public struct YMMyAdmissionsMessage {
    var MsgId: String
    var MsgContent: String
    var StatusString: String
    var Status: String
    var datatime: String
}

enum AdmissionSelectedPanelType {
    case WaitReply
    case Complete
    case WaitComplete
}

public class PageMyAdmissionsListBodyView: PageBodyView {
    private let timeFontSize = 22.LayoutVal()
    private let normalPadding = 20.LayoutVal()
    
    private let TabPanel = UIView()
    private var CompleteTabButton: YMTouchableView? = nil
    private var WaitCompleteTabButton: YMTouchableView? = nil
    private var WaitReplyTabButton: YMTouchableView? = nil
    
    private let CompleteTabTitle: UILabel = UILabel()
    private let WaitCompleteTabTitle: UILabel = UILabel()
    private let WaitReplyTabTitle: UILabel = UILabel()
    
    private let TabIndcBorder = UIView()
    
    private var CompletePanel = UIScrollView()
    private var WaitCompletePanel = UIScrollView()
    private var WaitReplyPanel = UIScrollView()
    
    private var CompletePanelDrew = false
    private var WaitCompletePanelDrew = false
    private var WaitReplyPanelDrew = false

    var CurrentPanel = AdmissionSelectedPanelType.WaitReply
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray

        DrawTabPanel()
    }
    
    private func DrawTabPanel() {
        func DrawTabButton(button: YMTouchableView, label: UILabel, title: String) {
            label.text = title
            label.textColor = YMColors.FontGray
            label.font = YMFonts.YMDefaultFont(30.LayoutVal())
            label.sizeToFit()

            button.addSubview(label)
            label.anchorInCenter(width: label.width, height: label.height)
        }
        
        CompleteTabButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowComplete:".Sel())
        WaitCompleteTabButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowWaitComplete:".Sel())
        WaitReplyTabButton = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "ShowWaitReply:".Sel())

        BodyView.addSubview(TabPanel)
        TabPanel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 80.LayoutVal())
        TabPanel.backgroundColor = YMColors.BackgroundGray

        BodyView.addSubview(CompletePanel)
        BodyView.addSubview(WaitCompletePanel)
        BodyView.addSubview(WaitReplyPanel)

        let panelHeight = BodyView.height - TabPanel.height - YMSizes.NormalTopSize.height
        CompletePanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: panelHeight)
        WaitCompletePanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: panelHeight)
        WaitReplyPanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: panelHeight)
        
        TabPanel.addSubview(WaitReplyTabButton!)
        TabPanel.addSubview(WaitCompleteTabButton!)
        TabPanel.addSubview(CompleteTabButton!)

        TabPanel.groupAndFill(group: Group.Horizontal,
            views: [WaitReplyTabButton!, WaitCompleteTabButton!, CompleteTabButton!],
            padding: 0)
        
        let divider1 = UIView()
        let divider2 = UIView()
        
        divider1.backgroundColor = YMColors.FontBlue
        divider2.backgroundColor = YMColors.FontBlue
        
        TabPanel.addSubview(divider1)
        TabPanel.addSubview(divider2)
        
        divider1.align(Align.ToTheRightCentered, relativeTo: WaitReplyTabButton!,
            padding: 0, width: YMSizes.OnPx, height: 30.LayoutVal())
        
        divider2.align(Align.ToTheRightCentered, relativeTo: WaitCompleteTabButton!,
            padding: 0, width: YMSizes.OnPx, height: 30.LayoutVal())
        
        DrawTabButton(WaitReplyTabButton!, label: WaitReplyTabTitle, title: "待回复")
        DrawTabButton(WaitCompleteTabButton!, label: WaitCompleteTabTitle, title: "待完成")
        DrawTabButton(CompleteTabButton!, label: CompleteTabTitle, title: "已结束")

        TabPanel.addSubview(TabIndcBorder)
        TabIndcBorder.backgroundColor = YMColors.FontBlue
        TabIndcBorder.align(Align.UnderCentered, relativeTo: WaitReplyTabButton!,
            padding: -4.LayoutVal(), width: 120.LayoutVal(), height: 4.LayoutVal())
    }
    
    public func ShowCompletePanel() {
        if(!CompletePanelDrew) {
            var lastView:UIView? = nil
            let listData = PageMyAdmissionsListViewController.CompletedAdmissions
            for data in listData {
                lastView = DrawAdmissionList(data, prevView: lastView, parent: CompletePanel, actionMethod: "AdmissionCompleteTouched:".Sel())
            }
            
            if(nil != lastView) {
                YMLayout.SetVScrollViewContentSize(CompletePanel, lastSubView: lastView!)
            }
        }
        
        CurrentPanel = AdmissionSelectedPanelType.Complete

        CompletePanelDrew = true
        
        CompleteTabTitle.textColor = YMColors.FontBlue
        WaitCompleteTabTitle.textColor = YMColors.FontGray
        WaitReplyTabTitle.textColor = YMColors.FontGray
        
        CompletePanel.hidden = false
        WaitCompletePanel.hidden = true
        WaitReplyPanel.hidden = true
        
        TabIndcBorder.align(Align.UnderCentered,
            relativeTo: CompleteTabButton!,
            padding: -4.LayoutVal(),
            width: 120.LayoutVal(), height: 4.LayoutVal())
    }
    
    public func ShowWaitCompletePanel() {
        if(!WaitCompletePanelDrew) {
            var lastView:UIView? = nil
            let listData = PageMyAdmissionsListViewController.WaitCompletedAdmissions
            for data in listData {
                lastView = DrawAdmissionList(data, prevView: lastView, parent: WaitCompletePanel, actionMethod: "AdmissionWaitCompleteTouched:".Sel())
            }
            
            if(nil != lastView) {
                YMLayout.SetVScrollViewContentSize(WaitCompletePanel, lastSubView: lastView!)
            }
        }
        
        CurrentPanel = AdmissionSelectedPanelType.WaitComplete

        WaitCompletePanelDrew = true
        
        CompleteTabTitle.textColor = YMColors.FontGray
        WaitCompleteTabTitle.textColor = YMColors.FontBlue
        WaitReplyTabTitle.textColor = YMColors.FontGray

        CompletePanel.hidden = true
        WaitCompletePanel.hidden = false
        WaitReplyPanel.hidden = true
        
        TabIndcBorder.align(Align.UnderCentered,
            relativeTo: WaitCompleteTabButton!,
            padding: -4.LayoutVal(),
            width: 120.LayoutVal(), height: 4.LayoutVal())
    }
    
    public func ShowWaitReplyPanel() {
        if(!WaitReplyPanelDrew) {
            var lastView:UIView? = nil
            let listData = PageMyAdmissionsListViewController.WaitReplyAdmissions
            for data in listData {
                lastView = DrawAdmissionList(data, prevView: lastView, parent: WaitReplyPanel, actionMethod: "AdmissionReplyTouched:".Sel())
            }
            
            if(nil != lastView) {
                YMLayout.SetVScrollViewContentSize(WaitReplyPanel, lastSubView: lastView!)
            }
        }
        
        CurrentPanel = AdmissionSelectedPanelType.WaitReply
        
        WaitReplyPanelDrew = true
        
        CompleteTabTitle.textColor = YMColors.FontGray
        WaitCompleteTabTitle.textColor = YMColors.FontGray
        WaitReplyTabTitle.textColor = YMColors.FontBlue
        
        CompletePanel.hidden = true
        WaitCompletePanel.hidden = true
        WaitReplyPanel.hidden = false
        
        TabIndcBorder.align(Align.UnderCentered,
            relativeTo: WaitReplyTabButton!,
            padding: -4.LayoutVal(),
            width: 120.LayoutVal(), height: 4.LayoutVal())
    }

    private func DrawMessages(msgList: [[YMMyAdmissionsMessage]]) {
        var lastView: UIView? = nil
        for msgOneDay in msgList {
            for oneMsg in msgOneDay {
                lastView = DrawTimeLabel(oneMsg, viewBefore: lastView)
            }
        }
    }
    
    private func DrawAdmissionList(data: [String: AnyObject], prevView: UIView?, parent: UIView, actionMethod: Selector) -> UIView? {
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: actionMethod)
        cell.UserObjectData = data

        print(data)
//    ["doctor_job_title": 副主任医师,
//    "doctor_head_url": /uploads/avatar/2.jpg,
//    "doctor_name": test, "time": 2016-06-09 上午,
//    "patient_head_url": <null>,
//    "patient_name": 123,
//    "doctor_id": 1,
//    "id": 011605130002,
//    "patient_age": 56,
//    "patient_gender": 1,
//    "who": 医生代约,
//    "status": 待确认,
//    "doctor_is_auth": 0]
        
        let docId = YMVar.GetStringByKey(data, key: "doctor_id")
        if(docId != YMVar.MyDoctorId) {
            return prevView
        }
        
        parent.addSubview(cell)
        if(nil == prevView) {
//            cell.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 151.LayoutVal())
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 151.LayoutVal())
        } else {
//            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevView!, padding: 0, height: 151.LayoutVal())
            cell.align(Align.UnderMatchingLeft, relativeTo: prevView!, padding: 0, width: YMSizes.PageWidth, height: 151.LayoutVal())
        }

        let borderBottom = UIView()
        borderBottom.backgroundColor = YMColors.DividerLineGray
        
        cell.addSubview(borderBottom)
        borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        let headImage = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let name = UILabel()
        let basicInfo = UILabel()
        let locationIcon = YMLayout.GetSuitableImageView("YMIconTimelineNotepadBlue")
        let timeIcon = YMLayout.GetSuitableImageView("YMIconClockBlue")
        let location = UILabel()
        let time = UILabel()
        let type = UILabel()
        let status = UILabel()
        let divider = UIView()
        
        let genderMap = ["1":"男", "0":"女"]
        
        name.text = "\(data["patient_name"]!)"
        let genderIdx = data["patient_gender"]! as? String
        var age = data["patient_age"] as? String
        if(nil == age) {
            age = ""
        } else {
            age = "\(age!)岁"
        }
        if(nil != genderIdx) {
            location.text = "\(genderMap[genderIdx!]!) \(age!)"
        } else {
            location.text = "\(age)"
        }
        basicInfo.text = "患者"
//        location.text = data["hospital"] as? String
        time.text = "\(data["time"]!)"
        status.text = "\(data["status"]!)"
        type.text = "\(data["who"]!)"
        
        name.textColor = YMColors.FontBlue
        basicInfo.textColor = YMColors.FontGray
        location.textColor = YMColors.FontBlue
        time.textColor = YMColors.FontLightGray
        type.textColor = YMColors.FontBlue
        divider.backgroundColor = YMColors.FontBlue
        if("待确认" == status.text) {
            status.textColor = YMColors.WarningFontColor
        } else {
            status.textColor = YMColors.FontLightBlue
        }
        
        name.font = YMFonts.YMDefaultFont(30.LayoutVal())
        basicInfo.font = YMFonts.YMDefaultFont(20.LayoutVal())
        location.font = YMFonts.YMDefaultFont(22.LayoutVal())
        time.font = YMFonts.YMDefaultFont(22.LayoutVal())
        type.font = YMFonts.YMDefaultFont(22.LayoutVal())
        status.font = YMFonts.YMDefaultFont(22.LayoutVal())
        
        name.sizeToFit()
        basicInfo.sizeToFit()
        location.sizeToFit()
        time.sizeToFit()
        status.sizeToFit()
        
        type.frame = CGRect(x: 0,y: 0,width: 110.LayoutVal(), height: 30.LayoutVal())
        type.textAlignment = NSTextAlignment.Center
        type.layer.cornerRadius = 10.LayoutVal()
        type.layer.masksToBounds = true
        type.layer.borderWidth = YMSizes.OnPx
        type.layer.borderColor = YMColors.FontBlue.CGColor
        
        cell.addSubview(name)
        cell.addSubview(basicInfo)
        cell.addSubview(location)
        cell.addSubview(time)
        cell.addSubview(type)
        cell.addSubview(status)
        cell.addSubview(headImage)
        cell.addSubview(locationIcon)
        cell.addSubview(timeIcon)
        cell.addSubview(divider)
        
        headImage.anchorToEdge(Edge.Left,
                               padding: 41.LayoutVal(),
                               width: headImage.width,
                               height: headImage.height)
        let head = data["patient_head_url"] as? String
        if(nil != head) {
            YMLayout.LoadImageFromServer(headImage, url: head!, fullUrl: nil, makeItRound: true)
        }
        
        name.anchorInCorner(Corner.TopLeft,
                            xPad: 180.LayoutVal(),
                            yPad: 25.LayoutVal(),
                            width: name.width,
                            height: name.height)
        
        divider.align(Align.ToTheRightCentered,
                      relativeTo: name, padding: 20.LayoutVal(),
                      width: YMSizes.OnPx, height: 20.LayoutVal())
        
        basicInfo.align(Align.ToTheRightCentered,
                        relativeTo: divider, padding: 20.LayoutVal(),
                        width: basicInfo.width,
                        height: basicInfo.height)
        
        type.align(Align.ToTheRightCentered,
                     relativeTo: basicInfo,
                     padding: 20.LayoutVal(),
                     width: type.width,
                     height: type.height)
        
        locationIcon.align(Align.UnderMatchingLeft,
                           relativeTo: name,
                           padding: 10.LayoutVal(),
                           width: timeIcon.width,
                           height: timeIcon.height)
        
        location.align(Align.ToTheRightCentered,
                       relativeTo: locationIcon,
                       padding: 8.LayoutVal(),
                       width: location.width,
                       height: location.height)
        
        timeIcon.align(Align.UnderCentered,
                       relativeTo: locationIcon,
                       padding: 13.LayoutVal(),
                       width: timeIcon.width,
                       height: timeIcon.height)
        
        time.align(Align.ToTheRightCentered,
                   relativeTo: timeIcon,
                   padding: 8.LayoutVal(),
                   width: time.width,
                   height: time.height)
        
        status.anchorInCorner(Corner.TopRight,
                              xPad: 40.LayoutVal(),
                              yPad: 25.LayoutVal(),
                              width: status.width,
                              height: status.height)

        return cell
    }
    
    public func DrawSpecialClearButton() {
        let clearButton = YMButton()
        ParentView?.addSubview(clearButton)
        
        clearButton.addTarget(Actions, action: "ClearMessageList:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        clearButton.setTitle("清空", forState: UIControlState.Normal)
        clearButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        clearButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        clearButton.setBackgroundImage(UIImage(named: "PageMyAdmissionListButtonClearBackground"), forState: UIControlState.Normal)
        clearButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 64.LayoutVal(), width: 84.LayoutVal(), height: 42.LayoutVal())
    }
    
    private func DrawTimeLabel(msg: YMMyAdmissionsMessage?, viewBefore: UIView? = nil) -> UIView? {
        if(nil == msg) { return nil }
        let timeLabel = UILabel()
        BodyView.addSubview(timeLabel)
        
        let today = YMDatetimeString.Today()
        let yesterday = YMDatetimeString.Yesterday()
        
        let msgTimeArr = msg?.datatime.componentsSeparatedByString(" ")
        let msgDay = msgTimeArr?.first
        let msgTime = msgTimeArr?[1]
        
        if(today == msgDay){
            timeLabel.text = msgTime
        } else if(yesterday == msgDay) {
            timeLabel.text = "昨天"
        } else {
            timeLabel.text = msgDay
        }
        
        timeLabel.textColor = YMColors.FontGray
        timeLabel.font = YMFonts.YMDefaultFont(timeFontSize)
        timeLabel.sizeToFit()
        timeLabel.textAlignment = NSTextAlignment.Center
        
        if(nil == viewBefore){
            timeLabel.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 40.LayoutVal(), otherSize: timeFontSize)
        } else {
            timeLabel.align(Align.UnderCentered, relativeTo: viewBefore!, padding: normalPadding, width: timeLabel.width, height: timeLabel.height)
        }
        return timeLabel
    }
    
    public func ReLoad() {
        YMLayout.ClearView(view: CompletePanel)
        YMLayout.ClearView(view: WaitCompletePanel)
        YMLayout.ClearView(view: WaitReplyPanel)
        
        CompletePanelDrew = false
        WaitCompletePanelDrew = false
        WaitReplyPanelDrew = false
        
        switch (CurrentPanel) {
        case AdmissionSelectedPanelType.WaitReply:
            ShowWaitReplyPanel()
        case AdmissionSelectedPanelType.WaitComplete:
            ShowWaitCompletePanel()
        case AdmissionSelectedPanelType.Complete:
            ShowCompletePanel()
        }
    }
    
    public func Clear() {
        YMLayout.ClearView(view: CompletePanel)
        YMLayout.ClearView(view: WaitCompletePanel)
        YMLayout.ClearView(view: WaitReplyPanel)
        
        CompletePanelDrew = false
        WaitCompletePanelDrew = false
        WaitReplyPanelDrew = false
    }
}
















