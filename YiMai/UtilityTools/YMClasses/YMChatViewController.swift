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

public class YMChatViewController: RCConversationViewController, RCIMReceiveMessageDelegate {
    var TopView: PageCommonTopView? = nil
    var ViewTitle: String = ""
    var UserData: [String: AnyObject]? = nil
    var ShowAppointment: Bool = true
    
    var AddToBlackList = YMButton()
    var FullPageLoading: YMPageLoadingView!

    static var SendMsg: [String: String]? = nil
    
    var UpdateApi: YMAPIUtility!
    
    var JumpAction: PageJumpActions!
    
    var CardInfo: [String: AnyObject]? = nil

    override public func viewDidLoad() {
        super.viewDidLoad()
        TopView = PageCommonTopView(parentView: self.view!, titleString: ViewTitle, navController: self.navigationController!)
        
        let messageListHeight = YMSizes.PageHeight - YMSizes.PageTopHeight - self.chatSessionInputBarControl.height
        self.conversationMessageCollectionView.align(Align.UnderMatchingLeft, relativeTo: TopView!.TopViewPanel,
                                                     padding: 0, width: YMSizes.PageWidth, height: messageListHeight)
        
        RCIM.sharedRCIM().receiveMessageDelegate = self
        
        JumpAction = PageJumpActions(navController: self.navigationController!)
        
        TopView?.TopViewPanel.addSubview(AddToBlackList)
        AddToBlackList.setTitle("加入黑名单", forState: UIControlState.Normal)
        AddToBlackList.titleLabel?.font = YMFonts.YMDefaultFont(28.LayoutVal())
        AddToBlackList.sizeToFit()
        AddToBlackList.anchorInCorner(Corner.BottomRight, xPad: 40.LayoutVal(), yPad: 30.LayoutVal(),
                                      width: AddToBlackList.width, height: 30.LayoutVal())
        
        AddToBlackList.addTarget(self, action: "AddToBlackListTouched:".Sel(), forControlEvents: UIControlEvents.TouchUpInside)
        
        FullPageLoading = YMPageLoadingView(parentView: self.view!)
        
        UpdateApi = YMAPIUtility(key: YMAPIStrings.CS_API_ACTION_UPDATE_BLACKLIST, success: UpdateBlacklistSuccess, error: UpdateBlacklistError)
        
        if(nil != UserData) {
            let hos = UserData!["hospital"] as? [String: AnyObject]
            if(nil != hos) {
                UserData!["hospital"] = YMVar.GetStringByKey(hos, key: "name")
            }
            
            let dept = UserData!["department"] as? [String: AnyObject]
            if(nil != dept) {
                UserData!["department"] = YMVar.GetStringByKey(dept, key: "name")
            }
        }

        registerClass(YMIMCellForCard.self, forCellWithReuseIdentifier: "YMIMCell")
    }
    
    override public func rcConversationCollectionView(collectionView: UICollectionView!, cellForItemAtIndexPath: NSIndexPath!) -> RCMessageBaseCell! {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("YMIMCell", forIndexPath: cellForItemAtIndexPath)
        
        let cellDataModel = self.conversationDataRepository[cellForItemAtIndexPath.row] as? RCMessageModel
        
        let realCell = cell as! YMIMCellForCard
        realCell.CellLayout(cellDataModel!)
        realCell.JumpActions = JumpAction
        return realCell
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
    
    func AddToBlackListTouched(sender: YMButton) {
        FullPageLoading.Show()
        var orgBlacklist = YMVar.GetStringByKey(YMVar.MyUserInfo, key: "blacklist")
        let newUser = YMVar.GetStringByKey(UserData!, key: "id")
        
        if("" == orgBlacklist) {
            orgBlacklist = newUser
        } else {
            var orgListArr = orgBlacklist.componentsSeparatedByString(",")
            orgListArr.append(newUser)
            orgBlacklist = orgListArr.joinWithSeparator(",")
        }
        
        UpdateApi.YMChangeUserInfo(["blacklist": orgBlacklist])
        YMVar.MyUserInfo["blacklist"] = orgBlacklist
    }
    
    override public func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        PageAppointmentViewController.FromIM = false
        SetAppointmentFromIM()
        SetSendCardFromIM()

        CheckNeedSendMsg()
    }
    
    override public func pluginBoardView(plug: RCPluginBoardView, clickedItemWithTag tag: Int) {
        super.pluginBoardView(plug, clickedItemWithTag: tag)
        if(2016 == tag) {
            PageAppointmentViewController.DoctorIsPreSelected = true
            PageAppointmentViewController.NewAppointment = true
            PageAppointmentViewController.SelectedDoctor = UserData
            PageAppointmentViewController.FromIM = true
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_NAME)
        } else if (2017 == tag) {
            CardInfo = nil
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_SELECT_DOCTOR_NAME, ignoreExists: false, userData: SetCardInfo)
        }
    }
    
    override public func didTapMessageCell(cellData: RCMessageModel) {
        let textMsg = cellData.content as? RCTextMessage
        
        if(nil != textMsg) {
            let appointmentInfo = YMVar.TryToGetDictFromJsonStringData(textMsg!.extra!)
            if(nil == appointmentInfo) {
                return
            }

            let id = appointmentInfo!["appointmentId"] as? String
            if(nil == id) {
                return
            }
            PageAppointmentDetailViewController.AppointmentID = id!
            JumpAction.DoJump(YMCommonStrings.CS_PAGE_APPOINTMENT_DETAIL_NAME)
        }
    }

    func CheckNeedSendMsg() {
        if(nil != CardInfo) {
            SendCard()
            CardInfo = nil
            return
        }
        if(nil == YMChatViewController.SendMsg) {
            return
        }
        
        let data: [String: String]! = YMChatViewController.SendMsg!
        YMChatViewController.SendMsg = nil
        
        // 生成消息内容
        let text = RCTextMessage(content: "我向您发起了一条约诊，点击查看。")
        text.extra = YMVar.TransObjectToString(data)
        self.sendMessage(text, pushContent: text.content)
    }

    func SetAppointmentFromIM() {
        self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        if(ShowAppointment) {
            self.pluginBoardView.removeItemWithTag(Int(2016))
            self.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconAppointmentFromIM")!, title: "发起约诊", tag: 2016)
        }
    }
    
    func SetSendCardFromIM() {
        self.pluginBoardView.removeItemWithTag(Int(PLUGIN_BOARD_ITEM_LOCATION_TAG))
        if(ShowAppointment) {
            self.pluginBoardView.removeItemWithTag(Int(2017))
            self.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconSendCardFromIM")!, title: "发送名片", tag: 2017)
        }
    }
    
    public func onRCIMReceiveMessage(message: RCMessage!, left: Int32) {
        if(ShowAppointment) {
            self.pluginBoardView.removeItemWithTag(Int(2016))
            self.pluginBoardView.removeItemWithTag(Int(2017))
            self.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconAppointmentFromIM")!, title: "发起约诊", tag: 2016)
            self.pluginBoardView.insertItemWithImage(UIImage(named: "YMIconSendCardFromIM")!, title: "发送名片", tag: 2017)
        }
    }
    
    
    public func onRCIMCustomLocalNotification(message: RCMessage, withSenderName: String) -> Bool{
        print("onRCIMCustomLocalNotification")
        
        return true
    }
}

