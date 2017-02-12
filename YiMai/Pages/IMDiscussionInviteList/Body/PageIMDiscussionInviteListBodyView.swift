//
//  PageIMDiscussionInviteListBodyView.swift
//  YiMai
//
//  Created by why on 2017/2/2.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMDiscussionInviteListBodyView: PageBodyView {
    var ListAction: PageIMDiscussionInviteListActions!
    var DocSelected = [String: String]()
    var CreateSucess = false
    var DiscussionGroupId = ""
    var Discussion: RCDiscussion? = nil

    override func ViewLayout() {
        super.ViewLayout()
        
        ListAction = PageIMDiscussionInviteListActions(navController: NavController!, target: self)
    }
    
    func CellTouched(gr: UIGestureRecognizer) {
        let sender = gr.view! as! YMTouchableView
        let userData = sender.UserObjectData as! [String: AnyObject]
        let userId = YMVar.GetStringByKey(userData, key: "id")
        
        let checked = userData["checked"] as! UIImageView
        let unchecked = userData["unchecked"] as! UIImageView
        
        let selected = DocSelected[userId]
        
        if(nil == selected) {
            DocSelected[userId] = userId
            checked.hidden = false
            unchecked.hidden = true
        } else {
            DocSelected.removeValueForKey(userId)
            unchecked.hidden = false
            checked.hidden = true
        }
    }
    
    func DrawCell(data: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView? {
        let cell = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())
        BodyView.addSubview(cell)

        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 90.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 90.LayoutVal())
        }
        
        let unchecked = YMLayout.GetSuitableImageView("RegisterCheckboxAgreeUnchecked")
        let checked = YMLayout.GetSuitableImageView("RegisterCheckboxAgreeChecked")
        
        let nameLabel = YMLayout.GetNomalLabel(YMVar.GetStringByKey(data, key: "name"), textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let headimg = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        checked.hidden = true
        
        cell.addSubview(checked)
        cell.addSubview(unchecked)
        cell.addSubview(nameLabel)
        cell.addSubview(headimg)
        
        YMLayout.LoadImageFromServer(headimg, url: YMVar.GetStringByKey(data, key: "head_url"), fullUrl: nil, makeItRound: true)
        
        checked.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: checked.width, height: checked.height)
        unchecked.anchorToEdge(Edge.Left, padding: 20.LayoutVal(), width: unchecked.width, height: unchecked.height)
        headimg.align(Align.ToTheRightCentered, relativeTo: unchecked, padding: 20.LayoutVal(), width: 60.LayoutVal(), height: 60.LayoutVal())
        nameLabel.align(Align.ToTheRightCentered, relativeTo: headimg, padding: 10.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        
        cell.UserObjectData = ["id": YMVar.GetStringByKey(data, key: "id"), "unchecked": unchecked, "checked":checked]
        
        return cell
    }

    func DrawFullBody() {
        Clear()
        
        let l1Doc = YMCoreDataEngine.GetData(YMCoreDataKeyStrings.CS_L1_FRIENDS) as! [[String:AnyObject]]
        
        var prev: YMTouchableView? = nil
        for doc in l1Doc {
            prev = DrawCell(doc, prev: prev)
        }
        
        if(nil == prev) {
            YMPageModalMessage.ShowNormalInfo("您尚无好友，无法建立讨论组。", nav: NavController!, callback: { (_) in
                self.NavController!.popViewControllerAnimated(true)
            })
        }
    }
    
    func Clear() {
        Discussion = nil
        CreateSucess = false
        DiscussionGroupId = ""
        YMLayout.ClearView(view: BodyView)
        DocSelected.removeAll()
    }
    
    func CreateDiscussion(gr: UIGestureRecognizer) {
        if(0 == DocSelected.count) {
            YMPageModalMessage.ShowNormalInfo("至少选择一位好友加入讨论组", nav: NavController!)
            return
        }
        
        RCIMClient.sharedRCIMClient().createDiscussion("讨论组-(\(DocSelected.count + 1)人)", userIdList: DocSelected.values.map({$0}), success: { (discussion) in
            YMDelay(0.1, closure: {
                self.Discussion = discussion
                self.DiscussionGroupId = discussion.discussionId
                self.CreateSucess = true
                self.NavController!.popViewControllerAnimated(true)
            })
            }) { (error) in
                YMDelay(0.1, closure: {
                    print(error.rawValue)
                    YMPageModalMessage.ShowErrorInfo("网络故障，请稍后再试。", nav: self.NavController!)
            })
                
        }
    }
    
    func DrawTopConfirmButton(topView: UIView) {
        let button = YMLayout.GetTouchableView(useObject: self, useMethod: "CreateDiscussion:".Sel())
        
        button.backgroundColor = YMColors.None
        
        let buttonBkg = YMLayout.GetSuitableImageView("TopViewSmallButtonBkg")
        let label = UILabel()
        label.text = "确定"
        label.textColor = YMColors.White
        label.font = YMFonts.YMDefaultFont(30.LayoutVal())
        label.sizeToFit()
        
        button.addSubview(buttonBkg)
        button.addSubview(label)
        
        topView.addSubview(button)
        button.anchorInCorner(Corner.BottomRight, xPad: 30.LayoutVal(), yPad: 24.LayoutVal(), width: buttonBkg.width, height: buttonBkg.height)
        
        buttonBkg.anchorInCenter(width: buttonBkg.width, height: buttonBkg.height)
        label.anchorInCenter(width: label.width, height: label.height)
    }
}



































