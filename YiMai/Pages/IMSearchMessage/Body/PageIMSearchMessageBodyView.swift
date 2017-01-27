//
//  PageIMSearchMessageBodyView.swift
//  YiMai
//
//  Created by why on 2017/1/25.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftDate

class PageIMSearchMessageBodyView: PageBodyView {
    var SearchActions: PageIMSearchMessageActions!
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SearchActions = PageIMSearchMessageActions(navController: NavController, target: self)
    }
    
    func CellTouched(gr: UIGestureRecognizer) {
        
    }
    
    func DrawResultCell(msg: RCMessage, prev: YMTouchableView?, key: String) -> YMTouchableView? {
        
        let textMsg = msg.content as? RCTextMessage
        if(nil == textMsg) {
            return prev
        }
        
        let timeInterval:NSTimeInterval = NSTimeInterval(msg.sentTime / 1000)

        let sendDate = NSDate(timeIntervalSince1970: timeInterval)
        let timeLabel = YMLayout.GetNomalLabel(sendDate.toString(DateFormat.Custom("yyyy-MM-dd HH:mm:ss")),
                                               textColor: YMColors.FontLightGray, fontSize: 24.LayoutVal())

        let cell = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())
        let content = textMsg!.content
        let targetId = msg.targetId
        let userHead = YMVar.GetLocalUserHeadurl(msg.senderUserId)
        var userName = YMLocalData.GetData(YMLocalDataStrings.DOC_NAME + targetId) as? String

        
        if(nil == userName) {
            userName = " "
        }

        let userLabel = YMLayout.GetNomalLabel(userName!, textColor: YMColors.FontGray, fontSize: 24.LayoutVal())
        
        cell.UserStringData = targetId
        
        BodyView.addSubview(cell)
        if(nil != prev) {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        }
        
        let headImg = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        cell.addSubview(headImg)
        cell.addSubview(timeLabel)
        cell.addSubview(userLabel)
        
        headImg.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: headImg.width, height: headImg.height)
        YMLayout.LoadImageFromServer(headImg, url: userHead, fullUrl: nil, makeItRound: true)
        userLabel.align(Align.ToTheRightMatchingTop, relativeTo: headImg, padding: 20.LayoutVal(), width: userLabel.width, height: userLabel.height)
        timeLabel.anchorInCorner(Corner.TopRight, xPad: 40.LayoutVal(), yPad: 20.LayoutVal(), width: timeLabel.width, height: timeLabel.height)

        let contentLabel = YMLayout.GetNomalLabel(content, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        let highlight = ActiveType.Custom(pattern: key)
        contentLabel.enabledTypes = [highlight]
        contentLabel.customColor[highlight] = YMColors.FontBlue

        contentLabel.text = content
        contentLabel.numberOfLines = 0
        contentLabel.frame = CGRect(x: 0, y: 0, width: 550.LayoutVal(), height: 0)
        contentLabel.sizeToFit()
        
        
        cell.addSubview(contentLabel)
        
        contentLabel.align(Align.UnderMatchingLeft, relativeTo: userLabel, padding: 10.LayoutVal(), width: contentLabel.width, height: contentLabel.height)

        
//        let contentLabelBottom = contentLabel.height + 60.LayoutVal() + timeLabel.height
        
        if((contentLabel.frame.origin.y + contentLabel.height + 20.LayoutVal()) > cell.height) {
            YMLayout.SetViewHeightByLastSubview(cell, lastSubView: contentLabel, bottomPadding: 20.LayoutVal())
        }
        
        return cell
    }
    
    func LoadData(data: [RCMessage], key: String) {
        var prev: YMTouchableView? = nil
        for msg in data {
            prev = DrawResultCell(msg, prev: prev, key: key)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev)
    }
    
    func Clear() {
        YMLayout.ClearView(view: BodyView)
    }
}




































