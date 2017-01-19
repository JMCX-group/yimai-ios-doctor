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
    
    private func GetMessageTouchablePanel(icon: String, title: String, subtitle: String = "暂无信息", method: Selector = YMSelectors.PageJumpByView,time: String = "", hasNewFlag: Bool = false) -> YMTouchableView {
        let panelIcon = YMLayout.GetSuitableImageView(icon)
        let titleLine = UILabel()
        let subtitleLine = UILabel()
        let timeLabel = UILabel()
        let bottomLine = UIView()
        
        let titleFontSize = 30.LayoutVal()
        let subtitleFontSize = 22.LayoutVal()
        let timeFontSize = 22.LayoutVal()
        
        let messagePanel = YMLayout.GetTouchableView(useObject: Actions!, useMethod: method)
        
        
        
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
        var text = "暂无新的系统广播"
        if(0 != YMVar.MyNewBroadcastInfo.count) {
            text = YMVar.MyNewBroadcastInfo["name"] as! String
        }
        
        BroadcastPanel = GetMessageTouchablePanel("MessageListIconBroadCast",
                                                  title: "广播站", subtitle: text,
                                                  method: "BroadcastTouched:".Sel())
        BroadcastPanel?.anchorAndFillEdge(Edge.Top, xPad: 0, yPad: 0, otherSize: PanelHeight)
    }
    
    private func DrawMyAdmission() {
        print(YMVar.MyNewAdmissionInfo)
        
        var text = "暂无新的接诊信息"
        if(0 != YMVar.MyNewAdmissionInfo.count) {
            print(YMVar.MyNewAdmissionInfo)
            text = YMVar.GetStringByKey(YMVar.MyNewAdmissionInfo, key: "text")// YMVar.MyNewAdmissionInfo["text"] as! String
        }
        MyAdmissionPanel = GetMessageTouchablePanel("MessageListIconMyAdmissions",
                                                    title: "我的接诊信息", subtitle: text,
                                                    method: "AdmissionTouched:".Sel())
        MyAdmissionPanel?.align(Align.UnderMatchingLeft, relativeTo: BroadcastPanel!, padding: 0, width: YMSizes.PageWidth, height: PanelHeight)
    }
    
    private func DrawMyAppointment() {
        var text = "暂无新的约诊回复信息"
        if(0 != YMVar.MyNewAppointmentInfo.count) {
            text = YMVar.MyNewAppointmentInfo["text"] as! String
        }
        MyAppointmentPanel = GetMessageTouchablePanel("MessageListIconMyAppointment",
                                                      title: "约诊回复信息", subtitle: text,
                                                      method: "AppointmentTouched:".Sel())
        MyAppointmentPanel?.align(Align.UnderMatchingLeft, relativeTo: MyAdmissionPanel!, padding: 0, width: YMSizes.PageWidth, height: PanelHeight)
    }
}




















