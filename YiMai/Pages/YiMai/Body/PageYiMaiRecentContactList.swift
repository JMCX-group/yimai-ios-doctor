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
        cell.UserObjectData = docInfo
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
        msgLabel.align(Align.UnderMatchingLeft, relativeTo: nameLabel, padding: 10.LayoutVal(), width: 550.LayoutVal(), height: msgLabel.height)
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
    
    func DrawDiscussionCell(id: String, title: String, lastMsg: String, lastMsgUsername: String, timestamp: Double, prev: YMTouchableView?) -> YMTouchableView {
        let titleLabel = YMLayout.GetNomalLabel(title, textColor: YMColors.FontBlue, fontSize: 30.LayoutVal())
        let msgLabel = YMLayout.GetNomalLabel(lastMsgUsername + " : " + lastMsg, textColor: YMColors.FontGray, fontSize: 26.LayoutVal())
        let timeLabel = YMLayout.GetNomalLabel(YMIMUtility.TimestampToString(timestamp), textColor: YMColors.FontLighterGray, fontSize: 22.LayoutVal())
        let headimgPanel = UIView()
        let bottomBorder = UIView()
        
        let silentFlag = YMLocalData.GetData(YMLocalDataStrings.DISCUSSION_SILENT_FLAG + YMVar.MyDoctorId + id) as? Bool
        
        let cell = YMLayout.GetTouchableView(useObject: Actions!, useMethod: "DoChat:".Sel())
        
        cell.UserObjectData = ["id": id, "title": title, "isDiscussion": "1"]
        
        BodyView.addSubview(cell)
        cell.UserStringData = id
        if (nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: 0, width: YMSizes.PageWidth, height: 150.LayoutVal())
        }
        
        
        cell.addSubview(titleLabel)
        cell.addSubview(timeLabel)
        cell.addSubview(msgLabel)
        cell.addSubview(headimgPanel)
        cell.addSubview(bottomBorder)
        
        headimgPanel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: 110.LayoutVal(), height: 110.LayoutVal())
        titleLabel.anchorInCorner(Corner.TopLeft, xPad: 180.LayoutVal(), yPad: 30.LayoutVal(), width: titleLabel.width, height: titleLabel.height)
        timeLabel.anchorInCorner(Corner.TopRight, xPad: 30.LayoutVal(), yPad: 30.LayoutVal(), width: timeLabel.width, height: timeLabel.height)
        msgLabel.align(Align.UnderMatchingLeft, relativeTo: titleLabel, padding: 10.LayoutVal(), width: 550.LayoutVal(), height: msgLabel.height)
        bottomBorder.backgroundColor = YMColors.DividerLineGray
        bottomBorder.anchorAndFillEdge(Edge.Bottom, xPad: 0, yPad: 0, otherSize: YMSizes.OnPx)
        
        if(nil != silentFlag) {
            if(silentFlag!) {
                let silentFlagIcon = YMLayout.GetSuitableImageView("IMDiscussionSilentIconGray")

                cell.addSubview(silentFlagIcon)
                silentFlagIcon.anchorToEdge(Edge.Left, padding: 10.LayoutVal(), width: silentFlagIcon.width, height: silentFlagIcon.height)
            }
        }
        
        
        let idList = YMLocalData.GetData(YMLocalDataStrings.DISCUSSION_ID + id)
        
        if(nil != idList) {
            YMLayout.GetDiscussionHeadimg((idList as! [String]).joinWithSeparator(","), panel: headimgPanel)
        }
        
        RCIMClient.sharedRCIMClient().getDiscussion(id, success: { (discussion) in
            YMDelay(0.1, closure: {
                let idList: [String] = discussion.memberIdList.map({($0 as! String)})
                YMLocalData.SaveData(idList, key: YMLocalDataStrings.DISCUSSION_ID + id)
                YMLayout.GetDiscussionHeadimg(idList.joinWithSeparator(","), panel: headimgPanel)
            })
            }, error: { (error) in
                //DoNothing
                print("get discussion failed \(error.rawValue)")
        })

        return cell
    }
    
    func LoadData(doctors: [[String: AnyObject]]) {
        
        let imInfo = RCIMClient.sharedRCIMClient().getConversationList([RCConversationType.ConversationType_PRIVATE.rawValue, RCConversationType.ConversationType_DISCUSSION.rawValue])

        YMLayout.ClearView(view: BodyView)
        var docInfo: [String: AnyObject]? = nil
        var cell: YMTouchableView? = nil
        for docImInfo in imInfo {
            let conversation = docImInfo as! RCConversation
            if(conversation.conversationType == RCConversationType.ConversationType_DISCUSSION) {
                var lastMsg = YMIMUtility.GetLastMessageString(docImInfo.lastestMessage)
                if("未知消息" == lastMsg) {
                    lastMsg = ""
                }
                
                let userId = docImInfo.senderUserId
                var lastMsgUserName = YMLocalData.GetData(YMLocalDataStrings.DOC_NAME + userId)

                if(YMVar.MyDoctorId == userId) {
                    lastMsgUserName = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "name")
                } else {
                    if(nil == lastMsgUserName) {
                        lastMsgUserName = "医脉医生"
                    }
                }
                
                cell = DrawDiscussionCell(conversation.targetId,
                                   title: conversation.conversationTitle,
                                   lastMsg: lastMsg,
                                   lastMsgUsername: lastMsgUserName! as! String,
                                   timestamp: Double(conversation.sentTime) / 1000.0,
                                   prev: cell)
                continue
            }
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
























