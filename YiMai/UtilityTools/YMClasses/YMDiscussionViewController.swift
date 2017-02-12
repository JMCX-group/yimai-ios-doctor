//
//  YMChatViewController.swift
//  YiMai
//
//  Created by ios-dev on 16/7/24.
//  Copyright © 2016年 why. All rights reserved.
//

import Foundation
import Neon
import SwiftyJSON
import Proposer

public class YMDiscussionViewController: RCConversationViewController, RCIMReceiveMessageDelegate {
    var TopView: PageCommonTopView? = nil
    var ViewTitle: String = ""
    var Discussion: RCDiscussion? = nil
//    var UserData: [String: AnyObject]? = nil
    var IsCreator: Bool = false
    var AllowInvite: Bool = false
    
    var IMSettingButton: YMTouchableImageView!

//    var QuitDiscussion = YMButton()
    var FullPageLoading: YMPageLoadingView!
    
    var UpdateApi: YMAPIUtility!
    
    var JumpAction: PageJumpActions!
    
    var CardInfo: [String: AnyObject]? = nil
    
    var SilentFlag: Bool? = nil
    
    let SilentIcon = YMLayout.GetSuitableImageView("IMDiscussionSilentIcon")
    
    var LoacalSilentDataKey = YMLocalDataStrings.DISCUSSION_SILENT_FLAG + YMVar.MyDoctorId

    override public func viewDidLoad() {
        super.viewDidLoad()
        RCIM.sharedRCIM().clearUserInfoCache()
        
        LoacalSilentDataKey += targetId

        TopView = PageCommonTopView(parentView: self.view!, titleString: ViewTitle, navController: self.navigationController!)
        
        SilentFlag = YMLocalData.GetData(LoacalSilentDataKey) as? Bool
        
        SilentIcon.hidden = true
        DrawSilentIcon()
        
        if(nil != SilentFlag) {
            if(SilentFlag!) {
                SilentIcon.hidden = false
            } else {
                SilentIcon.hidden = true
            }
        }
        
        
        let messageListHeight = YMSizes.PageHeight - YMSizes.PageTopHeight - self.chatSessionInputBarControl.height
        self.conversationMessageCollectionView.align(Align.UnderMatchingLeft, relativeTo: TopView!.TopViewPanel,
                                                     padding: 0, width: YMSizes.PageWidth, height: messageListHeight)
        
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
        JumpAction = PageJumpActions(navController: self.navigationController!)
        
        
        IMSettingButton = YMLayout.GetTouchableImageView(useObject: self, useMethod: "DiscussionSetting:".Sel(), imageName: "YMIconSetting")
        TopView?.TopViewPanel.addSubview(IMSettingButton)
        IMSettingButton!.anchorInCorner(Corner.BottomRight, xPad: 20.LayoutVal(), yPad: 24.LayoutVal(), width: IMSettingButton!.width, height: IMSettingButton!.height)


//        QuitDiscussion.setTitle("退出群聊", forState: UIControlState.Normal)
//        QuitDiscussion.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
//        QuitDiscussion.sizeToFit()
//        QuitDiscussion.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(),
//                                        width: QuitDiscussion.width, height: 30.LayoutVal())
//        QuitDiscussion.addTarget(self, action: "QuiteDiscussionTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        FullPageLoading = YMPageLoadingView(parentView: self.view!)
        
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_BLACKLIST, success: UpdateBlacklistSuccess, error: UpdateBlacklistError)
        
//        if(nil != UserData) {
//            let hos = UserData!["hospital"] as? [String: AnyObject]
//            if(nil != hos) {
//                UserData!["hospital"] = YMVar.GetStringByKey(hos, key: "name")
//            }
//            
//            let dept = UserData!["department"] as? [String: AnyObject]
//            if(nil != dept) {
//                UserData!["department"] = YMVar.GetStringByKey(dept, key: "name")
//            }
//        }

        registerClass(YMIMCellForCard.self, forCellWithReuseIdentifier: "YMIMCell")
        
