//
//  PageYiMaiRecentContactList.swift
//  YiMai
//
//  Created by superxing on 16/9/28.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon

class PageYiMaiRecentContactList: PageBodyView {
    override func ViewLayout() {
        super.ViewLayout()
        
        BodyView.hidden = true
    }
    
    func DrawDoctorCell(docInfo: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView {
//        ["city": <null>,
//         "relation": <null>,
//         "job_title": 住院医师,
//         "head_url": /uploads/avatar/default.jpg,
//            "id": 4,
//            "lastMsg": 【图片】,
//            "hospital": {
//            id = 316;
//            name = "<null>";
//            },
//            "department": {
//                id = 5;
//                name = "<null>";
//            },
//            "name": 呵呵哒]
        let name = "\(docInfo["name"]!)"
        let jobTitle = "\(docInfo["job_title"]!)"
//        let dept = docInfo["department"] as! [String: AnyObject]
//        let deptStr = dept["name"] as? String
        let time = "\(docInfo["time"]!)"
        let lastMsg = "\(docInfo["lastMsg"]!)"
        
        let timestamp = (Double(time)! / 1000.0)

        
        let nameLabel = YMLayout.GetNomalLabel(name, textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        let divder = UIView()
        let jobTitleLabel = YMLayout.GetNomalLabel(jobTitle, textColor: YMColors.FontGray, fontSize: 22.LayoutVal())
//        let deptLabel = YMLayout.GetNomalLabel(deptStr, textColor: YMColors.FontBlue, fontSize: 22.LayoutVal())
        let userHead = YMLayout.GetSuitableImageView("CommonHeadImageBorder")
        let msgLabel = YMLayout.GetNomalLabel(lastMsg, textColor: YMColors.FontLightGray, fontSize: 26.LayoutVal())
        let timeLabel = YMLayout.GetNomalLabel(YMIMUtility.TimestampToString(timestamp), textColor: YMColors.FontLighterGray, fontSize: 22.LayoutVal())
        let bottomBorder = UIView()
        
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "DoChat:".Sel())
        
        BodyView.addSubview(cell)
        cell.UserStringData = "\(docInfo["id"]!)"
        cell.UserObjectData = docInfo//["name": name]
        if (nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        }

        cell.addSubview(nameLabel)
        cell.addSubview(divder)
        cell.addSubview(jobTitleLabel)
//        cell.addSubview(deptLabel)
        cell.addSubview(userHead)
        cell.addSubview(msgLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(bottomBorder)
        
        userHead.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: userHead.width, height: userHead.height)
        nameLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 30.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        divder.backgroundColor = YMColors.FontBlue
        divder.align(Align.ToTheRightCentered, relativeTo: nameLabel, padding: 14.LayoutVal(), width: YMSizes.OnPx, height: 20.LayoutVal())
        jobTitleLabel.align(Align.ToTheRightCentered, relativeTo: divder, padding: 14.LayoutVal(), width: jobTitleLabel.width, height: jobTitleLabel.height)
//        deptLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 20.LayoutVal(), width: deptLabel.width, height: deptLabel.height)
        msgLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 10.LayoutVal(), width: msgLabel.width, height: msgLabel.height)
        timeLabel.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        bottomBorder.backgroundColor = YMColors.DividerLineGray
        bottomBorder.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        YMLayout.LoadImageFromServer(userHead, url: "\(docInfo["head_url"]!)", fullUrl: nil, makeItRound: true)
        
        return cell
    }
    
    func LoadData(doctors: [[String: AnyObject]]) {
        if(0 == doctors.count) {
            return
        }
        let imInfo = RCIMClient.sharedRCIMClient().getConversationList([RCConversationType.ConversationType_PRIVATE.rawValue])

        YMLayout.ClearView(view: BodyView)
        var docInfo = [String: AnyObject]()
        var cell: YMTouchableView? = nil
        for docImInfo in imInfo {
            for doctor in doctors {
                if("\(docImInfo.targetId!)" == "\(doctor["id"]!)" || "\(docImInfo.senderUserId!)" == "\(doctor["id"]!)") {
                    docInfo = doctor
                    break
                }
            }
            docInfo["lastMsg"] = YMIMUtility.GetLastMessageString(docImInfo.jsonDict)
            docInfo["time"] = "\(docImInfo.sentTime)"
            
            cell = DrawDoctorCell(docInfo, prev: cell)
        }
    }
}
























