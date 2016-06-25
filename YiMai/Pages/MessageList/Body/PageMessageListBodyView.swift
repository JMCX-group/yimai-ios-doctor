//
//  PageMessageListBodyView.swift
//  YiMai
//
//  Created by why on 16/4/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

public class PageMessageListBodyView: PageBodyView {
    private var BroadcastPanel: YMTouchableView? = nil
    private var MyAdmissionPanel: YMTouchableView? = nil
    private var MyAppointmentPanel: YMTouchableView? = nil
    private let PanelHeight = 141.LayoutVal()
    private let PanelFrame = CGRect(x: 0,y: 0,width: YMSizes.PageWidth,height: 141.LayoutVal())
    
    override func ViewLayout() {
        YMLayout.BodyLayoutWithTop(ParentView!, bodyView: BodyView)
        BodyView.backgroundColor = YMColors.BackgroundGray
        
        DrawBroadCast()
        DrawMyAdmission()
        DrawMyAppointment()
    }
    
    private func GetMessageTouchablePanel(icon: String, title: String, subtitle: String = "暂无信息", time: String = "", hasNewFlag: Bool = false) -> YMTouchableView {
        let panelIcon = YMLayout.GetSuitableImageView(icon)
        let titleLine = UILabel()
        let subtitleLine = UILabel()
        let timeLabel = UILabel()
        let bottomLine = UIView()
        
        let titleFontSize = 30.LayoutVal()
        let subtitleFontSize = 22.LayoutVal()
        let timeFontSize = 22.LayoutVal()
        
        let messagePanel = YMLayout.GetTouchableView(useObject: Actions!, useMethod: YMSelectors.PageJumpByView)
        
        
        
        messagePanel.addSubview(panelIcon)
        messagePanel.addSubview(titleLine)
        messagePanel.addSubview(subtitleLine)
        messagePanel.addSubview(timeLabel)
        messagePanel.addSubview(bottomLine)
        
        messagePanel.frame = PanelFrame
        messagePanel.backgroundColor = YMColors.White
        
        bottomLine.backgroundColor = YMColors.DividerLineGray
        bottomLine.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        panelIcon.anchorInCorner(Corner.TopLeft, xPad: 40.LayoutVal(), yPad: 50.LayoutVal(), width: panelIcon.width, height: panelIcon.height)
        
        titleLine.text = title
        titleLine.textColor = YMColors.FontBlue
        titleLine.font = YMFonts.YMDefaultFont(titleFontSize)
        titleLine.sizeToFit()
        titleLine.anchorInCorner(Corner.TopLeft, xPad: 125.LayoutVal(), yPad: 44.LayoutVal(), width: titleLine.width, height: titleLine.height)
        
        subtitleLine.text = subtitle
        subtitleLine.textColor = YMColors.FontGray
        subtitleLine.font = YMFonts.YMDefaultFont(subtitleFontSize)
        subtitleLine.frame = CGRect(x: 0, y: 0, width: 590.LayoutVal(), height: subtitleFontSize)
        subtitleLine.lineBreakMode = NSLineBreakMode.ByTruncatingTail
        subtitleLine.align(Align.UnderMatchingLeft, relativeTo: titleLine, padding: 12.LayoutVal(), width: subtitleLine.width, height: subtitleLine.height)
        
        if("" != time) {
            timeLabel.text = time
            timeLabel.textColor = YMColors.FontLighterGray
            timeLabel.font = YMFonts.YMDefaultFont(timeFontSize)
            timeLabel.sizeToFit()
            timeLabel.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 50.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        }
        
        if(hasNewFlag) {
            //TODO: new message flag
        }
        
        BodyView.addSubview(messagePanel)
        
        return messagePanel
    }
    
    private func DrawBroadCast() {
        BroadcastPanel = GetMessageTouchablePanel("MessageListIconBroadCast", title: "广播站")
        BroadcastPanel?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: PanelHeight)
    }
    
    private func DrawMyAdmission() {
        MyAdmissionPanel = GetMessageTouchablePanel("MessageListIconMyAdmissions", title: "我的接诊信息", subtitle: "您收到一条来自孙权的约诊请求（预约号为252AD），请您及时处理。")
        MyAdmissionPanel?.align(Align.UnderMatchingLeft, relativeTo: BroadcastPanel!, padding: 0, width: YMSizes.PageWidth, height: PanelHeight)
        MyAdmissionPanel?.UserStringData = YMCommonStrings.CS_PAGE_MY_ADMISSIONS_LIST_NAME
    }
    
    private func DrawMyAppointment() {
        MyAppointmentPanel = GetMessageTouchablePanel("MessageListIconMyAppointment", title: "约诊回复信息", subtitle: "张仲景医生已回复您替患者曹操发起的约诊请求（预约号220AD）")
        MyAppointmentPanel?.align(Align.UnderMatchingLeft, relativeTo: MyAdmissionPanel!, padding: 0, width: YMSizes.PageWidth, height: PanelHeight)
    }
}




















