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
        
        DrawSpecialClearButton()
        DrawMessages(MockData)
    }
    
    private func DrawMessages(msgList: [[YMMyAdmissionsMessage]]) {
        var lastView: UIView? = nil
        for msgOneDay in msgList {
            for oneMsg in msgOneDay {
                lastView = DrawMessagePanel(oneMsg, viewBefore: lastView)
            }
        }
    }
    
    private func DrawSpecialClearButton() {
        let clearButton = YMButton()
        ParentView?.addSubview(clearButton)
        
        clearButton.addTarget(Actions, action: "ClearMessageList:", forControlEvents: UIControlEvents.TouchUpInside)
        
        clearButton.setTitle("清空", forState: UIControlState.Normal)
        clearButton.setTitleColor(YMColors.White, forState: UIControlState.Normal)
        clearButton.titleLabel?.font = YMFonts.YMDefaultFont(30.LayoutVal())
        clearButton.setBackgroundImage(UIImage(named: "PageMyAdmissionListButtonClearBackground"), forState: UIControlState.Normal)
        clearButton.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 64.LayoutVal(), width: 84.LayoutVal(), height: 42.LayoutVal())
        
        clearButton.layer.zPosition = 1.0
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
    
    private func DrawMessagePanel(msg: YMMyAdmissionsMessage, viewBefore: UIView? = nil) -> UIView{
        let msgPanel = UIView()
        let timeLabel = DrawTimeLabel(msg, viewBefore: viewBefore)
        
        BodyView.addSubview(msgPanel)
        
        return msgPanel
    }
}
