        ProposeMic()
        if(nil == Discussion) {
            GetDiscussion()
        } else {
            if(Discussion!.creatorId == YMVar.MyDoctorId) {
                self.IsCreator = true
            }
            
            if(0 == Discussion!.inviteStatus) {
                self.AllowInvite = true
            }
        }
    }
    
    func DrawSilentIcon() {
        TopView?.TopViewPanel.addSubview(SilentIcon)
        let tempLabel = YMLayout.GetNomalLabel(ViewTitle, textColor: YMColors.White, fontSize: YMSizes.PageTopTitleFontSize)
        let silentIconMargin = (YMSizes.PageWidth - tempLabel.width) / 2 + tempLabel.width + 10.LayoutVal() - YMSizes.PageWidth
        SilentIcon.align(Align.ToTheRightCentered, relativeTo: TopView!.TopTitle,
                         padding: silentIconMargin, width: SilentIcon.width, height: SilentIcon.height)
    }
    
    func GetDiscussion() {
        RCIMClient.sharedRCIMClient().getDiscussion(targetId, success: { (discussion) in
            self.Discussion = discussion
            YMDelay(0.1, closure: {
                if(discussion.creatorId == YMVar.MyDoctorId) {
                    self.IsCreator = true
                }
                
                if(0 == discussion.inviteStatus) {
                    self.AllowInvite = true
                }
            })
            }, error: { (error) in
                //DoNothing
                print("get discussion failed \(error.rawValue)")
        })
        
        RCIMClient.sharedRCIMClient().getConversationNotificationStatus(RCConversationType.ConversationType_DISCUSSION,
                                                                        targetId: targetId,
                                                                        success: { (status) in
                                                                            self.SilentFlag = (RCConversationNotificationStatus.DO_NOT_DISTURB == status)
                                                                            YMDelay(0.1, closure: { 
                                                                                if(self.SilentFlag!) {
                                                                                    self.SilentIcon.hidden = false
                                                                                } else {
                                                                                    self.SilentIcon.hidden = true
                                                                                }
                                                                            })
                                                                            YMLocalData.SaveData(self.SilentFlag!, key: self.LoacalSilentDataKey)
            }) { (_) in
                self.SilentFlag = nil
        }
    }
    
    override public func rcConversationCollectionView(collectionView: UICollectionView!, cellForItemAtIndexPath: NSIndexPath!) -> RCMessageBaseCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YMIMCell", forIndexPath: cellForItemAtIndexPath)
        
        let cellDataModel = self.conversationDataRepository[cellForItemAtIndexPath.row] as? RCMessageModel
        
        let realCell = cell as? YMIMCellForCard
        if(nil != realCell) {
            realCell!.CellLayout(cellDataModel!)
            realCell!.JumpActions = JumpAction
        }
        
        return cell as! RCMessageBaseCell
    }
    
    override public func rcConversationCollectionView(collectionView: UICollectionView!, layout: UICollectionViewLayout!, sizeForItemAtIndexPath: NSIndexPath!) -> CGSize {
        return CGSize(width: YMSizes.PageWidth, height: 320.LayoutVal())
    }
    
    func SetCardInfo(info: [String: AnyObject]?) {
        CardInfo = info
    }
    
    func UpdateBlacklistSuccess(data: NSDictionary?) {
        JumpAction.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
    }
    
    func UpdateBlacklistError(error: NSError) {
        YMAPIUtility.PrintErrorInfo(error)
        JumpAction.DoJump(YMCommonStrings.CS_PAGE_INDEX_NAME)
    }
    
    func SendCard() {
        let cardMsg = YMIMMessageContent()
        cardMsg.SenderHeadimgUrl = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "head_url")
        cardMsg.DoctorId = YMVar.GetStringByKey(CardInfo, key: "id")
        cardMsg.DoctorName = YMVar.GetStringByKey(CardInfo, key: "name")
        cardMsg.HeadimgUrl = YMVar.GetStringByKey(CardInfo, key: "head_url")
        cardMsg.Hospital = YMVar.GetStringByKey(CardInfo, key: "hospital")
        cardMsg.Department = YMVar.GetStringByKey(CardInfo, key: "department")
        cardMsg.Jobtitle = YMVar.GetStringByKey(CardInfo, key: "job_title")
        self.sendMessage(cardMsg, pushContent: "个人名片")
    }
    
    func DiscussionSetting(gr: UIGestureRecognizer) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        let memberList = UIAlertAction(title: "成员列表", style: .Default, handler: GoToMemberList)
        let goManagerMember = UIAlertAction(title: "讨论组管理", style: .Default, handler: GoToManagerMember)
        let inviteMember = UIAlertAction(title: "邀请成员", style: .Default, handler: InviteMember)
        let quitGroup = UIAlertAction(title: "退出讨论组", style: .Default, handler: QuiteDiscussionTouched)
        let silentGroup = UIAlertAction(title: "静音", style: .Destructive, handler: SilentDiscussion)
        let unsilentGroup = UIAlertAction(title: "取消静音", style: .Destructive, handler: UnsilentDiscussion)
        let cancelBtn = UIAlertAction(title: "取消", style: .Cancel) { (_) in
            //DoNothing
        }
        goManagerMember.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        memberList.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        inviteMember.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        quitGroup.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        silentGroup.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        unsilentGroup.setValue(YMColors.FontBlue, forKey: "titleTextColor")
        cancelBtn.setValue(YMColors.FontGray, forKey: "titleTextColor")

        if(IsCreator) {
            alertController.addAction(goManagerMember)
            alertController.addAction(inviteMember)
        } else {
            if(AllowInvite) {
                alertController.addAction(inviteMember)
            }
        }
        
        if(nil != Discussion) {
            memberList.enabled = true
        } else {
            memberList.setValue(YMColors.FontLightGray, forKey: "titleTextColor")
            memberList.enabled = false
        }
        
        alertController.addAction(memberList)
        alertController.addAction(quitGroup)
        
        if(nil != SilentFlag) {
            if(SilentFlag!) {
                alertController.addAction(unsilentGroup)
            } else {
                alertController.addAction(silentGroup)
            }
        }

        
        alertController.addAction(cancelBtn)
        
        navigationController!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func InviteSuccess(_: String, _: String, newDiscussion: RCDiscussion) {
        Discussion = newDiscussion
    }
    
    func GoToMemberList(_: UIAlertAction) {
        JumpAction.DoJump(YMCommonStrings.CS_PAGE_IM_DISCUSSION_MEMBER_LIST, ignoreExists: false, userData: Discussion)
    }
    func GoToManagerMember(_: UIAlertAction) {
        JumpAction.DoJump(YMCommonStrings.CS_PAGE_IM_DISCUSSION_SETTING, ignoreExists: false, userData: self)
    }
    
    func InviteMember(_: UIAlertAction) {
        let memberList = Discussion!.memberIdList as! [String]
        PageIMDiscussionInviteListForMemberViewController.InvitedList = memberList
        PageIMDiscussionInviteListForMemberViewController.DiscussionId = targetId
        JumpAction.DoJump(YMCommonStrings.CS_PAGE_IM_DISCUSSION_INVITE_FOR_MEMBER, ignoreExists: false, userData: InviteSuccess)
    }
    
    func SilentDiscussion(_: UIAlertAction) {
        RCIMClient.sharedRCIMClient().setConversationNotificationStatus(RCConversationType.ConversationType_DISCUSSION,
                                                                        targetId: targetId, isBlocked: true,
                                                                        success: { (_) in
                                                                            self.SilentFlag = true
                                                                            YMDelay(0.1, closure: { 
                                                                                self.SilentIcon.hidden = false

                                                                            })
                                                                            YMLocalData.SaveData(self.SilentFlag!, key: self.LoacalSilentDataKey)
            }) { (_) in
                
        }
    }
    
    func UnsilentDiscussion(_: UIAlertAction) {
        RCIMClient.sharedRCIMClient().setConversationNotificationStatus(RCConversationType.ConversationType_DISCUSSION,
                                                                        targetId: targetId, isBlocked: false,
                                                                        success: { (_) in
                                                                            self.SilentFlag = false
                                                                            YMDelay(0.1, closure: {
                                                                                self.SilentIcon.hidden = true
                                                                                
                                                                            })
                                                                            YMLocalData.SaveData(self.SilentFlag!, key: self.LoacalSilentDataKey)
        }) { (_) in
            
        }
    }
    
    func QuiteDiscussionTouched(_: UIAlertAction) {
        YMPageModalMessage.ShowConfirmInfo("是否确定退出讨论组？", nav: navigationController!, ok: { (_) in
            RCIMClient.sharedRCIMClient().quitDiscussion(self.targetId, success: { (_) in
                YMDelay(0.1, closure: {
                    self.navigationController?.popViewControllerAnimated(true)
                })
            }) { (error) in
                print(error.rawValue)
                YMDelay(0.1, closure: {
                    YMPageModalMessage.ShowNormalInfo("网络故障，请稍后再试。", nav: self.navigationController!)
                })
            }
            }, cancel: nil)
        
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PageAppointmentViewController.FromIM = false
        SetSendCardFromIM()
        GetDiscussion()
    }
    
    override public func pluginBoardView(plug: RCPluginBoardView, clickedItemWithTag tag: Int) {
        super.pluginBoardView(plug, clickedItemWithTag: tag)
        if (2017 == tag) {
            CardInfo = nil
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_DOCTOR_NAME, ignoreExists: false, userData: SetCardInfo)
        }
    }
    
    override public func didTapCellPortrait(userId: String) {
        super.didTapCellPortrait(userId)
        if(userId != YMVar.MyDoctorId) {
            PageYiMaiDoctorDetailBodyView.DocId = userId
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_YIMAI_DOCTOR_DETAIL_NAME, ignoreExists: true, userData: "IM")
        }
    }
    
    override public func didTapMessageCell(cellData: RCMessageModel) {
//        let textMsg = cellData.content as? RCTextMessage
//        super.didTapMessageCell(cellData)
//        if(nil != textMsg) {
//            let appointmentInfo = YMVar.TryToGetDictFromJsonStringData(textMsg!.extra!)
//            if(nil == appointmentInfo) {
//                return
//            }
//
//            let id = appointmentInfo!["appointmentId"] as? String
//            if(nil == id) {
//                return
//            }
//            PageAppointmentDetailViewController.AppointmentID = id!
//            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
//        }
    }

    
    func SetSendCardFromIM() {
        self.chatSessionInputBarControl.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        self.chatSessionInputBarControl.pluginBoardView.removeItemWithTag(Int(2017))
        self.chatSessionInputBarControl.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconSendCardFromIM")!, title: "发送名片", tag: 2017)
    }
    
    public func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        self.chatSessionInputBarControl.pluginBoardView.removeItemWithTag(Int(2017))
        self.chatSessionInputBarControl.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconSendCardFromIM")!, title: "发送名片", tag: 2017)
    }
    
    
    public func onRCIMCustomLocalNotification(message: RCMessage, withSenderName: String) -> Bool{
        print("onRCIMCustomLocalNotification")
        
        return true
    }
    
    func ProposeMic() {
        let contacts: PrivateResource = PrivateResource.Microphone
        
        if(contacts.isNotDeterminedAuthorization) {
            proposeToAccess(contacts, agreed: {
                    self.chatSessionInputBarControl.setInputBarType(RCChatSessionInputBarControlType.DefaultType,
                        style: RCChatSessionInputBarControlStyle.CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION)
                }, rejected: {
                    self.chatSessionInputBarControl.setInputBarType(RCChatSessionInputBarControlType.DefaultType,
                        style: RCChatSessionInputBarControlStyle.CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION)
            })
        } else {
            if(!contacts.isAuthorized) {
                self.chatSessionInputBarControl.setInputBarType(RCChatSessionInputBarControlType.DefaultType,
                                                                style: RCChatSessionInputBarControlStyle.CHAT_INPUT_BAR_STYLE_CONTAINER_EXTENTION)
            } else {
                self.chatSessionInputBarControl.setInputBarType(RCChatSessionInputBarControlType.DefaultType,
                                                                style: RCChatSessionInputBarControlStyle.CHAT_INPUT_BAR_STYLE_SWITCH_CONTAINER_EXTENTION)
            }
        }
    }
}

