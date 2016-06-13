//
//  PageMyAdmissionsListBodyView.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public struct YMMyAdmissionsMessage {
    var MsgId: String
    var MsgContent: String
    var StatusString: String
    var Status: String
    var datatime: String
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

    private let MockData = [
        [
            YMMyAdmissionsMessage(MsgId: "1", MsgContent: "测试消息1", StatusString: "去查看", Status: "0", datatime: "2016-04-29 09:08:07")
        ],
        
        [
            YMMyAdmissionsMessage(MsgId: "2", MsgContent: "测试消息2", StatusString: "去处理", Status: "1", datatime: "2016-04-28 09:08:07")
        ],
        
        [
            YMMyAdmissionsMessage(MsgId: "3", MsgContent: "测试消息3", StatusString: "去回复", Status: "2", datatime: "2016-04-27 09:08:07")
        ]
    ]
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        
//        DrawSpecialClearButton()
//        DrawMessages(MockData)
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

        CompletePanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        WaitCompletePanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        WaitReplyPanel.align(Align.UnderMatchingLeft, relativeTo: TabPanel, padding: 0, width: YMSizes.PageWidth, height: 0)
        
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
            padding: 0, width: 1.LayoutVal(), height: 30.LayoutVal())
        
        divider2.align(Align.ToTheRightCentered, relativeTo: WaitCompleteTabButton!,
            padding: 0, width: 1.LayoutVal(), height: 30.LayoutVal())
        
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
                lastView = DrawAdmissionList(data, prevView: lastView, parent: CompletePanel)
            }
        }
        
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
                lastView = DrawAdmissionList(data, prevView: lastView, parent: WaitCompletePanel)
            }
        }
        
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
                lastView = DrawAdmissionList(data, prevView: lastView, parent: WaitReplyPanel)
            }
        }
        
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
    
    private func DrawAdmissionList(data: [String: AnyObject], prevView: UIView?, parent: UIView) -> UIView {
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "AdmissionTouched:".Sel())
        
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
        
        
        parent.addSubview(cell)
        if(nil == prevView) {
            cell.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: 151.LayoutVal())
        } else {
            cell.alignAndFillWidth(align: Align.UnderMatchingLeft, relativeTo: prevView!, padding: 0, height: 151.LayoutVal())
        }

        let borderBottom = UIView()
        borderBottom.backgroundColor = YMColors.DividerLineGray
        
        cell.addSubview(borderBottom)
        borderBottom.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: 1.LayoutVal())

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
        
        ShowWaitReplyPanel()
    }
}
















