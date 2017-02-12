//
//  PageIMDiscussionSettingBodyView.swift
//  YiMai
//
//  Created by why on 2017/2/3.
//  Copyright © 2017年 why. All rights reserved.
//

import Foundation
import Neon

class PageIMDiscussionSettingBodyView: PageBodyView {
    var Discussion: RCDiscussion!
    var DiscussionId: String = ""
    var DiscussionName: String = ""
    var SettingActions: PageIMDiscussionSettingActions!
    
    let AllowInvite = UISwitch()
    var NameCell: YMTouchableView!
    var DiscussionNameLabel = YMLabel()
    let MemberPanel = UIView()
    
    let AllowInviteCell = UIView()

    
    var CurrentData = [[String: AnyObject]]()
    
    override func ViewLayout() {
        super.ViewLayout()
        
        SettingActions = PageIMDiscussionSettingActions(navController: NavController!, target: self)
        AllowInvite.addTarget(self, action: "SetAllowInviteStatus:".Sel(), forControlEvents: UIControlEvents.ValueChanged)
        DrawNameInputCell()
        DrawInviteSwitch()
    }
    
    func SetAllowInviteStatus(_: AnyObject) {
        RCIMClient.sharedRCIMClient()
            .setDiscussionInviteStatus(DiscussionId,
                                       isOpen: AllowInvite.on,
                                       success: {
                                        
            }) { (_) in
                YMDelay(0.1, closure: { 
                    YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试。", nav: self.NavController!)
                    self.AllowInvite.on = !self.AllowInvite.on
                })
        }
    }
    
