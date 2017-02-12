//
//  PageIMDiscussionMemberListBodyView.swift
//  YiMai
//
//  Created by why on 2017/2/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMDiscussionMemberListBodyView: PageBodyView {
    var ListActions: PageIMDiscussionMemberListActions!
    var Discussion: RCDiscussion!
    var DiscussionId: String = ""

    override func ViewLayout() {
        super.ViewLayout()
        
        ListActions = PageIMDiscussionMemberListActions(navController: NavController!, target: self)
    }
    
    func DrawFullBody() {
        let memberInfo = YMLocalData.GetData(YMLocalDataStrings.DISCUSSION_MEMBER + DiscussionId)
        
        if(nil == memberInfo) {
            FullPageLoading.Show()
        } else {
            LoadData(memberInfo as! [[String: AnyObject]])
        }
        
        let memberList = Discussion.memberIdList as! [String]
        ListActions.GetInfoApi.YMGetRecentContactedDocList(["id_list" : memberList.joinWithSeparator(",")])
    }

    func CellTouched(gr: UIGestureRecognizer) {
        let sender = gr.view as! YMTouchableView
        if(sender.UserStringData == YMVar.MyDoctorId) {
            ListActions.DoJump(YMCommonStrings.CS_PAGE_MY_INFO_CARD)
            return
        }
        
        PageYiMaiDoctorDetailBodyView.DocId = sender.UserStringData
        ListActions.DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME)
    }
    
    func DrawCell(data: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView? {
        let cell = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())
        BodyView.addSubview(cell)
        
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 90.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 90.LayoutVal())
        }
        
        let nameLabel = YMLayout.GetNomalLabel(YMVar.GetStringByKey(data, key: "name"), textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let headimg = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        
        cell.addSubview(nameLabel)
        cell.addSubview(headimg)
        
        cell.UserStringData = YMVar.GetStringByKey(data, key: "id")
        
        YMLayout.LoadImageFromServer(headimg, url: YMVar.GetStringByKey(data, key: "head_url"), fullUrl: nil, makeItRound: true)
        
        headimg.anchorToEdge(Edge.Left, padding: 40, width: 60.LayoutVal(), height: 60.LayoutVal())
        nameLabel.align(Align.ToTheRightCentered, relativeTo: headimg, padding: 10.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        
        return cell
    }
    
    func LoadData(data: [[String: AnyObject]]) {
        YMLayout.ClearView(view: BodyView)
        
        var prev: YMTouchableView? = nil
        for doc in data {
            prev = DrawCell(doc, prev: prev)
        }
        
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: prev)
        
        FullPageLoading.Hide()
    }
}








