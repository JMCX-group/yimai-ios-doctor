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
    static var PrevData = [[String: AnyObject]]()
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
        let name = YMVar.GetStringByKey(docInfo, key: "name")
        let jobTitle = YMVar.GetStringByKey(docInfo, key: "job_title", defStr: "医生")
//        let dept = docInfo["department"] as! [String: AnyObject]
//        let deptStr = dept["name"] as? String
        let time = YMVar.GetStringByKey(docInfo, key: "time")
        let lastMsg = YMVar.GetStringByKey(docInfo, key: "lastMsg")
        
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
        
        let unreadCount = docInfo["unread"] as! Int
        if(unreadCount > 0) {
            let unreadLabel = YMLayout.GetUnreadCountLabel(unreadCount)
            cell.addSubview(unreadLabel)
            unreadLabel.align(Align.UnderMatchingRight, relativeTo: timeLabel, padding: 14.LayoutVal(), width: unreadLabel.width, height: unreadLabel.height)
        }
        
        YMLayout.SetDocfHeadImageVFlag(userHead, docInfo: docInfo)
        YMLayout.LoadImageFromServer(userHead, url: "\(docInfo["head_url"]!)", fullUrl: nil, makeItRound: true)
        
        return cell
    }
    
    func LoadData(doctors: [[String: AnyObject]]) {
        if(0 == doctors.count) {
            YMLayout.ClearView(view: BodyView)
            return
        }
        let imInfo = RCIMClient.sharedRCIMClient().getConversationList([RCConversationType.ConversationType_PRIVATE.rawValue])

        YMLayout.ClearView(view: BodyView)
        var docInfo: [String: AnyObject]? = nil
        var cell: YMTouchableView? = nil
        for docImInfo in imInfo {
            for doctor in doctors {
                if("\(docImInfo.targetId!)" == "\(doctor["id"]!)" || "\(docImInfo.senderUserId!)" == "\(doctor["id"]!)") {
                    if(YMVar.IsDocInBlacklist(docImInfo.targetId!) || YMVar.IsDocInBlacklist(docImInfo.senderUserId!)) {
                        continue
                    }
                    docInfo = doctor
                    break
                }
            }
            
            if(nil != docInfo) {
                docInfo!["lastMsg"] = YMIMUtility.GetLastMessageString(docImInfo.lastestMessage)
                docInfo!["time"] = "\(docImInfo.sentTime)"
                docInfo!["unread"] = docImInfo.unreadMessageCount
                
                cell = DrawDoctorCell(docInfo!, prev: cell)
                
                docInfo = nil
            }
            
        }
    }
    
    func FilterDoc(idsInBlackList: [String]) {
        var newData = [[String:AnyObject]]()
        for doc in PageYiMaiRecentContactList.PrevData {
            for blackId in idsInBlackList {
                let id = YMVar.GetStringByKey(doc, key: "id")
                if(id != blackId) {
                    newData.append(doc)
                }
            }
        }
        
//        PageYiMaiRecentContactList.PrevData = newData
        LoadData(PageYiMaiRecentContactList.PrevData)
    }
}
