    func DrawInviteSwitch() {
        
        AllowInviteCell.backgroundColor = YMColors.White

        BodyView.addSubview(AllowInviteCell)
        
        AllowInviteCell.align(Align.UnderMatchingLeft, relativeTo: NameCell, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 90.LayoutVal())
        
        let title = YMLayout.GetNomalLabel("是允许其他成员邀请好友进入讨论组", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        AllowInviteCell.addSubview(title)
        AllowInviteCell.addSubview(AllowInvite)
        
        title.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: title.width, height: title.height)
        AllowInvite.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: AllowInvite.width, height: AllowInvite.height)
    }
    
    func DrawNameInputCell() {
        DiscussionNameLabel = YMLayout.GetNomalLabel("讨论组", textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        NameCell = YMLayout.GetTouchableView(useObject: self, useMethod: "GoToSetDiscussionName:".Sel())
        let arrow = YMLayout.GetSuitableImageView("CommonRightArrowIcon")
        
        BodyView.addSubview(NameCell)
        
        NameCell.anchorToEdge(Edge.Top, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 90.LayoutVal())
        
        NameCell.addSubview(DiscussionNameLabel)
        NameCell.addSubview(arrow)
        
        DiscussionNameLabel.anchorToEdge(Edge.Left, padding: 40.LayoutVal(), width: DiscussionNameLabel.width, height: DiscussionNameLabel.height)
        arrow.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: arrow.width, height: arrow.height)
    }
    
    func UpdateName(text: String) {
        if(YMValueValidator.IsBlankString(text)) {
            return
        }
        RCIMClient.sharedRCIMClient().setDiscussionName(DiscussionId, name: text, success: {
            YMDelay(0.1, closure: { 
                self.DiscussionNameLabel.text = text
                self.DiscussionNameLabel.sizeToFit()
                self.DiscussionName = text
            })
            
            }) { (error) in
                YMDelay(0.1, closure: { 
                    print(error.rawValue)
                    YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试。", nav: self.NavController!)
                })
        }
    }
    
    func GoToSetDiscussionName(gr: UIGestureRecognizer) {
        PageCommonTextInputViewController.TitleString = "修改讨论组名称"
        PageCommonTextInputViewController.Placeholder = "请输入讨论组名称（最多15字符）"
        PageCommonTextInputViewController.InputType = PageCommonTextInputType.Text
        PageCommonTextInputViewController.InputMaxLen = 15
        PageCommonTextInputViewController.Result = UpdateName

        SettingActions.DoJump(YMCommonStrings.CS_PAGE_COMMON_TEXT_INPUT)
    }

    func DrawFullBody() {
        if(0 == Discussion.inviteStatus) {
            AllowInvite.on = true
        } else {
            AllowInvite.on = false
        }
        
        let memberInfo = YMLocalData.GetData(YMLocalDataStrings.DISCUSSION_MEMBER + DiscussionId)
        if(nil == memberInfo) {
            FullPageLoading.Show()
        } else {
            LoadData(memberInfo as! [[String: AnyObject]])
        }
        
        let memberList = Discussion.memberIdList as! [String]
        SettingActions.GetInfoApi.YMGetRecentContactedDocList(["id_list" : memberList.joinWithSeparator(",")])
    }

    func CellTouched(_: AnyObject) {}
    func DrawCell(data: [String: AnyObject], prev: YMTouchableView?) -> YMTouchableView? {
        let cell = YMLayout.GetTouchableView(useObject: self, useMethod: "CellTouched:".Sel())
        MemberPanel.addSubview(cell)
        
        if(nil == prev) {
            cell.anchorToEdge(Edge.Top, padding: 0, width: YMSizes.PageWidth, height: 90.LayoutVal())
        } else {
            cell.align(Align.UnderMatchingLeft, relativeTo: prev!, padding: YMSizes.OnPx, width: YMSizes.PageWidth, height: 90.LayoutVal())
        }
        
        let removeLabel = YMLayout.GetNomalLabel("移出群聊", textColor: YMColors.FontLightGray, fontSize: 28.LayoutVal())
        let nameLabel = YMLayout.GetNomalLabel(YMVar.GetStringByKey(data, key: "name"), textColor: YMColors.FontGray, fontSize: 28.LayoutVal())
        let headimg = YMLayout.GetSuitableImageView("YiMaiGeneralHeadImageBorder")
        
        
        cell.addSubview(nameLabel)
        cell.addSubview(headimg)
        cell.addSubview(removeLabel)
        
        YMLayout.LoadImageFromServer(headimg, url: YMVar.GetStringByKey(data, key: "head_url"), fullUrl: nil, makeItRound: true)
        
        headimg.anchorToEdge(Edge.Left, padding: 40, width: 60.LayoutVal(), height: 60.LayoutVal())
        nameLabel.align(Align.ToTheRightCentered, relativeTo: headimg, padding: 10.LayoutVal(), width: nameLabel.width, height: nameLabel.height)
        removeLabel.anchorToEdge(Edge.Right, padding: 40.LayoutVal(), width: removeLabel.width, height: removeLabel.height)
        
        removeLabel.SetTouchable(withObject: self, useMethod: "RemoveMember:".Sel())
        removeLabel.UserStringData = YMVar.GetStringByKey(data, key: "id")
        removeLabel.UserObjectData = YMVar.GetStringByKey(data, key: "name")

        return cell
    }
    
    func SyncUIForRemove(id: String) {
        for (idx, v) in CurrentData.enumerate() {
            let docId = YMVar.GetStringByKey(v, key: "id")
            if(docId == id) {
                CurrentData.removeAtIndex(idx)
                break
            }
        }
        
        LoadData(CurrentData)
    }
    
    func RemoveMember(gr: UIGestureRecognizer) {
        let sender = gr.view as! YMLabel
        
        let id = sender.UserStringData
        let name = sender.UserObjectData as! String
        YMPageModalMessage.ShowConfirmInfo("确定要将 \(name) 移出群聊？", nav: NavController!, ok: { (_) in
            RCIMClient.sharedRCIMClient().removeMemberFromDiscussion(self.DiscussionId,
                userId: id,
                success: { (discussion) in
                    YMDelay(0.1, closure: { 
                        self.Discussion = discussion
                        self.SyncUIForRemove(id)
                    })
                }, error: { (error) in
                    print(error.rawValue)
                    YMDelay(0.1, closure: { 
                        YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试。", nav: self.NavController!)
                    })
                    
            })
            }, cancel: nil)
    }

    func LoadData(data: [[String: AnyObject]]) {
        CurrentData = data
        
        YMLayout.ClearView(view: MemberPanel)
        BodyView.addSubview(MemberPanel)
        MemberPanel.align(Align.UnderMatchingLeft, relativeTo: AllowInviteCell, padding: 40.LayoutVal(), width: YMSizes.PageWidth, height: 0)
        
        
        var prev: YMTouchableView? = nil
        for doc in data {
            let docId = YMVar.GetStringByKey(doc, key: "id")
            if(docId == YMVar.MyDoctorId) {
                continue
            }
            prev = DrawCell(doc, prev: prev)
        }
        
        YMLayout.SetViewHeightByLastSubview(MemberPanel, lastSubView: prev)
        YMLayout.SetVScrollViewContentSize(BodyView, lastSubView: MemberPanel)
        FullPageLoading.Hide()
    }
}























